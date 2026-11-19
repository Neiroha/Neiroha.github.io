---
title: MiniMax Speech
sidebar_label: MiniMax Speech
---

在「提供商」选 **MiniMax Speech**。国际站账号用 `https://api.minimax.io`，中国大陆站账号用 `https://api.minimaxi.com`。填对应站点的 API Key，保存后拉取音色，再给角色选模型和 `voice_id`。模型候选由 Neiroha 内置，音色通过 `/v1/get_voice` 读取。

## 模型兼容性

| 模型 ID | 原生端 | Web | 流式播放 |
|---|---|---|---|
| `speech-2.8-hd`（默认） | 支持 | 音色 ID，需允许跨域 | 整段 |
| `speech-2.8-turbo` | 支持 | 音色 ID，需允许跨域 | 整段 |
| `speech-2.6-hd` | 支持 | 音色 ID，需允许跨域 | 整段 |
| `speech-2.6-turbo` | 支持 | 音色 ID，需允许跨域 | 整段 |
| `speech-02-hd` | 支持 | 音色 ID，需允许跨域 | 整段 |
| `speech-02-turbo` | 支持 | 音色 ID，需允许跨域 | 整段 |

角色的声音指令可填 `happy`、`sad`、`angry`、`fearful`、`disgusted`、`surprised`、`calm`、`fluent` 或 `whisper`。适配器将这些值作为 `emotion` 发送，能否生效取决于上游模型。v0.5.0 使用 `/v1/t2a_v2` 的 `stream: false` 模式，收到完整音频后播放。原生端可以上传参考音频注册新音色。Web 使用账号已有的音色 ID。[MiniMax API](https://platform.minimax.io/docs/api-reference/speech-t2a-http) · [v0.5.0 适配器](https://github.com/Neiroha/Neiroha/blob/v0.5.0/lib/data/adapters/minimax_tts_adapter.dart)
