---
title: 连接云端推理引擎
sidebar_label: 云端 / 免费额度
---

云端 TTS 适合先试用、跨设备使用，或不想本地部署模型的场景。这里的“免费”通常指免费层、试用额度、赠送 credit 或限时活动，额度和模型可用性会变，最终以官方控制台显示为准。

<img className="screenshot" src="/img/screenshot_providers.png" alt="云端提供商配置入口" />

## 通用步骤

1. 到云服务官网创建账号和 API Key。
2. 在 Neiroha 打开 **Providers**，点 **+**。
3. 选择对应适配器。
4. 填 `Base URL`、`API Key`，必要时填模型名。
5. 点 **Fetch All** 拉取模型和音色。
6. 打开启用开关。
7. 点 **Health Check**。
8. 在 **Voice Bank** 创建角色，用 Quick Test 生成一句短文本。

## 当前推荐先试的云端入口

| 服务 | Neiroha 适配器 | 为什么适合试用 | 详细页 |
|---|---|---|---|
| MiMo | OpenAI Chat Completions TTS | 一个 key 接 TTS / VoiceDesign / VoiceClone 风格模型，适合测试中文和中英混合 | [MiMo TTS](/workflow/providers/mimo) |
| Google Gemini TTS | Google Gemini TTS | AI Studio API key，官方文档列出 Gemini 2.5 Flash Preview TTS 免费层速率限制 | [Gemini TTS](/workflow/providers/gemini) |
| Azure Speech | Azure Speech Service | Azure F0 免费层提供 Neural TTS 每月字符额度，语音列表稳定 | [Azure Speech](/workflow/providers/azure) |

## 免费额度使用建议

| 工作流 | 建议 |
|---|---|
| Quick TTS | 每次只生成一句，确认角色绑定没问题 |
| Dialog TTS | 先选 2 到 3 行手动生成，不要一开始点全部生成 |
| Phase TTS | 先拆 3 到 5 个段落，确认长文本风格和成本 |
| Novel Reader | 预取数量设低，避免一打开就消耗大量额度 |
| Video Dub | 先导入短字幕片段测试 cue 对齐，再批量生成 |

## Provider 限流要填

云端服务最常见的失败不是配置错，而是触发限流。建议在 Provider 里设置：

| 字段 | 用途 |
|---|---|
| 最大并发 | 控制同时有几个 TTS 请求跑起来 |
| RPM | 每分钟请求数，适合 Gemini 这类明确限制 RPM 的服务 |
| TPM | 每分钟 token 数，适合按 token 计费或限制的服务 |
| RPD | 每日请求数，适合免费层 |

例如 Gemini 免费层可按官方 Rate Limits 给 `gemini-2.5-flash-preview-tts` 设置保守的 RPM / TPM / RPD；Azure F0 更应该按字符额度控制文本长度和批量规模；MiMo Token Plan 则以控制台余额和模型消耗规则为准。

## 官方入口

- [Xiaomi MiMo](https://mimo.mi.com/)
- [Gemini API Speech generation](https://ai.google.dev/gemini-api/docs/speech-generation)
- [Gemini API pricing](https://ai.google.dev/gemini-api/docs/pricing)
- [Gemini API rate limits](https://ai.google.dev/gemini-api/docs/rate-limits)
- [Azure Speech Text-to-Speech docs](https://learn.microsoft.com/en-us/azure/ai-services/speech-service/index-text-to-speech)
- [Azure Speech pricing](https://azure.microsoft.com/en-us/pricing/details/speech/)
