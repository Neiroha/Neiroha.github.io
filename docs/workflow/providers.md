---
title: 配置提供商
sidebar_label: 提供商
---

提供商负责把 Neiroha 的合成请求转发到具体 TTS 后端。进入侧边栏的 **提供商（Providers）** 标签页，点击列表面板右上角的 **+** 创建。

## 适配器类型

| 适配器 | 适用场景 |
|---|---|
| OpenAI TTS API 兼容 | OpenAI、KoboldCpp、Kokoro/XTTS、Orpheus 等实现 OpenAI TTS 协议的服务 |
| Azure 语音服务 | Microsoft Azure Speech TTS |
| GPT-SoVITS | 本地 GPT-SoVITS 服务器 |
| CosyVoice 原生 | 本地 CosyVoice 推理服务器 |
| VoxCPM2 原生 | 本地 VoxCPM2 推理服务器 |
| OpenAI Chat Completions TTS | 通过 Chat Completions 返回音频的模型，例如 MiMo v2 TTS |
| Google Gemini TTS | Google AI Studio Gemini TTS 模型 |
| Windows 系统 TTS | Windows SAPI 语音，无需外部服务器 |

## 关键字段

- **Base URL**：OpenAI 兼容服务通常填写 `http://localhost:8880/v1`；Azure 可以填写区域名 `eastus` 或完整 URL。
- **API Key**：没有鉴权的本地服务可以留空。
- **默认模型名**：GPT-SoVITS、CosyVoice、Gemini 和 OpenAI 兼容服务常用；Azure 与系统 TTS 通常忽略。

## 拉取模型和音色

保存前或保存后可以使用 **Fetch** / **Fetch All** 从服务端拉取可用模型和音色并缓存到本地。无法自动拉取时，可以手动添加音色项。

<img className="screenshot" src="/img/screenshot_providers.png" alt="提供商配置页" />

## 启用与健康检查

提供商保存后还需要打开行内开关。启用后执行健康检查，确认 Base URL、API Key、模型列表和服务可达性正常。

所有 UI 工作流和本地 API Server 都进入同一个 `TtsQueueService`，因此 Provider 的并发数、RPM/TPM 限流会同时影响快速 TTS、对话 TTS、段落 TTS、小说阅读器、视频配音和外部 HTTP 请求。
