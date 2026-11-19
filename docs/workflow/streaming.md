---
title: 流式输出与播放
sidebar_label: 流式输出
---

流式播放会在第一批音频到达后开始。适配器仅返回完整文件时，快速试听仍会等生成完成再播放。以下说明适用于 Neiroha v0.5.0。

## 在快速试听使用

1. 给角色选支持流式的模型和音色。原生端可以用 OpenAI 官方 Speech 或 Realtime。Web 用 OpenAI 官方 Speech，具体模型见 [OpenAI 兼容性表](./providers/openai.md#模型兼容性)。
2. 在快速试听保留 **自动：优先流式**。输入文本后开始生成。播放期间可以暂停，但暂时不能跳到还没生成的位置。
3. 中途点停止会取消仍在运行的请求，并丢弃未完成的音频。已生成完整的片段可从历史重播，Web 刷新或关闭标签页前可以下载需要保留的片段。

原生端的小说朗读和单句预览也会使用支持流式的适配器。小说若已有有效缓存，会直接播放缓存文件。对话、段落和视频的单句试听与批量导出是不同入口，批量导出仍等待完整音频。

## 按适配器查看

| 适配器 | 原生端 | Web |
|---|---|---|
| [OpenAI 官方](./providers/openai.md) | Speech PCM 和 Realtime PCM | Speech PCM |
| [OpenAI 兼容服务](./providers/local-engines.md)、[MiMo](./providers/mimo.md)、[Gemini](./providers/gemini.md)、[Azure](./providers/azure.md) | 整段 | 整段，需符合浏览器跨域要求 |
| [ElevenLabs](./providers/elevenlabs.md)、[MiniMax](./providers/minimax.md) | 整段 | 整段，需可访问的 HTTP 服务和已有音色 ID |
| [IndexTTS 2.5](./providers/indextts.md)、[GPT-SoVITS](./providers/gpt-sovits.md)、[VoxCPM2](./providers/voxcpm.md)、[CosyVoice](./providers/cosyvoice.md) | 整段 | 原生适配器不可用 |
| Windows 系统语音 | Windows 上整段 | 不可用 |

这张表以 Neiroha 实际调用的接口为准。IndexTTS WebUI 的 SSE 在这里用来通知任务完成。其他兼容后端即使能返回音频块，也要等 Neiroha 的对应适配器接入后才能边生成边播。

## 通过本地 HTTP API 读取 PCM

在原生客户端启动 [API 服务器](../operations/api-server.md)。用语音库中的角色调用 `POST /v1/audio/speech`，同时设置 `"stream": true` 和 `"response_format": "pcm"`。服务返回 `audio/pcm`，采样率和声道按 `X-Audio-Sample-Rate`、`X-Audio-Channels` 读取。`X-Audio-Encoding` 为 `pcm_s16le`。响应是连续原始字节，请交给同一个解码或播放会话。

关闭 HTTP 连接会取消未完成的上游请求。若角色的适配器不支持增量 PCM，API 返回 `400`，可以发一次整段请求。[API 字段与鉴权](../api-zh.md)
