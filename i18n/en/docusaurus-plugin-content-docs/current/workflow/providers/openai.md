---
title: OpenAI TTS
sidebar_label: OpenAI
---

Under Providers, choose **OpenAI TTS (Official)** and use `https://api.openai.com/v1`. Enter your OpenAI API key in the desktop client, fetch models and voices, then pick a model and preset voice in Voice Bank. For a third-party gateway, choose the adapter for its protocol.

## Model Compatibility

This table describes Neiroha v0.5.0. Web requests also depend on the provider's HTTPS and CORS settings. Streaming means playback can start before the full clip finishes generating.

| Model ID | API | Native | Web | Streaming playback |
|---|---|---|---|---|
| `gpt-realtime-2.1-mini` (default) | Realtime WebSocket | Supported | Unavailable | Native |
| `gpt-realtime-2.1` | Realtime WebSocket | Supported | Unavailable | Native |
| `gpt-4o-mini-tts` | Speech API | Supported | Requires CORS | Native and Web |
| `gpt-4o-mini-tts-2025-12-15` | Speech API | Supported | Requires CORS | Native and Web |
| `tts-1` | Speech API | Supported | Requires CORS | Native and Web |
| `tts-1-hd` | Speech API | Supported | Requires CORS | Native and Web |

Both Realtime models and the `gpt-4o-mini-tts` family accept voice instructions. `tts-1` and `tts-1-hd` use preset voices. This adapter accepts preset voices and voice IDs already on the account. Characters can use those voices without a reference recording. [v0.5.0 adapter](https://github.com/Neiroha/Neiroha/blob/v0.5.0/lib/data/adapters/openai_tts_adapter.dart)

## Realtime Generation on Web

Web Quick TTS in v0.5.0 connects to OpenAI's HTTP Speech API. The picker can still show `gpt-realtime-*` and the rejection message may mention reference files. Switch to `gpt-4o-mini-tts` or its `2025-12-15` snapshot and choose a preset voice. Use the native client for Realtime. [Tracking issue](https://github.com/Neiroha/Neiroha/issues/9)

OpenAI is scheduled to shut down the Speech API models in the table on January 6, 2027. The current Web route depends on those models remaining available. Follow the tracking issue for browser Realtime progress. [OpenAI deprecations](https://developers.openai.com/api/docs/deprecations)

Your browser sends requests directly to the provider you configure. Keep long-lived cloud API keys on your backend or configure them in the desktop client. [Web demo](../../guide/web-demo.mdx) · [Streaming audio](../streaming.md)
