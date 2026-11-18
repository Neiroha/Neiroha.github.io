"""Stage the public Neiroha Web release alongside the built Wiki."""

import argparse
import hashlib
import json
import os
import re
import stat
import tempfile
import zipfile
from pathlib import Path
from urllib.error import HTTPError
from urllib.request import Request, urlopen


REPOSITORY = "Neiroha/Neiroha"
RELEASE_API = f"https://api.github.com/repos/{REPOSITORY}/releases/latest"
LIVE_MANIFEST = "https://neiroha.github.io/demo/release.json"
MAX_ARCHIVE = 100 * 1024 * 1024
MAX_EXPANDED = 200 * 1024 * 1024
REQUIRED_FILES = (
    "index.html", "version.json", "flutter_bootstrap.js", "main.dart.wasm",
    "main.dart.js", "sqlite3.wasm", "drift_worker.js",
)


def get_json(url):
    headers = {"Accept": "application/json", "Cache-Control": "no-cache"}
    if url == RELEASE_API:
        token = os.environ.get("GITHUB_RELEASE_API_TOKEN")
        if token:
            headers["Authorization"] = f"Bearer {token}"
    request = Request(url, headers=headers)
    with urlopen(request, timeout=30) as response:
        return json.load(response)


def release_asset(release):
    tag = release["tag_name"]
    if release["draft"] or release["prerelease"] or not re.fullmatch(r"v\d+\.\d+\.\d+", tag):
        return None
    name = f"neiroha-Web-{tag}.zip"
    asset = next((item for item in release["assets"] if item["name"] == name), None)
    if asset is None or asset["state"] != "uploaded":
        return None
    digest = asset.get("digest") or ""
    if not re.fullmatch(r"sha256:[a-f0-9]{64}", digest):
        raise ValueError(f"Missing valid SHA-256 for {name}")
    if not 0 < asset["size"] <= MAX_ARCHIVE:
        raise ValueError(f"Invalid archive size for {name}")
    return {"tag": tag, "sha256": digest.removeprefix("sha256:"), "size": asset["size"]}


def manifest(asset):
    return {key: asset[key] if asset else None for key in ("tag", "sha256")}


def plan(path, if_changed):
    asset = release_asset(get_json(RELEASE_API))
    path.write_text(json.dumps(asset), encoding="utf-8")
    build = True
    if if_changed:
        try:
            build = get_json(LIVE_MANIFEST) != manifest(asset)
        except HTTPError as error:
            if error.code != 404:
                raise
    print(f"Demo: {asset['tag'] if asset else 'waiting for a stable Web release'}; build: {build}")
    if "GITHUB_OUTPUT" in os.environ:
        with open(os.environ["GITHUB_OUTPUT"], "a", encoding="utf-8") as output:
            print(f"build={str(build).lower()}", file=output)


def download(asset, output):
    tag = asset["tag"]
    url = f"https://github.com/{REPOSITORY}/releases/download/{tag}/neiroha-Web-{tag}.zip"
    digest = hashlib.sha256()
    received = 0
    with urlopen(url, timeout=60) as response, output.open("wb") as archive:
        while chunk := response.read(1024 * 1024):
            received += len(chunk)
            if received > asset["size"]:
                raise ValueError(f"Web archive exceeds its declared size for {tag}")
            digest.update(chunk)
            archive.write(chunk)
    if received != asset["size"] or digest.hexdigest() != asset["sha256"]:
        raise ValueError(f"Web archive integrity check failed for {tag}")


def unpack(archive, tag, destination):
    with zipfile.ZipFile(archive) as bundle:
        entries = bundle.infolist()
        if sum(item.file_size for item in entries) > MAX_EXPANDED:
            raise ValueError("Expanded Web archive exceeds size limit")
        paths = set()
        for item in entries:
            path = item.filename.removesuffix("/")
            if (any(part in ("", ".", "..") for part in path.split("/"))
                    or "\\" in path or ":" in path or stat.S_ISLNK(item.external_attr >> 16)
                    or path in paths):
                raise ValueError(f"Invalid Web archive entry {item.filename!r}")
            paths.add(path)
        for name in REQUIRED_FILES:
            if name not in paths or not bundle.getinfo(name).file_size:
                raise ValueError(f"Web archive is missing {name}")

        version = json.loads(bundle.read("version.json"))["version"]
        if f"v{version}" != tag:
            raise ValueError(f"Web version {version} does not match {tag}")
        index = bundle.read("index.html").decode("utf-8")
        base = '<base href="/">'
        if index.count(base) != 1:
            raise ValueError("Unexpected Flutter base href in index.html")
        bundle.extractall(destination)
        (destination / "index.html").write_text(
            index.replace(base, '<base href="./">'), encoding="utf-8"
        )


def stage(build, asset, local_archive=None):
    if not build.is_dir():
        raise ValueError(f"Build the Wiki before staging the Demo: {build}")
    destination = build / "demo"
    destination.mkdir(exist_ok=False)
    if asset:
        with tempfile.TemporaryDirectory() as temporary:
            archive = local_archive or Path(temporary) / "web.zip"
            if local_archive is None:
                download(asset, archive)
            unpack(archive, asset["tag"], destination)
    (destination / "release.json").write_text(json.dumps(manifest(asset)), encoding="utf-8")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    commands = parser.add_subparsers(dest="command", required=True)
    planner = commands.add_parser("plan")
    planner.add_argument("plan_file", type=Path)
    planner.add_argument("--if-changed", action="store_true")
    stager = commands.add_parser("stage")
    stager.add_argument("plan_file", type=Path)
    stager.add_argument("build", type=Path)
    local = commands.add_parser("local")
    local.add_argument("archive", type=Path)
    local.add_argument("tag")
    local.add_argument("build", type=Path)
    args = parser.parse_args()

    if args.command == "plan":
        plan(args.plan_file, args.if_changed)
    elif args.command == "stage":
        stage(args.build, json.loads(args.plan_file.read_text(encoding="utf-8")))
    else:
        with args.archive.open("rb") as archive:
            digest = hashlib.file_digest(archive, "sha256").hexdigest()
        stage(args.build, {"tag": args.tag, "sha256": digest}, args.archive)


if __name__ == "__main__":
    main()
