---
title: API 服务器
sidebar_label: API 服务器
---

Neiroha 暴露一个本地 HTTP 服务器，供外部工具通过 OpenAI 兼容接口调用 TTS。

## 启动服务器

打开：

```text
设置 → API Server
```

默认配置：

| 配置 | 默认值 |
|---|---|
| 绑定地址 | `127.0.0.1` |
| 端口 | `8976` |
| API Key | 空 |
| CORS origins | 空 |
| 限流 | `60` req/min/IP |
| 最大请求体 | `1048576` 字节 |

默认只允许本机访问。需要局域网访问时，再将绑定地址改为 `0.0.0.0`，并配置 API Key。

## 接口列表

| 方法 | 路径 | 说明 |
|---|---|---|
| `POST` | `/v1/audio/speech` | 语音合成，OpenAI 兼容 |
| `GET` | `/v1/audio/voices` | 列出激活语音库中的声音 |
| `GET` | `/v1/models` | 将激活语音库列为模型 |
| `GET` | `/speakers` | SillyTavern 兼容说话人列表 |
| `GET` | `/health` | 健康检查 |

完整字段和错误码见 [中文 API 参考](/api-zh)。

## 请求示例

```bash
curl http://localhost:8976/v1/audio/speech \
  -H "Content-Type: application/json" \
  -d '{
    "model": "Default Bank",
    "voice": "Default Voice",
    "input": "你好，世界！",
    "response_format": "wav",
    "speed": 1.0
  }' \
  --output hello.wav
```

## 语音库作为模型

API 以语音库作为 `model` 抽象层：

- 激活语音库会出现在 `/v1/models`。
- 语音库名称可作为 `POST /v1/audio/speech` 的 `model` 值。
- `/v1/audio/voices` 和 `/speakers` 的声音限定在激活语音库范围内。

这让 OpenAI 兼容客户端可以用“模型”选择不同的角色集合。
