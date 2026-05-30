---
title: Gemini TTS
sidebar_label: Gemini
---

Gemini TTS 在 Neiroha 中使用 **Google Gemini TTS** 适配器。它调用 Gemini API 的 native text-to-speech 能力，适合使用 Google AI Studio API key 做小规模试听和风格测试。

## 官方限制

Google 官方文档把 Gemini TTS 标为 Preview，并说明 TTS 接收文本、输出音频。官方 Rate Limits 页面列出 `gemini-2.5-flash-preview-tts` 免费层限制为 `3 RPM / 10,000 TPM / 15 RPD`。额度、模型和命名可能调整，实际以 AI Studio 控制台为准。

官方页面：

- [Speech generation](https://ai.google.dev/gemini-api/docs/speech-generation)
- [Pricing](https://ai.google.dev/gemini-api/docs/pricing)
- [Rate limits](https://ai.google.dev/gemini-api/docs/rate-limits)

## 提供商填写

| 字段 | 推荐值 |
|---|---|
| Adapter Type | `Google Gemini TTS` |
| Name | `Google AI Studio` |
| 基础地址（Base URL） | `https://generativelanguage.googleapis.com` |
| 接口密钥（API Key） | Google AI Studio API key |
| 默认模型（Default Model） | 默认使用 `gemini-2.5-flash-preview-tts` |

保存后：

1. 点 **拉取全部（Fetch All）**。
2. Neiroha 会显示内置 Gemini TTS 模型和官方预设 voice 列表。
3. 打开启用开关。
4. 点 **健康检查（Health Check）**。
5. 到语音库创建一个预设音色角色。

## 可选音色

Gemini TTS 官方文档列出 30 个预设音色。Neiroha 会把这些音色作为固定列表展示，例如：

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

Gemini 免费层请求数适合 Quick TTS 和短 Dialog 测试，不适合直接处理完整小说。

建议提供商限流：

| 字段 | 建议值 |
|---|---|
| 最大并发 | `1` |
| RPM | `3` 或更低 |
| TPM | `10000` 或更低 |
| RPD | `15` 或按控制台实际额度设置 |

如果遇到 `429 RESOURCE_EXHAUSTED`，暂停请求后再降低并发和批量规模。
