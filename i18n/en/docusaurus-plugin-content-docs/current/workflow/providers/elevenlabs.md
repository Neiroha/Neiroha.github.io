---
title: ElevenLabs
sidebar_label: ElevenLabs
---

In Providers, choose **ElevenLabs**, use `https://api.elevenlabs.io`, and enter your account's API key. Neiroha sends `xi-api-key` and fetches `/v1/models` and `/v2/voices`. Save and fetch the lists, then choose a model and a `Name [voice_id]` for your character.

## Model Compatibility

These are the built-in options in v0.5.0. When model discovery succeeds, the returned list reflects your account's access.

| Model ID | Native | Web | Streaming playback | Voice instructions |
|---|---|---|---|---|
| `eleven_v4` (default) | Supported | Voice ID, requires CORS | Plays after generation | Audio tags |
| `eleven_v4_turbo` | Supported | Voice ID, requires CORS | Plays after generation | Audio tags |
| `eleven_v3` | Supported | Voice ID, requires CORS | Plays after generation | Audio tags |
| `eleven_multilingual_v2` | Supported | Voice ID, requires CORS | Plays after generation | — |
| `eleven_flash_v2_5` | Supported | Voice ID, requires CORS | Plays after generation | — |
| `eleven_flash_v2` | Supported | Voice ID, requires CORS | Plays after generation | — |

You can put tags such as `[whispers]` in the character's voice instructions for v3/v4 models. Neiroha v0.5.0 calls `/v1/text-to-speech/{voice_id}` and plays the complete MP3. Select an existing cloned voice by its ID. Use the native client to upload a reference recording and create a new voice on your ElevenLabs account. [ElevenLabs API](https://elevenlabs.io/docs/api-reference/text-to-speech/convert) · [v0.5.0 adapter](https://github.com/Neiroha/Neiroha/blob/v0.5.0/lib/data/adapters/elevenlabs_adapter.dart)
