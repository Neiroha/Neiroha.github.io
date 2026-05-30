---
title: Install Release Builds
sidebar_label: Install Release Builds
---

Normal users should start from Release builds. Local compilation is not required.

## Download Entry

Open [Neiroha Releases](https://github.com/Neiroha/Neiroha/releases) and choose the latest version. The current latest version is [`v0.3.1`](https://github.com/Neiroha/Neiroha/releases/tag/v0.3.1), released on 2026-05-30.

Release builds are produced and published by GitHub Actions in the main application repository. You do not need Flutter or local build commands when using these packages.

## Windows

1. Download `neiroha-v0.3.1-windows-x64-release.zip`.
2. Extract it to a stable directory, such as a dedicated `Neiroha` folder for portable apps.
3. Run `neiroha.exe`.
4. If Windows SmartScreen warns about an unknown publisher, continue only after confirming the file came from the official Release page.
5. After first launch, follow the provider setup steps in [Quick Start](/guide/getting-started).

## Android

1. Download `neiroha-v0.3.1-android-release.apk`.
2. Copy the APK to the Android device.
3. Enable installing apps from unknown sources in system settings.
4. Install the APK and launch Neiroha.
5. Android supports the UI and TTS client workflows. Local FFmpeg muxing, trimming, waveform extraction, and video export are currently disabled.

## Linux x64

1. Download `neiroha-v0.3.1-linux-x64-release.tar.gz`.
2. Extract it to a stable directory.
3. Run the Neiroha executable in the extracted bundle.
4. For video dubbing export, make sure FFmpeg is installed and configured or detected in **Settings -> Media Tools**.

## Verify Files

The Release page no longer provides separate `SHA256SUMS*.txt` files. Checksums are written directly in the Release body under **Checksums**, and GitHub asset metadata also shows digests.

Current `v0.3.1` checksums:

| File | SHA256 |
|---|---|
| `neiroha-v0.3.1-windows-x64-release.zip` | `baaa0c97a73e43b90e61ec651c0e24b961fce1548e918d916d594565e0a68a4f` |
| `neiroha-v0.3.1-android-release.apk` | `e722f82614007f07c7e06384705e6790d71cee396176a2d3ef3672c50c012160` |
| `neiroha-v0.3.1-linux-x64-release.tar.gz` | `da2cfafaadee63aad7c3b91afeec5ff09d6047bbba450718af32517f967ce660` |

Windows PowerShell example:

```powershell
Get-FileHash .\neiroha-v0.3.1-windows-x64-release.zip -Algorithm SHA256
```

Android and Linux packages can be checked the same way on Windows, or with `sha256sum` on systems that provide it.

## Local Backend Portable Packages

Local large-model TTS backends are downloaded separately. The main Neiroha Release only contains the Neiroha client and does not include GPT-SoVITS, VoxCPM2, or CosyVoice3 models.

The Windows portable backend packages are built for NVIDIA GPU / CUDA environments and mainly target RTX 30 / 40 / 50 series users. They are unzip-and-run packages. If GitHub Release downloads are unstable, use the Baidu Netdisk mirrors listed in the Release body.

| Backend | Release Page | Baidu Netdisk Mirror | Download Pattern |
|---|---|---|---|
| GPT-SoVITS | [Neiroha-GPT-SoVITS V1.0.0](https://github.com/Neiroha/Neiroha-GPT-SoVITS/releases/tag/V1.0.0) | [Mirror](https://pan.baidu.com/s/1TFbb4mlrANKJlz0-wuWY8g?pwd=neir) | Download `Neiroha-GPT-SoVITS-Portable.7z.001` through `.003`, then extract from `.001`. |
| VoxCPM2 | [Neiroha-VoxCPM V1.0.0](https://github.com/Neiroha/Neiroha-VoxCPM/releases/tag/V1.0.0) | [Mirror](https://pan.baidu.com/s/1NT_4Uwu4CYOFpZ6ImKe_ig?pwd=neir) | Download `Neiroha-VoxCPM-portable.7z.001` through `.004`, then extract from `.001`. |
| CosyVoice3 | [Neiroha-Cosyvoice V1.0.0](https://github.com/Neiroha/Neiroha-Cosyvoice/releases/tag/V1.0.0) | [Mirror](https://pan.baidu.com/s/1YloShmszdxrnXxbdDGlqoA?pwd=neir) | Download `neiroha-cosyvoice3-portable.7z.001` through `.006`, then extract from `.001`. |

All split archive parts must stay in the same directory. Downloading only `.001` or moving a single part separately cannot produce a complete extraction.

## Update Versions

Download the new Release build and replace the old program directory. Neiroha data and generated audio are stored in the system application data directory by default, not inside the program directory.

If you use a Windows portable release that stores portable data in the program directory, keep a backup before replacing the directory.
