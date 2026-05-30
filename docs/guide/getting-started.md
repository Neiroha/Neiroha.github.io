---
title: 快速开始
sidebar_label: 快速开始
---

## 环境要求

- Windows 10/11、Linux x64 或 Android 设备。
- 至少一个可访问的 TTS 后端，可以是本机、局域网或云端服务。
- 日常使用不需要安装 Flutter；下载 Release 发布包即可。

## 1. 下载 Release 发布包

打开 [Neiroha Releases](https://github.com/Neiroha/Neiroha/releases)，下载最新版本。当前最新版本是 [`v0.3.1`](https://github.com/Neiroha/Neiroha/releases/tag/v0.3.1)，发布时间为 2026-05-30。

| 平台 | 下载文件 | 用法 |
|---|---|---|
| Windows | `neiroha-v0.3.1-windows-x64-release.zip` | 解压后运行 `neiroha.exe` |
| Android | `neiroha-v0.3.1-android-release.apk` | 复制到设备后安装 APK |
| Linux x64 | `neiroha-v0.3.1-linux-x64-release.tar.gz` | 解压后运行 bundle 内的可执行文件 |

SHA256 现在直接写在 Release 正文的 **Checksums** 表里，不再单独提供 `SHA256SUMS*.txt`。

详细安装步骤见 [安装 Release 包](/guide/install-release)。

## 2. 准备一个 TTS 后端

Neiroha 本身是 TTS 工作站和中间件，不内置大模型推理。第一次使用前需要准备一个后端：

| 选择 | 适合谁 | 下一步 |
|---|---|---|
| 本地推理引擎 | 有本机 GPU、局域网推理服务器，或需要文本留在本地 | 看 [连接本地推理引擎](/workflow/providers/local-engines) |
| 云端 / 免费额度 | 需要快速试用，且暂不部署本地模型 | 看 [连接云端推理引擎](/workflow/providers/cloud-engines) |
| Windows 系统语音 | 仅验证 Neiroha 工作流，不要求 AI 音色 | 在提供商中使用 Windows 系统语音 |

本地后端提供 Windows NVIDIA 便携包，主要面向 RTX 30 / 40 / 50 系列显卡用户。GPT-SoVITS、VoxCPM2 和 CosyVoice3 可从各自 Release 页面下载分卷包；GitHub 下载不稳定时也可以使用 Release 正文里的百度网盘镜像。具体见 [Windows 便携后端包](/workflow/providers/local-engines#windows-便携后端包)。

### 路线选择

| 目标 | 推荐路线 |
|---|---|
| 尽快听到第一段声音 | 使用 Windows 系统语音或云端免费额度，先完成快速测试 |
| 文本不离开本机 | 使用 GPT-SoVITS、CosyVoice3 或 VoxCPM2 本地后端 |
| 需要中英混合或多语种试听 | 先试 Gemini、MiMo、CosyVoice3 或 VoxCPM2，再按效果固定提供商 |
| 需要参考音频克隆 | 使用 GPT-SoVITS、CosyVoice3 或 VoxCPM2，并准备干净短音频 |
| 批量小说、有声书或字幕配音 | 优先配置本地后端；云端提供商需设置 RPM、TPM、RPD 和较低并发 |
| 给脚本、游戏或其他工具调用 | 先创建语音库并通过快速测试，再打开 [API 服务器](/operations/api-server) |

## 3. 配置提供商

打开 **提供商（Providers）** 页面。左侧是提供商列表，右侧是当前提供商的配置表单。

<img className="screenshot" src="/img/screenshot_providers.png" alt="提供商配置页" />

基本流程：

1. 点击左侧列表右上角的 **+**。
2. 选择适配器类型。
3. 填写基础地址（`Base URL`）、接口密钥（`API Key`）和必要的模型名。
4. 点击 **拉取全部（Fetch All）** 拉取模型和音色。
5. 打开该提供商的启用开关。
6. 点击 **健康检查（Health Check）** 确认服务可用。

提供商详细说明见 [配置提供商](/workflow/providers)。

## 4. 创建语音库和角色

切到 **语音库（Voice Bank）** 页面。这里把“角色”组织成“语音库”，后续对话 TTS、段落 TTS、API 服务器都会从语音库中选择声音。

<img className="screenshot" src="/img/screenshot_overview.png" alt="语音库页面" />

首次使用可选择默认的 **Default Bank**，再选择 **Default Voice**，在右侧检查角色绑定的提供商、模型和音色。

## 5. 做第一次快速合成

在 **语音库（Voice Bank）** 页面选中一个角色后，右侧会出现 **快速测试（Quick Test）** 面板。

<img className="screenshot" src="/img/screenshot_quick_tts.png" alt="快速 TTS 页面" />

1. 在输入框里写一句测试文本。
2. 点击紫色生成按钮。
3. 如果提供商配置正确，音频会进入共享 TTS 队列并自动播放。
4. 生成的音频会保存在语音资产目录，后续可在存储扫描中管理。

## 6. 下一步

- 多角色台词：看 [对话 TTS](/workflow/dialog-tts)。
- 长文本 / 有声书：看 [段落 TTS](/workflow/phase-tts)。
- TXT 小说朗读：看 [小说阅读器](/workflow/novel-reader)。
- 字幕配音：看 [视频配音](/workflow/video-dub)。
- 给外部工具提供 OpenAI 兼容接口：看 [API 服务器](/operations/api-server)。
