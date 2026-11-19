---
title: MiniMax Speech
sidebar_label: MiniMax Speech
---

In Providers, choose **MiniMax Speech**. Use `https://api.minimax.io` for the international platform or `https://api.minimaxi.com` for the mainland China platform. Enter the API key for that platform, save, fetch voices, then assign a model and `voice_id` to your character. Neiroha supplies the model list and reads voices from `/v1/get_voice`.

## Model Compatibility

| Model ID | Native | Web | Streaming playback |
|---|---|---|---|
| `speech-2.8-hd` (default) | Supported | Voice ID, requires CORS | Plays after generation |
| `speech-2.8-turbo` | Supported | Voice ID, requires CORS | Plays after generation |
| `speech-2.6-hd` | Supported | Voice ID, requires CORS | Plays after generation |
| `speech-2.6-turbo` | Supported | Voice ID, requires CORS | Plays after generation |
| `speech-02-hd` | Supported | Voice ID, requires CORS | Plays after generation |
| `speech-02-turbo` | Supported | Voice ID, requires CORS | Plays after generation |

Voice instructions can contain `happy`, `sad`, `angry`, `fearful`, `disgusted`, `surprised`, `calm`, `fluent` or `whisper`. Neiroha sends those values as `emotion` when set. Availability depends on the model. In v0.5.0, `/v1/t2a_v2` runs with `stream: false` and playback starts once the audio is complete. The native client can upload a reference and register a voice. Web uses existing voice IDs. [MiniMax API](https://platform.minimax.io/docs/api-reference/speech-t2a-http) · [v0.5.0 adapter](https://github.com/Neiroha/Neiroha/blob/v0.5.0/lib/data/adapters/minimax_tts_adapter.dart)
