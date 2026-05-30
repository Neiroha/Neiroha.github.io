---
title: Run from Source
sidebar_label: Developer Source Setup
---

This page is for developers who need to change code, debug issues, or submit pull requests. For normal use, prefer [Install Release Builds](/guide/install-release). The main repository already uses GitHub Actions to build Windows, Android, and Linux release artifacts.

## Environment

| Tool | Requirement |
|---|---|
| Git | Clone repositories, create branches, and submit pull requests. |
| Flutter | `3.41.6`, matching the main repository CI. |
| Dart | Use the Dart version bundled with Flutter. |
| Java | `17`, required for Android builds. |
| Windows desktop build | Windows 10/11 + Visual Studio 2022 with Desktop development with C++. |
| Android build | Android Studio or Android SDK command-line tools. |
| Linux desktop build | GTK, GStreamer, mpv, CMake, Ninja, and related desktop dependencies. |

Check the environment first:

```bash
flutter doctor
```

For Windows-only desktop development, the Windows desktop toolchain must be available. For Android builds, the Android toolchain and Java 17 must also be available.

## Fork and Clone

External contributors should fork the main repository and clone their own fork. Avoid committing directly to upstream `main` or `dev`.

1. Open [Neiroha/Neiroha](https://github.com/Neiroha/Neiroha).
2. Click **Fork** and create a fork under your own account.
3. Clone your fork:

```bash
git clone https://github.com/<your-name>/Neiroha.git
cd Neiroha
```

4. Add the upstream repository:

```bash
git remote add upstream https://github.com/Neiroha/Neiroha.git
git fetch upstream
```

5. Create a feature branch from upstream `dev`:

```bash
git switch dev
git pull upstream dev
git switch -c feature/<short-name>
```

Use a short and specific branch name, such as `feature/provider-health-timeout` or `feature/novel-cache-controls`.

## Install Dependencies

```bash
flutter pub get
```

The project uses code generation. Run this after first setup or after changing models, providers, or schemas:

```bash
dart run build_runner build --delete-conflicting-outputs
```

If generated files conflict, first confirm that generated files were not edited manually. In normal cases, rerunning the command is enough.

## Run the Windows Desktop App

```bash
flutter config --enable-windows-desktop
flutter run -d windows
```

Common development flow:

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter analyze
flutter test
flutter run -d windows
```

Windows debug bundle:

```bash
flutter build windows --debug
```

Typical output path:

```text
build/windows/x64/runner/Debug/
```

## Build an Android Debug APK

After Android SDK and Java 17 are available:

```bash
flutter pub get
flutter build apk --debug
```

Output path:

```text
build/app/outputs/flutter-apk/app-debug.apk
```

Install to a connected device or emulator:

```bash
flutter install -d <device-id>
```

List devices:

```bash
flutter devices
```

## Local Checks

Before submitting changes, run at least:

```bash
flutter analyze
flutter test
```

If code generation is involved:

```bash
dart run build_runner build --delete-conflicting-outputs
```

If platform build behavior changed, run the affected builds:

```bash
flutter build windows --debug
flutter build apk --debug
flutter build linux --debug
```

Linux builds require system packages. You do not need to force a Linux build locally on Windows; pull requests are validated on Linux runners.

## Commit Code

Commit on your `feature/<short-name>` branch:

```bash
git status
git add <changed-files>
git commit -m "feat: describe the change"
git push origin feature/<short-name>
```

Common commit prefixes:

| Prefix | Use |
|---|---|
| `feat:` | New feature |
| `fix:` | Bug fix |
| `docs:` | Documentation |
| `refactor:` | Refactor |
| `test:` | Tests |
| `chore:` | Build, dependencies, maintenance |

## Open a Pull Request

1. Open a pull request from your fork on GitHub.
2. Set `base repository` to `Neiroha/Neiroha`.
3. Set `base` to `dev`; do not target `main` directly.
4. Set `compare` to your `feature/<short-name>` branch.
5. Use a title that describes the user-visible change or fix.
6. In the PR description, include:
   - What changed.
   - Why it changed.
   - Local commands you ran.
   - Whether it affects Windows, Android, Linux, migrations, or existing projects.
7. Wait for GitHub Actions checks.
8. Address human review feedback by pushing to the same feature branch.
9. Maintainers merge into `dev` only after workflow checks and human review pass.

Pull requests currently trigger:

| Workflow | Purpose |
|---|---|
| `native-tests.yml` | `flutter analyze` and `flutter test` |
| `native-debug-builds.yml` | Android debug APK, Linux debug bundle, Windows debug bundle |

`native-release-builds.yml` runs only for release tags or manual release dispatch. Normal pull requests do not publish Release assets.

## Sync Upstream dev

For long-lived branches, sync upstream `dev` before merge:

```bash
git fetch upstream
git switch dev
git pull upstream dev
git switch feature/<short-name>
git merge dev
```

After resolving conflicts, rerun local checks and push:

```bash
flutter analyze
flutter test
git push origin feature/<short-name>
```

## GitHub Actions

The main repository supports native GitHub Actions builds. Pull requests produce Android, Linux, and Windows debug artifacts. `v*.*` tags or manual tag inputs produce release assets and publish them to GitHub Releases.

See [GitHub Actions Builds](/operations/github-actions-builds) for details.
