---
title: GitHub Actions Builds
sidebar_label: GitHub Actions Builds
---

The main Neiroha application repository has native platform CI. Release users do not need to depend on local build outputs.

Normal users should download built packages from [Neiroha Releases](https://github.com/Neiroha/Neiroha/releases). The current latest Release is [`v0.3.1`](https://github.com/Neiroha/Neiroha/releases/tag/v0.3.1), with Android, Linux x64, and Windows x64 assets.

## Workflows

| Workflow | Trigger | Output |
|---|---|---|
| `native-tests.yml` | Pull request, manual dispatch | Flutter / Dart tests and baseline checks |
| `native-debug-builds.yml` | Pull request, manual dispatch | Android debug APK, Linux debug bundle, Windows debug bundle |
| `native-release-builds.yml` | `v*.*` tag, manual tag input | Android release APK, Linux release tar.gz, Windows release zip, checksum table in the Release body, and release assets |

## Android Debug APK

The debug workflow runs:

```bash
flutter build apk --debug
```

Artifact names:

```text
neiroha-android-debug-apk
dist/neiroha-android-debug.apk
dist/SHA256SUMS-android-debug.txt
```

The local equivalent is usually:

```text
build/app/outputs/flutter-apk/app-debug.apk
```

Screenshots in this wiki were captured from the debug APK installed on a 2560x1600 Android emulator.

## Release Builds

The release workflow builds these assets when a tag is published or provided manually:

- `neiroha-<tag>-android-release.apk`
- `neiroha-<tag>-linux-x64-release.tar.gz`
- `neiroha-<tag>-windows-x64-release.zip`

SHA256 values are no longer uploaded as separate text assets. They are written into the GitHub Release body under **Checksums**. Android release APKs also get provenance attestation.

This is why the quick-start path no longer asks users to build from source. Source setup is kept for developers, debugging, and contributors.

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
