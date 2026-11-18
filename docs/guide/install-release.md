---
title: 安装 Release 发布包
sidebar_label: 安装 Release 发布包
---

日常安装请从 Release 发布包开始，不需要本地编译。

## 下载入口

打开 [Neiroha Releases](https://github.com/Neiroha/Neiroha/releases/latest)，选择适合设备的正式版安装包。历次功能变化见 [版本更新](./releases.md)。

| 平台 | 在 Release 中选择 |
|---|---|
| Windows x64 | `neiroha-Windows-AMD64-<版本>.zip` |
| Android | `neiroha-Android-Universal-<版本>.apk`，或选择对应 CPU 架构的 APK |
| Linux x64 | `neiroha-Linux-AMD64-<版本>.tar.gz` |
| macOS（v0.5.0 起） | `neiroha-macOS-ARM64-<版本>.dmg`（Apple Silicon）或 `neiroha-macOS-AMD64-<版本>.dmg`（Intel） |

Release 安装包可直接运行，无需安装 Flutter SDK。

- **Windows**：解压 ZIP 到固定目录，运行 `neiroha.exe`。
- **Android**：将 APK 复制到设备，根据系统提示允许安装，再启动应用。
- **Linux**：解压后运行 bundle 内的 Neiroha 可执行文件。视频配音导出所需 FFmpeg 在 **设置 → 媒体工具** 中配置。
- **macOS**：在「关于本机」查看芯片类型。打开对应的 DMG，把 **Neiroha.app** 拖到「应用程序」。v0.5.0 的 DMG 使用 ad-hoc 签名，首次启动可能出现 Gatekeeper 提示，请先核对下载来源与校验值。

浏览器试用从 [Web 演示](./web-demo.mdx) 进入。

## 校验文件

将文件的 SHA-256 与相应 Release 正文 **Checksums** 表或资产 digest 对照。PowerShell 示例：

```powershell
Get-FileHash ./neiroha-Windows-AMD64-v0.4.2.zip -Algorithm SHA256
```

也可用 Linux 的 `sha256sum` 或 macOS 的 `shasum -a 256`。

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
