---
title: Streaming Audio and Playback
sidebar_label: Streaming Audio
---

Streaming playback starts when the first audio chunks arrive. With adapters that return a complete file, Quick TTS plays after generation finishes. This page covers Neiroha v0.5.0.

## Quick TTS

1. Assign a supported model and voice to a character. Use OpenAI Speech or Realtime in the native client. Web uses OpenAI Speech. See the [OpenAI model table](./providers/openai.md#model-compatibility).
2. Leave the automatic streaming option enabled in Quick TTS. Enter text and start generating. You can pause, but seeking is limited to audio that has arrived.
3. Stop cancels a request that is still running and discards incomplete audio. Replay completed clips from history. On Web, download any clips you want to keep before reloading or closing the tab.

The native novel reader and single-line previews also use streaming with compatible adapters. The novel reader plays an existing valid cache directly. Bulk export waits for complete audio.

## Adapter Support

| Adapter | Native | Web |
|---|---|---|
| [OpenAI](./providers/openai.md) | Speech PCM and Realtime PCM | Speech PCM |
| [OpenAI-compatible HTTP](./providers/local-engines.md), [MiMo](./providers/mimo.md), [Gemini](./providers/gemini.md), [Azure](./providers/azure.md) | Plays after generation | Plays after generation, requires CORS |
| [ElevenLabs](./providers/elevenlabs.md), [MiniMax](./providers/minimax.md) | Plays after generation | Reachable HTTP endpoint and existing voice ID |
| [IndexTTS 2.5](./providers/indextts.md), [GPT-SoVITS](./providers/gpt-sovits.md), [VoxCPM2](./providers/voxcpm.md), [CosyVoice](./providers/cosyvoice.md) | Plays after generation | Native adapters unavailable |
| Windows system voice | Plays after generation on Windows | Unavailable |

The table describes the endpoints used by Neiroha. For example, the IndexTTS adapter uses SSE to wait for a completion event and then downloads the audio. A server that can return audio chunks still needs an adapter that consumes those chunks for playback.

## PCM from the Local HTTP API

Start the [API server](../operations/api-server.md) in the native client. Call `POST /v1/audio/speech` with a voice from the active bank and both `"stream": true` and `"response_format": "pcm"`. The response is `audio/pcm` with `X-Audio-Encoding: pcm_s16le`. Read the sample rate and channel count from `X-Audio-Sample-Rate` and `X-Audio-Channels`. Feed the raw bytes to one decoder or playback session.

Closing the HTTP connection cancels an in-flight request. The API returns `400` if the selected adapter cannot produce incremental PCM. A whole-file call is available in that case. [API fields and authentication](../api.md)
