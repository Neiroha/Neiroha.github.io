---
title: API Server
sidebar_label: API Server
---

Neiroha exposes a local HTTP server so external tools can call TTS through an OpenAI-compatible interface.

## Start the Server

Open:

```text
Settings -> API Server
```

Default settings:

| Setting | Default |
|---|---|
| Bind host | `127.0.0.1` |
| Port | `8976` |
| API key | empty |
| CORS origins | empty |
| Rate limit | `60` req/min/IP |
| Max body size | `1048576` bytes |

By default, only local loopback access is allowed. For LAN access, set the bind host to `0.0.0.0` and configure an API key.

When an API key is configured, clients must send either:

```bash
Authorization: Bearer <key>
```

or:

```bash
X-API-Key: <key>
```

If the API key is empty, omit the auth header from request examples.

## Endpoints

| Method | Path | Description |
|---|---|---|
| `POST` | `/v1/audio/speech` | OpenAI-compatible speech synthesis |
| `GET` | `/v1/audio/voices` | List voices in the active voice bank |
| `GET` | `/v1/models` | List active voice banks as models |
| `GET` | `/speakers` | SillyTavern-compatible speaker list |
| `GET` | `/health` | Health check |

See [API Reference](/api) for complete fields and error codes.

## Request Example

```bash
curl http://localhost:8976/v1/audio/speech \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <key>" \
  -d '{
    "model": "Default Bank",
    "voice": "Default Voice",
    "input": "Hello, world!",
    "response_format": "wav",
    "speed": 1.0
  }' \
  --output hello.wav
```

## Voice Banks as Models

The API uses voice banks as the `model` abstraction:

- Active voice banks appear in `/v1/models`.
- A voice bank name can be used as the `model` value in `POST /v1/audio/speech`.
- `/v1/audio/voices` and `/speakers` are scoped to the active voice bank.

This lets OpenAI-compatible clients select different character sets through the model field.
