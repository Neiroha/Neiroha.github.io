---
title: MiMo TTS
sidebar_label: MiMo
---

MiMo 在 Neiroha 中走 **OpenAI Chat Completions TTS** 适配器。这个适配器不是 `/v1/audio/speech`，而是调用 `/v1/chat/completions`，并从返回的 `message.audio.data` 里取 base64 音频。

## 准备 API Key

1. 打开 [Xiaomi MiMo](https://mimo.mi.com/) 或 MiMo 开放平台控制台。
2. 登录账号。
3. 在控制台查看 Token Plan、credit、模型可用性和 API Key。
4. 创建一个专门给 Neiroha 用的 key，方便之后单独看消耗。

MiMo 的套餐、赠送额度和限时免费活动会变化。文档里不要把“白嫖额度”当成永久额度；实际可用额度以控制台为准。

## Provider 填写

| 字段 | 推荐值 |
|---|---|
| Adapter Type | `OpenAI Chat Completions TTS` |
| Name | `Xiaomi MiMo` 或 `MiMo Trial` |
| Base URL | `https://api.xiaomimimo.com/v1` |
| API Key | MiMo 控制台创建的 key |
| Default Model | `mimo-v2-tts`，或你控制台可用的 TTS / VoiceDesign / VoiceClone 模型 |

保存后：

1. 点 **Fetch All**。
2. 如果模型列表能拉取，选择你要用的 TTS 模型。
3. 如果模型列表为空，但你确认模型名正确，可以手动填模型名。
4. 打开启用开关。
5. 点 **Health Check**。

## 角色创建方式

| 模型类型 | 角色模式 | 需要填什么 |
|---|---|---|
| 普通 TTS | 预设音色 | 选择或填写 preset voice |
| VoiceDesign | 音色设计 | 在 voice instruction 写声音风格 |
| VoiceClone | 音色克隆 | 上传 mp3 / wav 参考音频 |

Neiroha 内置的 MiMo voice 候选会按模型名判断。普通 `mimo-v2-tts` 会提供 `mimo_default`、`default_zh`、`default_en`；v2.5 普通 TTS 模型会提供 `mimo_default`、`冰糖`、`茉莉`、`苏打`、`白桦`、`Mia`、`Chloe`、`Milo`、`Dean`。如果控制台文档更新了，以实际模型返回和官方说明为准。

## 声音设计写法

VoiceDesign 类模型没有固定 preset voice。角色里把任务模式切到声音设计，然后在 instruction 写清楚：

```text
年轻女性，中文普通话，语速略慢，音色干净，适合旁白。
```

生成时，Neiroha 会把 instruction 放到 user message，正文放到 assistant message。

## VoiceClone 注意点

- 参考音频支持 mp3 或 wav。
- 单个参考音频建议短而干净，避免背景音乐和混响。
- Neiroha 会把参考音频编码成 `data:audio/...;base64,...` 再发给模型。
- 当前适配器对参考音频大小有保护，过大的文件会被拒绝。

## 限流和成本

MiMo 适合测试中文声音，但批量项目仍建议设置 Provider 限流：

| 字段 | 建议 |
|---|---|
| 最大并发 | 从 `1` 开始 |
| RPD | 按你的试用额度或每天预算设置 |
| TPM / TPD | 按 Token Plan 或模型计费规则设置 |

Dialog TTS、Phase TTS、Novel Reader、Video Dub 都会消耗同一个 key 的额度。长文本先用短样本确认风格，再批量生成。
