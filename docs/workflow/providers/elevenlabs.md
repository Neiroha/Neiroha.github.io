---
title: ElevenLabs
sidebar_label: ElevenLabs
---

在「提供商」选 **ElevenLabs**，基础地址填 `https://api.elevenlabs.io`，填账号的 API Key。Neiroha 使用 `xi-api-key` 请求头，拉取 `/v1/models` 和 `/v2/voices`。保存并拉取全部后，给角色选模型和 `名称 [voice_id]` 格式的音色。

## 模型兼容性

这些是 v0.5.0 的内置候选。成功拉取后可用模型以账号返回为准。

| 模型 ID | 原生端 | Web | 流式播放 | 声音指令 |
|---|---|---|---|---|
| `eleven_v4`（默认） | 支持 | 预设 ID，需允许跨域 | 整段 | 音频标签 |
| `eleven_v4_turbo` | 支持 | 预设 ID，需允许跨域 | 整段 | 音频标签 |
| `eleven_v3` | 支持 | 预设 ID，需允许跨域 | 整段 | 音频标签 |
| `eleven_multilingual_v2` | 支持 | 预设 ID，需允许跨域 | 整段 | — |
| `eleven_flash_v2_5` | 支持 | 预设 ID，需允许跨域 | 整段 | — |
| `eleven_flash_v2` | 支持 | 预设 ID，需允许跨域 | 整段 | — |

v3/v4 可以在角色的声音指令填 `[whispers]` 一类标签。Neiroha v0.5.0 调用普通 `/v1/text-to-speech/{voice_id}` 端点，等完整 MP3 返回后播放。账号已有的克隆音色可以直接按 ID 使用。要上传参考录音并在 ElevenLabs 账号创建新音色，请用原生客户端。[ElevenLabs API](https://elevenlabs.io/docs/api-reference/text-to-speech/convert) · [v0.5.0 适配器](https://github.com/Neiroha/Neiroha/blob/v0.5.0/lib/data/adapters/elevenlabs_adapter.dart)
