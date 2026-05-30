---
title: 安装 Release 发布包
sidebar_label: 安装 Release 发布包
---

日常安装请从 Release 发布包开始，不需要本地编译。

## 下载入口

打开 [Neiroha Releases](https://github.com/Neiroha/Neiroha/releases)，选择最新版本。当前最新版本是 [`v0.3.1`](https://github.com/Neiroha/Neiroha/releases/tag/v0.3.1)，发布时间为 2026-05-30。

Release 发布包由主程序仓库的 GitHub Actions 构建并发布。使用 Release 发布包不需要安装 Flutter，也不需要本地执行 build 命令。

## Windows

1. 下载 `neiroha-v0.3.1-windows-x64-release.zip`。
2. 解压到固定目录，例如专门存放便携应用的 `Neiroha` 文件夹。
3. 运行解压目录里的 `neiroha.exe`。
4. 如果 Windows SmartScreen 提示未知发布者，确认文件来自官方 Release 页面后再继续。
5. 第一次启动后进入 [快速开始](/guide/getting-started) 的提供商配置步骤。

## Android

1. 下载 `neiroha-v0.3.1-android-release.apk`。
2. 将 APK 复制到 Android 设备。
3. 打开系统的“允许安装未知来源应用”设置。
4. 安装 APK 并启动 Neiroha。
5. Android 端支持 UI 和 TTS 客户端工作流；本地 FFmpeg 混流、裁剪、波形提取和视频导出当前禁用。

## Linux x64

1. 下载 `neiroha-v0.3.1-linux-x64-release.tar.gz`。
2. 解压到固定目录。
3. 在解压后的 bundle 目录运行 Neiroha 可执行文件。
4. 如果要使用视频配音导出，确认系统已安装 FFmpeg，并在 **设置 → 媒体工具（Settings → Media Tools）** 中配置或检测路径。

## 校验文件

Release 页面不再单独提供 `SHA256SUMS*.txt`。校验值直接写在 Release 正文的 **Checksums** 表里，GitHub 资产信息里也会显示 digest。

`v0.3.1` 当前校验值：

| 文件 | SHA256 |
|---|---|
| `neiroha-v0.3.1-windows-x64-release.zip` | `baaa0c97a73e43b90e61ec651c0e24b961fce1548e918d916d594565e0a68a4f` |
| `neiroha-v0.3.1-android-release.apk` | `e722f82614007f07c7e06384705e6790d71cee396176a2d3ef3672c50c012160` |
| `neiroha-v0.3.1-linux-x64-release.tar.gz` | `da2cfafaadee63aad7c3b91afeec5ff09d6047bbba450718af32517f967ce660` |

Windows 可用 PowerShell 校验：

```powershell
Get-FileHash .\neiroha-v0.3.1-windows-x64-release.zip -Algorithm SHA256
```

Android 和 Linux 包也可以用同样方式在 Windows 上校验，或用系统自带 `sha256sum`。

## 本地后端便携包

如果要使用本地大模型 TTS，还需要单独下载对应后端。主程序 Release 发布包只包含 Neiroha 客户端，不包含 GPT-SoVITS、VoxCPM2 或 CosyVoice3 模型。

本地后端 Windows 便携包按 NVIDIA GPU / CUDA 环境打包，主要面向 RTX 30 / 40 / 50 系列显卡用户。便携包是解压即用形态；如果 GitHub Release 下载速度不稳定，可使用各 Release 正文提供的百度网盘镜像。

| 后端 | Release 页面 | 百度网盘镜像 | 下载方式 |
|---|---|---|---|
| GPT-SoVITS | [Neiroha-GPT-SoVITS Releases](https://github.com/Neiroha/Neiroha-GPT-SoVITS/releases/tag/V1.0.0) | [网盘备用](https://pan.baidu.com/s/1TFbb4mlrANKJlz0-wuWY8g?pwd=neir) | 下载 `Neiroha-GPT-SoVITS-Portable.7z.001` 到 `.003`，从 `.001` 解压 |
| VoxCPM2 | [Neiroha-VoxCPM Releases](https://github.com/Neiroha/Neiroha-VoxCPM/releases/tag/V1.0.0) | [网盘备用](https://pan.baidu.com/s/1NT_4Uwu4CYOFpZ6ImKe_ig?pwd=neir) | 下载 `Neiroha-VoxCPM-portable.7z.001` 到 `.004`，从 `.001` 解压 |
| CosyVoice3 | [Neiroha-Cosyvoice Releases](https://github.com/Neiroha/Neiroha-Cosyvoice/releases/tag/V1.0.0) | [网盘备用](https://pan.baidu.com/s/1YloShmszdxrnXxbdDGlqoA?pwd=neir) | 下载 `neiroha-cosyvoice3-portable.7z.001` 到 `.006`，从 `.001` 解压 |

分卷包必须放在同一目录。仅下载 `.001` 或单独移动某个分卷都无法完整解压。

## 更新版本

下载新版本 Release 发布包后，覆盖旧程序目录即可。Neiroha 的数据和生成音频默认存放在系统应用数据目录，不和程序目录绑定。

使用 Windows portable release 时，程序目录内也可能包含 portable 数据目录。覆盖前可保留旧目录备份。
