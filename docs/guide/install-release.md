---
title: 安装 Release 包
sidebar_label: 安装 Release 包
---

日常安装请从 Release 包开始，不需要本地编译。

## 下载入口

打开 [Neiroha Releases](https://github.com/Neiroha/Neiroha/releases)，选择最新版本。当前最新版本是 [`v0.3.0`](https://github.com/Neiroha/Neiroha/releases/tag/v0.3.0)，发布时间为 2026-05-30。

Release 包由主程序仓库的 GitHub Actions 构建并发布。使用 Release 包不需要安装 Flutter，也不需要本地执行 build 命令。

## Windows

1. 下载 `neiroha-v0.3.0-windows-x64-release.zip`。
2. 解压到固定目录，例如专门存放便携应用的 `Neiroha` 文件夹。
3. 运行解压目录里的 `neiroha.exe`。
4. 如果 Windows SmartScreen 提示未知发布者，确认文件来自官方 Release 页面后再继续。
5. 第一次启动后进入 [快速开始](/guide/getting-started) 的 Provider 配置步骤。

## Android

1. 下载 `neiroha-v0.3.0-android-release.apk`。
2. 将 APK 复制到 Android 设备。
3. 打开系统的“允许安装未知来源应用”设置。
4. 安装 APK 并启动 Neiroha。
5. Android 端支持 UI 和 TTS 客户端工作流；本地 FFmpeg 混流、裁剪、波形提取和视频导出当前禁用。

## Linux x64

1. 下载 `neiroha-v0.3.0-linux-x64-release.tar.gz`。
2. 解压到固定目录。
3. 在解压后的 bundle 目录运行 Neiroha 可执行文件。
4. 如果要使用视频配音导出，确认系统已安装 FFmpeg，并在 **Settings → Media Tools** 中配置或检测路径。

## 校验文件

Release 页面不再单独提供 `SHA256SUMS*.txt`。校验值直接写在 Release 正文的 **Checksums** 表里，GitHub 资产信息里也会显示 digest。

`v0.3.0` 当前校验值：

| 文件 | SHA256 |
|---|---|
| `neiroha-v0.3.0-windows-x64-release.zip` | `1813a1ebfa97e7de5ae3d27e57c591f790d1d07aef6572206e8668a7f31180b9` |
| `neiroha-v0.3.0-android-release.apk` | `710caf3f2a535674d2d552e9ff93b64ccdba80f065a32eb777958677cb9a3687` |
| `neiroha-v0.3.0-linux-x64-release.tar.gz` | `b14906f12b199835ac9d3528c69278ff26a7985fe28b366df90e949971d1927a` |

Windows 可用 PowerShell 校验：

```powershell
Get-FileHash .\neiroha-v0.3.0-windows-x64-release.zip -Algorithm SHA256
```

Android 和 Linux 包也可以用同样方式在 Windows 上校验，或用系统自带 `sha256sum`。

## 本地后端便携包

如果要使用本地大模型 TTS，还需要单独下载对应后端。主程序 Release 只包含 Neiroha 客户端，不包含 GPT-SoVITS、VoxCPM2 或 CosyVoice3 模型。

| 后端 | Release 页面 | 下载方式 |
|---|---|---|
| GPT-SoVITS | [Neiroha-GPT-SoVITS Releases](https://github.com/Neiroha/Neiroha-GPT-SoVITS/releases) | 下载 `Neiroha-GPT-SoVITS-Portable.7z.001` 到 `.003`，从 `.001` 解压 |
| VoxCPM2 | [Neiroha-VoxCPM Releases](https://github.com/Neiroha/Neiroha-VoxCPM/releases) | 下载 `Neiroha-VoxCPM-portable.7z.001` 到 `.004`，从 `.001` 解压 |
| CosyVoice3 | [Neiroha-Cosyvoice Releases](https://github.com/Neiroha/Neiroha-Cosyvoice/releases) | 下载 `neiroha-cosyvoice3-portable.7z.001` 到 `.006`，从 `.001` 解压；以 Release 页面实际资产为准 |

分卷包必须放在同一目录。仅下载 `.001` 或单独移动某个分卷都无法完整解压。

## 更新版本

下载新版本 Release 包后，覆盖旧程序目录即可。Neiroha 的数据和生成音频默认存放在系统应用数据目录，不和程序目录绑定。

使用 Windows portable release 时，程序目录内也可能包含 portable 数据目录。覆盖前可保留旧目录备份。
