---
title: Gemini TTS
sidebar_label: Gemini
---

Gemini TTS uses Neiroha's **Google Gemini TTS** adapter and calls the native text-to-speech capability of the Gemini API. It is useful for small tests and style experiments with a Google AI Studio API key.

## Official Limits

Google marks Gemini TTS as Preview. Official rate-limit pages currently list `gemini-2.5-flash-preview-tts` free-tier limits as `3 RPM / 10,000 TPM / 15 RPD`. Quotas, model names, and availability can change; use the AI Studio console as the source of truth.

Official pages:

- [Speech generation](https://ai.google.dev/gemini-api/docs/speech-generation)
- [Pricing](https://ai.google.dev/gemini-api/docs/pricing)
- [Rate limits](https://ai.google.dev/gemini-api/docs/rate-limits)

## Provider Fields

| Field | Recommended Value |
|---|---|
| Adapter Type | `Google Gemini TTS` |
| Name | `Google AI Studio` |
| Base URL | `https://generativelanguage.googleapis.com` |
| API Key | Google AI Studio API key |
| Default Model | `gemini-2.5-flash-preview-tts` by default |

After saving:

1. Click **Fetch All**.
2. Neiroha shows built-in Gemini TTS models and official preset voices.
3. Enable the provider.
4. Click **Health Check**.
5. Create a preset-voice character in Voice Bank.

## Voices

Gemini TTS official docs list 30 preset voices. Neiroha shows them as a fixed list, including:

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

Gemini free-tier request counts are suitable for Quick TTS and short Dialogue tests, not complete novels.

Recommended provider limits:

| Field | Value |
|---|---|
| Max concurrency | `1` |
| RPM | `3` or lower |
| TPM | `10000` or lower |
| RPD | `15` or the value shown in your console |

If you hit `429 RESOURCE_EXHAUSTED`, pause requests, then lower concurrency and batch size.
