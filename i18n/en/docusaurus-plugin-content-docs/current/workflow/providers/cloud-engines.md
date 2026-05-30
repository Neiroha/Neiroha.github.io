---
title: Connect Cloud Inference Backends
sidebar_label: Cloud / Free Quota
---

Cloud TTS is useful for trials, cross-device use, or setups that do not deploy local models. "Free" usually means free tiers, trial quotas, gifted credits, or limited-time campaigns. Quotas and model availability can change; rely on the provider console.

## General Steps

1. Create an account and API key on the cloud service.
2. Open **Providers** in Neiroha and click **+**.
3. Select the matching adapter.
4. Fill `Base URL`, `API Key`, and model name when required.
5. Click **Fetch All** to fetch models and voices.
6. Enable the provider.
7. Click **Health Check**.
8. Create a character in **Voice Bank** and run Quick Test with one short sentence.

## Cloud Entry Points

| Service | Neiroha Adapter | Why Try It | Details |
|---|---|---|---|
| MiMo | OpenAI Chat Completions TTS | One key can access TTS, VoiceDesign, and VoiceClone-style models; useful for Chinese and Chinese-English tests. | [MiMo TTS](/workflow/providers/mimo) |
| Google Gemini TTS | Google Gemini TTS | AI Studio API key; official docs list free-tier limits for Gemini 2.5 Flash Preview TTS. | [Gemini TTS](/workflow/providers/gemini) |
| Azure Speech | Azure Speech Service | Azure F0 provides a monthly Neural TTS character quota and stable voice lists. | [Azure Speech](/workflow/providers/azure) |

## Free Quota Usage

| Workflow | Recommendation |
|---|---|
| Quick TTS | Generate one sentence at a time to confirm character binding. |
| Dialogue TTS | Manually generate 2 to 3 lines before clicking generate all. |
| Phase TTS | Split 3 to 5 segments first to verify long-text style and cost. |
| Novel Reader | Keep prefetch low to avoid spending quota immediately. |
| Video Dubbing | Test a short subtitle section before generating all cues. |

## Provider Rate Limits

Cloud failures are often rate-limit failures rather than configuration errors. Set these fields in the provider:

| Field | Purpose |
|---|---|
| Max concurrency | Controls simultaneous TTS requests. |
| RPM | Requests per minute; useful for services like Gemini. |
| TPM | Tokens per minute; useful for token-limited or token-billed services. |
| RPD | Requests per day; useful for free tiers. |

For example, set conservative RPM / TPM / RPD values for `gemini-2.5-flash-preview-tts`, control Azure F0 by character quota and batch size, and use MiMo Token Plan balance and model consumption rules as the source of truth.

## Official Links

- [Xiaomi MiMo](https://mimo.mi.com/)
- [Gemini API Speech generation](https://ai.google.dev/gemini-api/docs/speech-generation)
- [Gemini API pricing](https://ai.google.dev/gemini-api/docs/pricing)
- [Gemini API rate limits](https://ai.google.dev/gemini-api/docs/rate-limits)
- [Azure Speech Text-to-Speech docs](https://learn.microsoft.com/en-us/azure/ai-services/speech-service/index-text-to-speech)
- [Azure Speech pricing](https://azure.microsoft.com/en-us/pricing/details/speech/)
