---
title: Gemini TTS
sidebar_label: Gemini
---

Gemini TTS 在 Neiroha 中使用 **Google Gemini TTS** 适配器。它调用 Gemini API 的 native text-to-speech 能力，适合使用 Google AI Studio API key 做小规模试听和风格测试。

## 模型兼容性

表中是 v0.5.0 的内置候选，账号可用情况和额度请查 AI Studio。生成需要文本和音色，Web 端还要求服务端允许跨域。

| 模型 ID | 接口 | 原生端 | Web | 流式播放 |
|---|---|---|---|---|
| `gemini-3.8-flash-tts`（默认） | Interactions | 支持 | 允许跨域时可用 | 整段 |
| `gemini-3.8-flash-lite-tts` | Interactions | 支持 | 允许跨域时可用 | 整段 |
| `gemini-3.1-flash-tts-preview` | generateContent | 支持 | 允许跨域时可用 | 整段 |
| `gemini-2.5-flash-preview-tts` | generateContent | 支持 | 允许跨域时可用 | 整段 |
| `gemini-2.5-pro-preview-tts` | generateContent | 支持 | 允许跨域时可用 | 整段 |

[Google TTS 文档](https://ai.google.dev/gemini-api/docs/speech-generation) · [额度与速率](https://ai.google.dev/gemini-api/docs/rate-limits) · [计费](https://ai.google.dev/gemini-api/docs/pricing)

## 提供商填写

| 字段 | 推荐值 |
|---|---|
| Adapter Type | `Google Gemini TTS` |
| Name | `Google AI Studio` |
| 基础地址（Base URL） | `https://generativelanguage.googleapis.com` |
| 接口密钥（API Key） | Google AI Studio API key |
| 默认模型（Default Model） | 默认使用 `gemini-3.8-flash-tts` |

保存后：

1. 点 **拉取全部（Fetch All）**。
2. Neiroha 会显示内置 Gemini TTS 模型和官方预设 voice 列表。
3. 打开启用开关。
4. 点 **健康检查（Health Check）**。
5. 到语音库创建一个预设音色角色。

## 可选音色

下列 30 个官方预设音色由应用内置。成功读取 `/v1beta/voices` 时，Neiroha 还会加入扩展音色。

```text
Zephyr, Puck, Charon, Kore, Fenrir, Leda, Orus, Aoede,
Callirrhoe, Autonoe, Enceladus, Iapetus, Umbriel, Algieba,
Despina, Erinome, Algenib, Rasalgethi, Laomedeia, Achernar,
Alnilam, Schedar, Gacrux, Pulcherrima, Achird, Zubenelgenubi,
Vindemiatrix, Sadachbia, Sadaltager, Sulafat
```

首次测试可选 `Kore` 或 `Puck`，文本不宜过长。

## 角色设置

| 目标 | 角色设置 |
|---|---|
| 普通朗读 | 任务模式选预设音色，voice 选 Gemini 预设音色 |
| 风格控制 | 在角色的声音指令里写“温柔、低声、新闻播报”等导演提示 |
| 音色克隆 | 不支持，Gemini TTS 适配器会拒绝参考音频克隆 |

Gemini TTS 没有独立的速度字段，Neiroha 会把非 `1.0` 的速度选择转换成自然语言提示。

## 免费额度用法

在控制台查看该模型的请求数和 token 限制。先用短句试听，再按账号额度填 RPM、TPM 和 RPD。
