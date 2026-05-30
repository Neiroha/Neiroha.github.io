---
title: MiMo TTS
sidebar_label: MiMo
---

MiMo uses Neiroha's **OpenAI Chat Completions TTS** adapter. This is not `/v1/audio/speech`; it calls `/v1/chat/completions` and reads base64 audio from `message.audio.data`.

## Prepare an API Key

1. Open [Xiaomi MiMo](https://mimo.mi.com/) or the MiMo platform console.
2. Sign in.
3. Check Token Plan, credits, model availability, and API keys.
4. Create a key dedicated to Neiroha so usage can be tracked separately.

MiMo plans, free credits, and campaigns can change. Treat free quota as temporary and rely on the console for actual availability.

## Provider Fields

| Field | Recommended Value |
|---|---|
| Adapter Type | `OpenAI Chat Completions TTS` |
| Name | `Xiaomi MiMo` or `MiMo Trial` |
| Base URL | `https://api.xiaomimimo.com/v1` |
| API Key | Key created in the MiMo console |
| Default Model | `mimo-v2-tts`, or an available TTS / VoiceDesign / VoiceClone model |

After saving:

1. Click **Fetch All**.
2. Select the TTS model when the model list is available.
3. If the list is empty but the model name is known, fill it manually.
4. Enable the provider.
5. Click **Health Check**.

## Character Modes

| Model Type | Character Mode | Required Input |
|---|---|---|
| Normal TTS | Preset voice | Select or fill a preset voice. |
| VoiceDesign | Voice design | Write style in voice instruction. |
| VoiceClone | Voice clone | Upload mp3 / wav reference audio. |

Neiroha guesses MiMo voice candidates by model name. `mimo-v2-tts` provides `mimo_default`, `default_zh`, and `default_en`. v2.5 normal TTS models provide `mimo_default`, several Chinese-named presets shown in the MiMo console, plus `Mia`, `Chloe`, `Milo`, and `Dean`. If console docs change, use actual model responses and official docs.

## VoiceDesign Prompting

VoiceDesign models do not have fixed preset voices. Switch the character to voice design mode and fill the instruction:

```text
Young female voice, Mandarin Chinese, slightly slow speed, clean tone, suitable for narration.
```

Neiroha sends the instruction in the user message and the text body in the assistant message.

## VoiceClone Notes

- Reference audio supports mp3 or wav.
- Use short, clean clips without background music or reverb.
- Neiroha encodes reference audio as `data:audio/...;base64,...`.
- The adapter rejects oversized reference files.

## Rate Limits and Cost

MiMo is useful for testing Chinese voices, but batch projects should set provider limits:

| Field | Recommendation |
|---|---|
| Max concurrency | Start with `1`. |
| RPD | Set according to trial quota or daily budget. |
| TPM / TPD | Set according to Token Plan or model billing rules. |

Dialogue TTS, Phase TTS, Novel Reader, and Video Dubbing all consume the same key. Confirm style with short samples before batch generation.
