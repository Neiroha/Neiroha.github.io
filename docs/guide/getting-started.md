---
title: 快速开始
sidebar_label: 快速开始
---

## 环境要求

- Windows 10/11、Linux x64 或 Android 设备。
- 至少一个可访问的 TTS 后端，可以是本机、局域网或云端服务。
- 日常使用不需要安装 Flutter；下载 Release 包即可。

## 1. 下载 Release 包

打开 [Neiroha Releases](https://github.com/Neiroha/Neiroha/releases)，下载最新版本。当前最新版本是 [`v0.3.0`](https://github.com/Neiroha/Neiroha/releases/tag/v0.3.0)，发布时间为 2026-05-30。

| 平台 | 下载文件 | 用法 |
|---|---|---|
| Windows | `neiroha-v0.3.0-windows-x64-release.zip` | 解压后运行 `neiroha.exe` |
| Android | `neiroha-v0.3.0-android-release.apk` | 复制到设备后安装 APK |
| Linux x64 | `neiroha-v0.3.0-linux-x64-release.tar.gz` | 解压后运行 bundle 内的可执行文件 |

SHA256 现在直接写在 Release 正文的 **Checksums** 表里，不再单独提供 `SHA256SUMS*.txt`。

详细安装步骤见 [安装 Release 包](/guide/install-release)。

## 2. 准备一个 TTS 后端

Neiroha 本身是 TTS 工作站和中间件，不内置大模型推理。第一次使用前需要准备一个后端：

| 选择 | 适合谁 | 下一步 |
|---|---|---|
| 本地推理引擎 | 有本机 GPU、局域网推理服务器，或需要文本留在本地 | 看 [连接本地推理引擎](/workflow/providers/local-engines) |
| 云端 / 免费额度 | 需要快速试用，且暂不部署本地模型 | 看 [连接云端推理引擎](/workflow/providers/cloud-engines) |
| Windows 系统 TTS | 仅验证 Neiroha 工作流，不要求 AI 音色 | 在 Provider 中使用 Windows System TTS |

本地后端提供 Windows 便携包。GPT-SoVITS、VoxCPM2 和 CosyVoice3 可从各自 Release 页面下载分卷包；具体见 [Windows 便携后端包](/workflow/providers/local-engines#windows-便携后端包)。

## 3. 配置 Provider

打开 **Providers** 页面。左侧是 Provider 列表，右侧是当前 Provider 的配置表单。

<img className="screenshot" src="/img/screenshot_providers.png" alt="提供商配置页" />

基本流程：

1. 点击左侧列表右上角的 **+**。
2. 选择适配器类型。
3. 填写 `Base URL`、`API Key` 和必要的模型名。
4. 点击 **Fetch All** 拉取模型和音色。
5. 打开该 Provider 的启用开关。
6. 点击 **Health Check** 确认服务可用。

Provider 详细说明见 [配置提供商](/workflow/providers)。

## 4. 创建语音库和角色

切到 **Voice Bank** 页面。这里把“角色”组织成“语音库”，后续 Dialog TTS、Phase TTS、API Server 都会从语音库中选择声音。

<img className="screenshot" src="/img/screenshot_overview.png" alt="语音库页面" />

首次使用可选择默认的 **Default Bank**，再选择 **Default Voice**，在右侧检查角色绑定的 Provider、模型和音色。

## 5. 做第一次快速合成

在 **Voice Bank** 页面选中一个角色后，右侧会出现 **Quick Test** 面板。

<img className="screenshot" src="/img/screenshot_quick_tts.png" alt="快速 TTS 页面" />

1. 在输入框里写一句测试文本。
2. 点击紫色生成按钮。
3. 如果 Provider 配置正确，音频会进入共享 TTS 队列并自动播放。
4. 生成的音频会保存在语音资产目录，后续可在存储扫描中管理。

## 6. 下一步

- 多角色台词：看 [对话 TTS](/workflow/dialog-tts)。
- 长文本 / 有声书：看 [段落 TTS](/workflow/phase-tts)。
- TXT 小说朗读：看 [小说阅读器](/workflow/novel-reader)。
- 字幕配音：看 [视频配音](/workflow/video-dub)。
- 给外部工具提供 OpenAI 兼容接口：看 [API 服务器](/operations/api-server)。
