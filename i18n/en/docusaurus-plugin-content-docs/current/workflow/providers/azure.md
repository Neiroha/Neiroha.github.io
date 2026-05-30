---
title: Azure Speech
sidebar_label: Azure
---

Azure Speech uses Neiroha's **Azure Speech Service** adapter and calls the Microsoft Speech Text-to-Speech REST API. It is useful for stable voice lists, SSML prosody, and the Azure F0 free tier.

## Free Tier and Official Links

Azure Speech pricing lists a monthly free character quota for Free F0 Neural Text to Speech. The page currently lists Neural TTS as `0.5 million characters free per month`. Pricing and regional availability can change; use Azure pricing and your subscription console as the source of truth.

Official pages:

- [Azure Text-to-Speech docs](https://learn.microsoft.com/en-us/azure/ai-services/speech-service/index-text-to-speech)
- [Azure Speech pricing](https://azure.microsoft.com/en-us/pricing/details/speech/)

## Create an Azure Speech Resource

1. Open Azure Portal.
2. Create **Speech service**, or create a Speech resource under Foundry / Azure AI services.
3. Choose a region, such as `eastus`, `westus2`, or `southeastasia`.
4. Copy a key from **Keys and Endpoint**.
5. Keep the region name. The region and key must belong to the same resource.

## Provider Fields

| Field | Recommended Value |
|---|---|
| Adapter Type | `Azure Speech Service` |
| Name | `Azure Speech East US` |
| Base URL | `eastus`, or `https://eastus.tts.speech.microsoft.com` |
| API Key | Azure Speech subscription key |
| Default Model | Empty |

Neiroha accepts three Base URL forms:

```text
eastus
https://eastus.tts.speech.microsoft.com
https://eastus.api.cognitive.microsoft.com
```

They are normalized internally to `https://{region}.tts.speech.microsoft.com`.

## Fetch Voices

1. Save the provider.
2. Click **Fetch All**.
3. Azure returns voices from `/cognitiveservices/voices/list`.
4. When creating a character, select a ShortName such as `en-US-AriaNeural` or `zh-CN-XiaoxiaoNeural`.
5. Run Quick Test with one short sentence.

## Speed and Format

The Azure adapter uses SSML:

| Neiroha Field | Azure Behavior |
|---|---|
| voice | Written into `<voice name="...">` |
| speed | Written into `<prosody rate="...">` |
| response_format | Mapped to Azure `X-Microsoft-OutputFormat` |

Default output is WAV. MP3, OGG/Opus, or PCM can also be requested.

## Common Failures

| Symptom | Cause | Fix |
|---|---|---|
| `401` / `403` | Key and region mismatch, or wrong key | Copy key and region from the same Azure resource. |
| Fetch All returns empty | Base URL is not a Speech TTS endpoint | Use the region name, such as `eastus`. |
| Chinese voice unavailable | Selected voice does not support target language | Use a `zh-CN-*Neural` voice or the official voice list. |
| Free quota exhausted | F0 character quota is spent | Wait for monthly reset or upgrade the pricing tier. |
