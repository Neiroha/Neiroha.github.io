---
title: Configure Providers
sidebar_label: Providers
---

A provider is Neiroha's connection entry for an external TTS backend. It stores how to access the service. The actual voices used by projects are bound later in [Voice Characters and Voice Banks](/workflow/voice-bank).

<img className="screenshot" src="/img/screenshot_providers.png" alt="Provider configuration page" />

## Core Relationship

| Layer | Location in Neiroha | Purpose |
|---|---|---|
| Provider | **Providers** | Stores Base URL, API key, adapter type, concurrency, and rate limits. |
| Model / Voice Cache | Provider detail panel | Caches models and voices fetched from the backend. |
| Voice Character | **Voice Bank** | Binds one provider, model, voice, speed, reference audio, or voice description into a character. |
| Voice Bank | **Voice Bank** | Groups characters for Dialogue, Phase, Novel, Video, and API workflows. |

## Adapter Types

Choose the adapter for the service's actual API. The model guides use “native” for the Windows, macOS, Linux and Android clients, with a separate entry for Windows system voices. Remote providers on Web require HTTPS and cross-origin access. Check the provider for model availability on your account.

| Adapter | Connects to | Web synthesis |
|---|---|---|
| [OpenAI TTS (Official)](./providers/openai.md) | OpenAI Speech and Realtime | Speech, with streaming |
| [OpenAI TTS API Compatible](./providers/local-engines.md) | Self-hosted or third-party `/v1/audio/speech` servers | Whole clip |
| [OpenAI Chat Completions TTS](./providers/mimo.md) | MiMo and other models that return audio via Chat Completions | Whole clip, with no local reference file |
| [ElevenLabs](./providers/elevenlabs.md) | ElevenLabs models and account voices | Whole clip by voice ID |
| [MiniMax Speech](./providers/minimax.md) | MiniMax models and account voices | Whole clip by voice ID |
| [Google Gemini TTS](./providers/gemini.md) | Gemini TTS | Whole clip |
| [Azure Speech Service](./providers/azure.md) | Azure preset voices | Whole clip |
| [IndexTTS 2.5 (WebUI)](./providers/indextts.md) | A Gradio WebUI with a character reference recording | Unavailable |
| [GPT-SoVITS](./providers/gpt-sovits.md) | GPT-SoVITS servers | Native adapter unavailable |
| [CosyVoice Native](./providers/cosyvoice.md) | CosyVoice inference servers | Native adapter unavailable |
| [VoxCPM2 Native](./providers/voxcpm.md) | VoxCPM2 inference servers | Native adapter unavailable |
| Windows System TTS | Local Windows SAPI | Unavailable |

Quick TTS adds clips to history once generation is complete. See [streaming audio](./streaming.md) for playback and cancellation.

## Create a Provider

1. Open **Providers** from the left navigation.
2. Click **+** at the top of the provider list.
3. Select an adapter type. Local model setup is covered in [Connect Local Inference Backends](/workflow/providers/local-engines); cloud or free quota setup is covered in [Connect Cloud Inference Backends](/workflow/providers/cloud-engines).
4. Set a name, such as `MiMo Free Trial`, `CosyVoice Local 9880`, or `Azure East US`.
5. Fill `Base URL` and `API Key`.
6. Save, return to the provider detail panel, click **Fetch All**, then enable the provider.
7. Click **Health Check**. After it passes, create voice characters.

## Base URL Rules

| Scenario | Example | Notes |
|---|---|---|
| Desktop app to local service | `http://127.0.0.1:8880/v1` | OpenAI-compatible services usually include `/v1`. |
| Desktop app to LAN service | `http://192.168.1.20:9880` | Allow the port through the firewall. |
| Android emulator to host machine | `http://10.0.2.2:9880` | `127.0.0.1` inside the emulator means the emulator itself. |
| Android phone to computer | `http://LAN-IP:9880` | Phone and computer must be on the same network, or reachable through tunneling. |
| Azure | `eastus` or `https://eastus.tts.speech.microsoft.com` | Neiroha normalizes region names to TTS endpoints. |
| Gemini | `https://generativelanguage.googleapis.com` | Uses Google AI Studio API key. |
| MiMo | `https://api.xiaomimimo.com/v1` | Uses the `api-key` header, not a Bearer header. |

## API Key and Authentication

| Adapter | Key Required | Authentication Used by Neiroha |
|---|---|---|
| OpenAI TTS (Official) | Required | `Authorization: Bearer <key>` |
| ElevenLabs | Required | `xi-api-key: <key>` |
| MiniMax Speech | Required | `Authorization: Bearer <key>` |
| IndexTTS 2.5 WebUI | Depends on the WebUI | `Authorization: Bearer <key>` when configured |
| OpenAI TTS API Compatible | Depends on server | `Authorization: Bearer <key>` |
| OpenAI Chat Completions TTS | Usually required for cloud | `api-key: <key>` by default for MiMo-style APIs |
| Google Gemini TTS | Required | `x-goog-api-key: <key>` |
| Azure Speech Service | Required | `Ocp-Apim-Subscription-Key: <key>` |
| GPT-SoVITS / CosyVoice / VoxCPM2 local | Usually empty | Fill only if the local server enables authentication. |
| Windows System TTS | Not required | Local SAPI |

## After Fetch All

Click **Fetch All** to cache backend models and voices. This determines what appears in character creation dropdowns.

| Result | Meaning | Action |
|---|---|---|
| Models and voices both appear | Full listing works | Enable the provider and go to Voice Bank. |
| Models appear, voices are empty | Backend lacks a voice-list API, or model uses voice design | Fill voice or instruction manually. |
| Voices appear, models are empty | Common for Azure or system TTS | Select a voice in the character. |
| Empty list but Health Check passes | Service is reachable, but list APIs are incompatible | Fill default model and voice manually, then run Quick Test. |
| Health Check fails | URL, key, port, network, or region is wrong | Verify the backend with browser or curl, then update the provider. |

## Separate Concurrency from Quota

Provider concurrency, RPM, TPM, and RPD limits apply to all workflows: Quick TTS, Dialogue TTS, Phase TTS, Novel Reader, Video Dubbing, and the local API Server share the same `TtsQueueService`.

Recommended starting points:

| Backend | Recommended Setting |
|---|---|
| Local GPU service | Start max concurrency at `1`, then increase after VRAM is stable. |
| Gemini free tier | Follow official RPM / TPM / RPD rate limits to avoid 429 errors. |
| Azure F0 | Mainly control character quota and batch size; test long text in small Phase TTS batches. |
| MiMo / other token plans | Use console balance and model consumption rules; set conservative RPD / TPM. |

## Next Steps

- Local service, LAN service, or Android emulator connection: [Connect Local Inference Backends](/workflow/providers/local-engines)
- GPT-SoVITS: [Neiroha GPT-SoVITS](/workflow/providers/gpt-sovits)
- VoxCPM2: [Neiroha VoxCPM2](/workflow/providers/voxcpm)
- CosyVoice3: [Neiroha CosyVoice3](/workflow/providers/cosyvoice)
- Cloud services and free quotas: [Connect Cloud Inference Backends](/workflow/providers/cloud-engines)
- MiMo: [MiMo TTS](/workflow/providers/mimo)
- Gemini: [Gemini TTS](/workflow/providers/gemini)
- Azure: [Azure Speech](/workflow/providers/azure)
- After a provider passes, continue to [Voice Characters and Voice Banks](/workflow/voice-bank).
