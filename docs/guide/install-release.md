---
title: 安装 Release 包
sidebar_label: 安装 Release 包
---

普通用户建议从 Release 包开始，不需要本地编译。

## 下载入口

打开 [Neiroha Releases](https://github.com/Neiroha/Neiroha/releases)，选择最新版本。当前最新版本是 `v0.2.1`，发布时间为 2026-05-17。

Release 包由主程序仓库的 GitHub Actions 构建并发布。普通用户不需要安装 Flutter，也不需要本地执行 build 命令。

## Windows

1. 下载 `neiroha-v0.2.1-windows-x64-release.zip`。
2. 解压到一个固定目录，例如你专门存放便携应用的 `Neiroha` 文件夹。
3. 运行解压目录里的 `neiroha.exe`。
4. 如果 Windows SmartScreen 提示未知发布者，确认文件来自官方 Release 页面后再继续。
5. 第一次启动后进入 [快速开始](/guide/getting-started) 的 Provider 配置步骤。

## Android

1. 下载 `neiroha-v0.2.1-android-release.apk`。
2. 将 APK 复制到 Android 设备。
3. 打开系统的“允许安装未知来源应用”设置。
4. 安装 APK 并启动 Neiroha。
5. Android 端支持 UI 和 TTS 客户端工作流；本地 FFmpeg 混流、裁剪、波形提取和视频导出当前禁用。

## Linux x64

1. 下载 `neiroha-v0.2.1-linux-x64-release.tar.gz`。
2. 解压到固定目录。
3. 在解压后的 bundle 目录运行 Neiroha 可执行文件。
4. 如果要使用视频配音导出，确认系统已安装 FFmpeg，并在 **Settings → Media Tools** 中配置或检测路径。

## 校验文件

Release 页面提供：

- `SHA256SUMS.txt`
- `SHA256SUMS-windows-release.txt`
- `SHA256SUMS-android-release.txt`
- `SHA256SUMS-linux-release.txt`

下载后可以比对 SHA256，确认文件没有损坏或被替换。

## 更新版本

下载新版本 Release 包后，覆盖旧程序目录即可。Neiroha 的数据和生成音频默认存放在系统应用数据目录，不和程序目录绑定。

如果你使用 Windows portable release，程序目录内也可能包含 portable 数据目录。覆盖前可以先保留旧目录备份。
