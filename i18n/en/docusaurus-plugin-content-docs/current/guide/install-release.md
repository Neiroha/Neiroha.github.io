---
title: Install Release Builds
sidebar_label: Install Release Builds
---

Normal users should start from Release builds. Local compilation is not required.

## Download Entry

Open [Neiroha Releases](https://github.com/Neiroha/Neiroha/releases/latest) and select the stable build for your device. See the [release history](./releases.md) for changes by version.

| Platform | Release asset |
|---|---|
| Windows x64 | `neiroha-Windows-AMD64-<version>.zip` |
| Android | `neiroha-Android-Universal-<version>.apk` or the APK for your CPU architecture |
| Linux x64 | `neiroha-Linux-AMD64-<version>.tar.gz` |
| macOS (v0.5.0 onward) | `neiroha-macOS-ARM64-<version>.dmg` for Apple Silicon or `neiroha-macOS-AMD64-<version>.dmg` for Intel |

Release builds run without the Flutter SDK.

- **Windows:** Extract the ZIP to a fixed folder and run `neiroha.exe`.
- **Android:** Copy the APK to the device, allow installation when prompted, and launch the app.
- **Linux:** Extract the archive and run the Neiroha executable inside the bundle. Configure FFmpeg under **Settings → Media Tools** for video dubbing exports.
- **macOS:** Check your chip in About This Mac. Open the matching DMG and drag **Neiroha.app** to Applications. The v0.5.0 DMGs use ad-hoc signing, so verify the download source and checksum if Gatekeeper prompts on first launch.

To try the browser workspace, open the [Web demo](./web-demo.mdx).

## Verify Files

Compare the file's SHA-256 with the **Checksums** table in its Release notes or with the asset digest. In PowerShell:

```powershell
Get-FileHash ./neiroha-Windows-AMD64-v0.4.2.zip -Algorithm SHA256
```

On Linux use `sha256sum`. On macOS use `shasum -a 256`.

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
