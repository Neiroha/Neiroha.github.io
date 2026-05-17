---
title: 配置提供商
sidebar_label: 提供商
---

Provider 是 Neiroha 连接外部 TTS 后端的入口。它只负责“怎么访问服务”；真正给项目使用的声音，还要在 [语音角色与语音库](/workflow/voice-bank) 里绑定。

<img className="screenshot" src="/img/screenshot_providers.png" alt="提供商配置页" />

## 先看清关系

| 层级 | 在 Neiroha 里的位置 | 作用 |
|---|---|---|
| Provider | **Providers** 页面 | 保存 Base URL、API Key、适配器类型、并发和限流 |
| Model / Voice 缓存 | Provider 详情面板 | 从后端拉取可用模型和音色，供角色创建时选择 |
| Voice Character | **Voice Bank** 页面 | 把一个 Provider、模型、音色、语速、参考音频或声音描述绑定成“角色” |
| Voice Bank | **Voice Bank** 页面 | 把多个角色组成一套音色库，供 Dialog / Phase / Novel / Video / API 使用 |

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

## 创建 Provider

1. 打开左侧导航的 **Providers**。
2. 点击左侧 Provider 列表右上角的 **+**。
3. 选择适配器类型。要接本地模型，看 [连接本地推理引擎](/workflow/providers/local-engines)；要接云端免费额度或试用额度，看 [连接云端推理引擎](/workflow/providers/cloud-engines)。
4. 填名称。建议用 `平台 + 用途`，例如 `MiMo Free Trial`、`CosyVoice Local 9880`、`Azure East US`。
5. 填 `Base URL` 和 `API Key`。
6. 保存后回到 Provider 详情面板，先点 **Fetch All**，再打开启用开关。
7. 点 **Health Check**。通过后再去创建语音角色。

## Base URL 怎么填

| 场景 | 示例 | 注意点 |
|---|---|---|
| 本机桌面连接本机服务 | `http://127.0.0.1:8880/v1` | OpenAI 兼容服务通常带 `/v1` |
| 本机桌面连接局域网服务 | `http://192.168.1.20:9880` | 确认防火墙放行端口 |
| Android 模拟器连接宿主机 | `http://10.0.2.2:9880` | 模拟器里的 `127.0.0.1` 是模拟器自己 |
| Android 真机连接电脑 | `http://电脑局域网 IP:9880` | 手机和电脑要在同一网络，或使用可访问的内网穿透 |
| Azure | `eastus` 或 `https://eastus.tts.speech.microsoft.com` | Neiroha 会把区域名规范化为 TTS endpoint |
| Gemini | `https://generativelanguage.googleapis.com` | 使用 Google AI Studio API key |
| MiMo | `https://api.xiaomimimo.com/v1` | 使用 `api-key` 头，不是 Bearer 头 |

## API Key 和鉴权

| 适配器 | Key 是否必需 | Neiroha 使用的鉴权方式 |
|---|---|---|
| OpenAI TTS API Compatible | 看服务端设置 | `Authorization: Bearer <key>` |
| OpenAI Chat Completions TTS | 云端通常必需 | 默认 `api-key: <key>`，适配 MiMo 风格 |
| Google Gemini TTS | 必需 | `x-goog-api-key: <key>` |
| Azure Speech Service | 必需 | `Ocp-Apim-Subscription-Key: <key>` |
| GPT-SoVITS / CosyVoice / VoxCPM2 本地 | 通常可留空 | 如果你的本地服务加了鉴权，再填 key |
| Windows System TTS | 不需要 | 本机 SAPI |

## Fetch All 后要检查什么

点 **Fetch All** 后，右侧会缓存后端返回的模型和音色。这里决定了后面创建角色时下拉框有没有内容。

| 看到的情况 | 含义 | 处理 |
|---|---|---|
| 模型和音色都有 | 最理想，直接创建角色 | 打开启用开关，去 Voice Bank |
| 只有模型，没有音色 | 后端没有音色列表接口，或模型属于声音设计类 | 创建角色时手动填写 voice / instruction |
| 只有音色，没有模型 | Azure / System TTS 类后端常见 | 正常，角色里选 voice 即可 |
| 全空但 Health Check 通过 | 服务可达，但列表接口不兼容 | 手动填默认模型和 voice，再做 Quick Test |
| Health Check 失败 | URL、key、端口、网络或区域不对 | 先用浏览器 / curl 验证后端，再改 Provider |

## 并发和免费额度不要混在一起

Provider 的并发、RPM、TPM、RPD 限流会作用到所有工作流：Quick TTS、Dialog TTS、Phase TTS、Novel Reader、Video Dub 和本地 API Server 都共用同一个 `TtsQueueService`。

建议：

| 后端 | 推荐设置 |
|---|---|
| 本地 GPU 服务 | 先把最大并发设为 `1`，确认显存稳定后再增加 |
| Gemini 免费档 | 按官方 Rate Limits 设置 RPM / TPM / RPD，避免连续批量生成触发 429 |
| Azure F0 | 主要按字符额度和并发限制控制，长文本先用 Phase TTS 小批量试跑 |
| MiMo / 其他 Token Plan | 以控制台余额和速率限制为准，给 Provider 设置保守 RPD / TPM |

## 下一步

- 本地服务、局域网服务、Android 模拟器连接电脑：看 [连接本地推理引擎](/workflow/providers/local-engines)。
- 云端服务和免费额度：看 [连接云端推理引擎](/workflow/providers/cloud-engines)。
- MiMo：看 [MiMo TTS](/workflow/providers/mimo)。
- Gemini：看 [Gemini TTS](/workflow/providers/gemini)。
- Azure：看 [Azure Speech](/workflow/providers/azure)。
- Provider 通过后，继续 [创建语音角色与语音库](/workflow/voice-bank)。
