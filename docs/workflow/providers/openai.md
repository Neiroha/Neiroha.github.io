---
title: OpenAI 官方 TTS
sidebar_label: OpenAI 官方
---

在「提供商」选 **OpenAI TTS (Official)**，基础地址填 `https://api.openai.com/v1`。桌面端填 OpenAI API Key，保存后拉取模型和音色，再到语音库选模型和预设音色。自建网关请按实际协议选择适配器。

## 模型兼容性

下表对应 Neiroha v0.5.0。浏览器合成还取决于提供商的 HTTPS 和跨域设置。表中的流式指播放可以在整段生成完成前开始。

| 模型 ID | 调用接口 | 原生端 | Web | 流式播放 |
|---|---|---|---|---|
| `gpt-realtime-2.1-mini`（默认） | Realtime WebSocket | 支持 | 不可生成 | 原生端 |
| `gpt-realtime-2.1` | Realtime WebSocket | 支持 | 不可生成 | 原生端 |
| `gpt-4o-mini-tts` | Speech API | 支持 | 可用，需允许跨域 | 原生端与 Web |
| `gpt-4o-mini-tts-2025-12-15` | Speech API | 支持 | 可用，需允许跨域 | 原生端与 Web |
| `tts-1` | Speech API | 支持 | 可用，需允许跨域 | 原生端与 Web |
| `tts-1-hd` | Speech API | 支持 | 可用，需允许跨域 | 原生端与 Web |

两个 Realtime 模型以及 `gpt-4o-mini-tts` 系列可使用声音指令。`tts-1` 和 `tts-1-hd` 可选预设音色。该适配器使用预设或账号已有的音色 ID，角色无需附加参考录音。[v0.5.0 适配器](https://github.com/Neiroha/Neiroha/blob/v0.5.0/lib/data/adapters/openai_tts_adapter.dart)

## Web 选中 Realtime 后无法生成

v0.5.0 的 Web 快速试听只接入了 OpenAI 的 HTTP Speech API。模型列表也可能显示 `gpt-realtime-*`，生成时会被拦下，提示中还会提到参考文件。此时请改用 `gpt-4o-mini-tts` 或它的 `2025-12-15` 快照，再选一个预设音色。Realtime 请在原生端使用。[跟踪 Issue](https://github.com/Neiroha/Neiroha/issues/9)

OpenAI 计划在 2027 年 1 月 6 日停用表中的 Speech API 模型。当前 Web 方案依赖这些模型仍可用，浏览器 Realtime 接入进度见上面的 Issue。[OpenAI 停用时间表](https://developers.openai.com/api/docs/deprecations)

公开演示的请求由浏览器发给你配置的提供商。请把长期云端密钥留在自己的后端，或在桌面端配置。[Web 演示](../../guide/web-demo.mdx) · [流式输出](../streaming.md)
