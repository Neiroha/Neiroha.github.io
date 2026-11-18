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
| `POST` | `/mcp` | Available since v0.4.0. Agents can manage voices, synthesis and dubbing projects over Streamable HTTP. |

See [API Reference](/api) for complete fields and error codes.

To start the API and MCP automatically when Neiroha launches, enable API auto-start in Settings (v0.4.1 or later).

## MCP and Streaming PCM

Agents connect to `http://127.0.0.1:8976/mcp`. The MCP toggle is under **Settings → API Server**. See the [Neiroha dubbing skill](https://github.com/Neiroha/Neiroha/blob/dev/assets/skills/neiroha-dubbing/SKILL.md) for usage. Set an API key when binding MCP to a non-loopback address.

Starting with v0.5.0, send `"stream": true` and `"response_format": "pcm"` to `/v1/audio/speech` to request incremental PCM. The `audio/pcm` response includes `X-Audio-Encoding`, `X-Audio-Sample-Rate`, and `X-Audio-Channels`. Unsupported providers return `400`. Closing the connection cancels that request.

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
