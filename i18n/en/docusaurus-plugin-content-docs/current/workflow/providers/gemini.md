---
title: Gemini TTS
sidebar_label: Gemini
---

Gemini TTS uses Neiroha's **Google Gemini TTS** adapter and calls the native text-to-speech capability of the Gemini API. It is useful for small tests and style experiments with a Google AI Studio API key.

## Model Compatibility

These are the v0.5.0 built-in options. Check AI Studio for account availability and quotas. Synthesis requires text and a voice. Web also requires CORS.

| Model ID | API | Native | Web | Streaming playback |
|---|---|---|---|---|
| `gemini-3.8-flash-tts` (default) | Interactions | Supported | Requires CORS | Plays after generation |
| `gemini-3.8-flash-lite-tts` | Interactions | Supported | Requires CORS | Plays after generation |
| `gemini-3.1-flash-tts-preview` | generateContent | Supported | Requires CORS | Plays after generation |
| `gemini-2.5-flash-preview-tts` | generateContent | Supported | Requires CORS | Plays after generation |
| `gemini-2.5-pro-preview-tts` | generateContent | Supported | Requires CORS | Plays after generation |

[Google TTS docs](https://ai.google.dev/gemini-api/docs/speech-generation) · [Rate limits](https://ai.google.dev/gemini-api/docs/rate-limits) · [Pricing](https://ai.google.dev/gemini-api/docs/pricing)

## Provider Fields

| Field | Recommended Value |
|---|---|
| Adapter Type | `Google Gemini TTS` |
| Name | `Google AI Studio` |
| Base URL | `https://generativelanguage.googleapis.com` |
| API Key | Google AI Studio API key |
| Default Model | `gemini-3.8-flash-tts` |

After saving:

1. Click **Fetch All**.
2. Neiroha shows built-in Gemini TTS models and official preset voices.
3. Enable the provider.
4. Click **Health Check**.
5. Create a preset-voice character in Voice Bank.

## Voices

Neiroha includes the following 30 preset voices. When `/v1beta/voices` is available, it also adds voices from the extended library.

```text
Zephyr, Puck, Charon, Kore, Fenrir, Leda, Orus, Aoede,
Callirrhoe, Autonoe, Enceladus, Iapetus, Umbriel, Algieba,
Despina, Erinome, Algenib, Rasalgethi, Laomedeia, Achernar,
Alnilam, Schedar, Gacrux, Pulcherrima, Achird, Zubenelgenubi,
Vindemiatrix, Sadachbia, Sadaltager, Sulafat
```

For the first test, `Kore` or `Puck` with short text is a good starting point.

## Character Settings

| Goal | Character Setting |
|---|---|
| Normal reading | Use preset voice mode and select a Gemini preset voice. |
| Style control | Put director-style hints such as "gentle, low voice, news style" in the character voice instruction. |
| Voice cloning | Not supported; the Gemini TTS adapter rejects reference-audio cloning. |

Gemini TTS has no dedicated speed field. Neiroha converts non-`1.0` speed choices into natural-language style prompts.

## Free Quota Usage

Check the console for that model’s request and token limits. Try one short sentence, then set RPM, TPM and RPD to fit your account.
