---
sidebar_label: English API
---

# Neiroha — Audio API Reference

Neiroha exposes audio APIs in two places:

1. **Neiroha built-in API Server**: exposes the active voice banks in the app as an OpenAI-compatible TTS service.
2. **Provider upstream adapters**: the app calls local or cloud TTS backends through adapter-specific routes.

## 1. Built-In API Server

The built-in server defaults to `127.0.0.1:8976` and can be toggled from **Settings -> API Server**. Bind to `0.0.0.0` only when LAN access is intentional.

### Security and Runtime Controls

| Setting | Default | Notes |
|---|---|---|
| Bind host | `127.0.0.1` | Loopback only by default |
| Port | `8976` | Restart the server after changing |
| API key | empty | When set, requests must send `Authorization: Bearer <key>` or `X-API-Key: <key>` |
| CORS origins | empty | Empty denies browser cross-origin access; `*` allows any origin |
| Rate limit | `60` req/min/IP | `0` disables |
| Max body size | `1048576` bytes | `0` disables declared Content-Length checks |
| API logging | off | Logs metadata only; request bodies and auth headers are not logged |

Every synthesis request goes through the shared `TtsQueueService`, so provider concurrency and rate limits apply to both the desktop UI and external API clients.

### Voice Bank as Model

The built-in API uses **voice banks** as the `model` abstraction:

- Active voice banks appear in `/v1/models`.
- The bank name is used as the `model` value in API requests.
- `/v1/audio/voices` and `/speakers` list voices from active banks only.

### Endpoints

| Method | Path | Description |
|---|---|---|
| `POST` | `/v1/audio/speech` | Synthesize speech from text |
| `GET` | `/v1/audio/voices` | List voices from active voice banks |
| `GET` | `/v1/models` | List active voice banks as OpenAI-style models |
| `GET` | `/speakers` | SillyTavern-style speaker list |
| `GET` | `/health` | Health check |

### `POST /v1/audio/speech`

```json
{
  "input": "Text to synthesize",
  "model": "My Bank",
  "voice": "character_name",
  "speed": 1.0,
  "response_format": "wav"
}
```

| Field | Type | Required | Description |
|---|---|---|---|
| `input` | string | yes | Text to synthesize |
| `voice` | string | yes | Voice character name |
| `model` | string | no | Voice bank name; scopes voice lookup when provided |
| `speed` | number | no | Playback speed multiplier, default `1.0` |
| `response_format` | string | no | Output format hint passed to the upstream adapter |

The response is raw audio bytes with a format-specific `Content-Type`.

Common errors:

| Status | Meaning |
|---|---|
| `400` | Missing `input` or `voice` |
| `401` | Missing or invalid API key when auth is configured |
| `413` | Request body exceeds the configured limit |
| `429` | Per-IP request budget exceeded |
| `404` | Voice character not found |
| `500` | Provider not found or upstream synthesis failed |

## 2. Upstream Provider Adapters

Provider base URL rules depend on the adapter. OpenAI-compatible services usually point to `/v1`; Neiroha native local backends usually use the service root.

### OpenAI TTS API Compatible

For any service exposing the standard OpenAI TTS API.

| Operation | Method | Relative Path |
|---|---|---|
| Synthesize | `POST` | `/audio/speech` |
| Health check / models | `GET` | `/models` |
| Voices | `GET` | `/audio/voices`, then `/speakers` as fallback |

Example payload:

```json
{
  "model": "tts-1",
  "input": "text",
  "voice": "alloy",
  "speed": 1.0,
  "response_format": "wav"
}
```

### Chat Completions TTS

For TTS providers that return audio through Chat Completions, such as MiMo-style audio models.

| Operation | Method | Relative Path |
|---|---|---|
| Synthesize | `POST` | `/chat/completions` |
| Health check / models | `GET` | `/models` |
| Voices | `GET` | `/speakers` |

Neiroha reads base64 audio from `choices[0].message.audio.data`. MiMo-style providers use the `api-key` header by default.

### CosyVoice Native

For the Neiroha CosyVoice3 local backend. The default service root is `http://127.0.0.1:9880`; if the launcher falls back to a random port, use the address printed in the backend log.

Stable OpenAI routes:

| Method | Path | Description |
|---|---|---|
| `GET` | `/health` | Health check |
| `GET` | `/v1/models` | List voice sets |
| `GET` | `/v1/audio/voices` | List voice profiles |
| `POST` | `/v1/audio/speech` | Synthesize with a registered voice |

Standard native routes:

| Method | Path | Description |
|---|---|---|
| `GET` | `/api/cosyvoice/voices` | List registered voices |
| `GET` | `/api/cosyvoice/meta` | Backend metadata |
| `GET` | `/api/cosyvoice/capabilities` | Modes, fields, and upload support |
| `GET` | `/api/cosyvoice/logs` | Runtime logs |
| `POST` | `/api/cosyvoice/tts` | JSON synthesis |
| `POST` | `/api/cosyvoice/tts/upload` | Upload reference audio and synthesize |

Legacy `/cosyvoice/*` and `/cosyvoice3/*` routes remain for compatibility. New integrations should prefer `/api/cosyvoice/*`.

JSON synthesis example:

```json
{
  "text": "Text to synthesize",
  "model": "default",
  "voice": "prompt-clone",
  "mode": "zero_shot",
  "speed": 1.0,
  "response_format": "wav",
  "prompt_audio_path": "/path/to/voices/demo.wav",
  "prompt_text": "reference text",
  "instruct_text": "Read in a gentle and calm tone"
}
```

| Mode | Description | Required Fields |
|---|---|---|
| `zero_shot` / `prompt_clone` | Prompt clone | reference audio + `prompt_text` |
| `cross_lingual` | Cross-lingual clone | reference audio |
| `instruct` | Instruction control | reference audio + `instruct_text` |

### GPT-SoVITS

For the Neiroha GPT-SoVITS local backend. The default service root is `http://127.0.0.1:9880`; if it conflicts with another backend, use the actual port printed in the log.

Stable OpenAI routes:

| Method | Path | Description |
|---|---|---|
| `GET` | `/health` | Health check |
| `GET` | `/v1/models` | List voice sets |
| `GET` | `/v1/audio/voices` | List voice profiles |
| `POST` | `/v1/audio/speech` | Synthesize with a registered voice |

Standard native routes:

| Method | Path | Description |
|---|---|---|
| `GET` | `/api/gpt-sovits/models` | List model presets / low-level weights |
| `GET` | `/api/gpt-sovits/voices` | List voice profiles |
| `GET` | `/api/gpt-sovits/capabilities` | Clone and audio normalization support |
| `GET` | `/api/gpt-sovits/logs` | Runtime logs |
| `POST` | `/api/gpt-sovits/tts` | Native JSON synthesis |
| `POST` | `/api/gpt-sovits/clone` | JSON clone request |
| `POST` | `/api/gpt-sovits/clone/upload` | Upload reference audio and clone |
| `POST` | `/api/gpt-sovits/load` | Load a preset |
| `POST` | `/api/gpt-sovits/unload` | Unload the current model |
| `POST` | `/api/gpt-sovits/reload` | Reload the current model |

Legacy `/gpt-sovits/*` and `/tts` routes remain for compatibility. New integrations should prefer `/api/gpt-sovits/*`.

Clone example:

```json
{
  "input": "Text to synthesize",
  "speaker": "clone",
  "text_lang": "zh",
  "ref_audio_path": "/path/to/ref.wav",
  "prompt_text": "reference text",
  "prompt_lang": "zh",
  "speed": 1.0,
  "response_format": "wav"
}
```

### VoxCPM2 Native

For the Neiroha VoxCPM2 local backend. The default service root is `http://127.0.0.1:8000`.

Stable OpenAI routes:

| Method | Path | Description |
|---|---|---|
| `GET` | `/health` | Health check |
| `GET` | `/v1/models` | List voice sets |
| `GET` | `/v1/audio/voices` | List voice profiles |
| `GET` | `/v1/audio/speakers` | Speaker-list compatibility |
| `POST` | `/v1/audio/speech` | OpenAI-compatible synthesis |

Standard native routes:

| Method | Path | Description |
|---|---|---|
| `GET` | `/api/voxcpm/models` | List model presets / low-level models |
| `GET` | `/api/voxcpm/capabilities` | Modes, aliases, fields, and upload support |
| `GET` | `/api/voxcpm/meta` | Backend metadata |
| `GET` | `/api/voxcpm/logs` | Runtime logs |
| `POST` | `/api/voxcpm/load` | Load a preset |
| `POST` | `/api/voxcpm/unload` | Unload the current model |
| `POST` | `/api/voxcpm/reload` | Reload the current model |
| `POST` | `/api/voxcpm/tts` | Native JSON synthesis |
| `POST` | `/api/voxcpm/tts/upload` | Upload reference / prompt audio and synthesize |
| `GET` | `/api/voxcpm/voices` | List registered voices |
| `POST` | `/api/voxcpm/voices` | Create or update a voice |
| `GET` | `/api/voxcpm/voices/{voice_id}` | Fetch one voice |
| `DELETE` | `/api/voxcpm/voices/{voice_id}` | Delete one voice |

Legacy `/voxcpm/*` routes remain for compatibility. New integrations should prefer `/api/voxcpm/*`.

OpenAI extension fields:

| Field | Description |
|---|---|
| `reference_audio` / `ref_audio` | Reference audio: local path, `file://`, `http(s)://`, or `data:audio/...;base64,...` |
| `prompt_audio` | Prompt audio for ultimate clone |
| `prompt_text` / `ref_text` | Transcript for prompt audio |
| `mode` | `design`, `clone`, `ultimate_clone`, or compatible aliases |
| `instruction` | Natural-language voice description |
| `auto_asr` | Use optional ASR to transcribe prompt text |
| `cfg_value`, `inference_timesteps`, `normalize`, `denoise` | VoxCPM2 inference controls |

### Azure Speech Service

| Operation | Method | Path |
|---|---|---|
| Synthesize | `POST` | `/cognitiveservices/v1` |
| Health check / voices | `GET` | `/cognitiveservices/voices/list` |

Base URL can be a region like `eastus` or an endpoint such as `https://eastus.tts.speech.microsoft.com`. Neiroha sends the API key as `Ocp-Apim-Subscription-Key`.

### Google Gemini TTS

Gemini TTS uses a Google AI Studio API key. Set the provider URL to `https://generativelanguage.googleapis.com`, then choose a Gemini TTS model and voice.

### Windows System TTS

Windows desktop uses system SAPI voices and needs no base URL or API key. Android, Apple, and Linux system TTS providers remain hidden until native platform adapters exist.

## 3. Response Headers and Troubleshooting

Neiroha local backends usually include these audio response headers. Exact fields vary by backend:

| Header | Meaning |
|---|---|
| `X-Neiroha-Backend` | Backend name |
| `X-Neiroha-Model-Preset` | Low-level model preset |
| `X-Neiroha-Voice` | Actual voice used |
| `X-Neiroha-Sample-Rate` | Output sample rate |
| `X-Neiroha-Inference-Ms` | Inference time |
| `X-Neiroha-Audio-Seconds` | Output duration |
| `X-Neiroha-Output-Path` | Server-side output file path |
| `X-Neiroha-RTF` | Measured local RTF |

Troubleshooting order:

1. Open `/health` in a browser or with `curl`.
2. Check `/v1/models` and `/v1/audio/voices`.
3. In Providers, click **Fetch All** and confirm models and voices are cached.
4. Test one sentence in Quick TTS before running Dialogue, Phase, or Video batches.
