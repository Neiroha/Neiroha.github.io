---
title: GitHub Actions Builds
sidebar_label: GitHub Actions Builds
---

Download the build for your platform from [GitHub Releases](https://github.com/Neiroha/Neiroha/releases/latest). See the [release history](../guide/releases.md) for changes by version.

## Application Builds

| Workflow | Trigger | Output |
|---|---|---|
| `native-tests.yml` | Push, PR, manual dispatch | Flutter analysis and tests, Android ARM64 APK compile check |
| `native-debug-builds.yml` | PR, manual dispatch | Native debug builds |
| `native-release-builds.yml` | Version tag, manual dispatch | Windows ZIP, Linux TAR.GZ and universal and split Android APKs. v0.5.0 adds two macOS DMGs and the Web ZIP |
| `web-builds.yml` | PRs touching relevant paths, manual dispatch, release builds | Starting with v0.5.0, `neiroha-Web-<version>.zip` with Flutter Web, SQLite Wasm and the Drift worker |

Release builds place SHA-256 values under **Checksums** in the Release notes. Download debug and PR artifacts from the corresponding Actions run.

## Wiki Web Demo

Wiki deployment fetches the Web ZIP from the latest stable application release. It verifies GitHub's SHA-256 and the version inside the ZIP, then stages the app at `/demo/`. The Chinese and English [Web demo](../guide/web-demo.mdx) pages share that build. Drafts and prereleases are excluded. The demo guide shows a waiting message until a stable release includes a Web asset.

The Wiki checks hourly and redeploys on a version or checksum change. Updates to the Wiki default branch and manual runs also resync the demo. If the application repository has a `WIKI_DISPATCH_TOKEN`, publication of the stable release assets sends an immediate `repository_dispatch` to the Wiki. See the [Wiki repository setup](https://github.com/Neiroha/Neiroha.github.io#web-演示发布).

## Wiki Screenshot Updates

This wiki repository includes a local helper script for updating screenshots from an already running Android emulator:

```powershell
.\scripts\update-android-screenshots.ps1
```

Default assumptions:

- Android SDK is available on the local machine.
- Emulator serial is `emulator-5554`.
- APK path is `build\app\outputs\flutter-apk\app-debug.apk` in the main app repository.

The recommended AVD is `neiroha_tablet_16x10`, with output size `2560x1600`. The script installs the debug APK, clears app data, opens the app, and replaces `static/img/screenshot_*.png`.
