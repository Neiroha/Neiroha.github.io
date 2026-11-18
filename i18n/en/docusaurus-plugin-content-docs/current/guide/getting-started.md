---
title: Quick Start
sidebar_label: Quick Start
---

## Requirements

- Windows 10/11, Linux x64, or an Android device.
- At least one reachable TTS backend: local, LAN-hosted, or cloud-hosted.
- Flutter is not required for normal use. Download a Release build instead.

## 1. Download a Release Build

Download the stable build from [Neiroha Releases](https://github.com/Neiroha/Neiroha/releases/latest). Choose your platform and architecture in the [installation guide](./install-release.md), try the browser workspace in the [Web demo](./web-demo.mdx), or browse the [release history](./releases.md).

## 2. Prepare a TTS Backend

Neiroha is a TTS workstation and middleware layer. It does not include large-model inference by itself. Prepare one backend before first use:

| Choice | Good For | Next Step |
|---|---|---|
| Local inference backend | Local GPU users, LAN inference servers, or workflows that keep text local | [Connect Local Inference Backends](/workflow/providers/local-engines) |
| Cloud / free quota | Quick trials without local model deployment | [Connect Cloud Inference Backends](/workflow/providers/cloud-engines) |
| Windows system voice | Workflow validation without AI voices | Use Windows System TTS in Providers |

Local backend Windows NVIDIA portable packages are available, mainly for RTX 30 / 40 / 50 series users. GPT-SoVITS, VoxCPM2, and CosyVoice3 can be downloaded as split archives from their own Release pages. If GitHub downloads are unstable, use the Baidu Netdisk mirrors in the Release body; see [Windows Portable Backend Packages](/workflow/providers/local-engines#windows-portable-backend-packages).

### Choose a Route

| Goal | Recommended Route |
|---|---|
| Hear the first sample as fast as possible | Use Windows System TTS or a cloud free quota, then pass Quick Test. |
| Keep text local | Use a GPT-SoVITS, CosyVoice3, or VoxCPM2 local backend. |
| Test Chinese-English or multilingual output | Try Gemini, MiMo, CosyVoice3, or VoxCPM2 first, then keep the best provider. |
| Use reference-audio cloning | Use GPT-SoVITS, CosyVoice3, or VoxCPM2 and prepare clean short reference audio. |
| Batch novels, audiobooks, or subtitle dubbing | Prefer a local backend; cloud providers should use RPM, TPM, RPD, and low concurrency limits. |
| Serve scripts, games, or external tools | Create a voice bank, pass Quick Test, then enable the [API Server](/operations/api-server). |

## 3. Configure a Provider

Open **Providers**. The left side lists providers, and the right side shows the selected provider form.

<img className="screenshot" src="/img/screenshot_providers.png" alt="Provider configuration page" />

Basic flow:

1. Click **+** at the top of the provider list.
2. Select an adapter type.
3. Fill `Base URL`, `API Key`, and any required model name.
4. Click **Fetch All** to fetch models and voices.
5. Enable the provider.
6. Click **Health Check**.

For details, see [Configure Providers](/workflow/providers).

## 4. Create a Voice Bank and Character

Open **Voice Bank**. Voice banks group characters, and later workflows select voices from the chosen bank.

<img className="screenshot" src="/img/screenshot_overview.png" alt="Voice Bank page" />

For first use, select **Default Bank**, then select **Default Voice** and check the provider, model, and voice binding on the right.

## 5. Run the First Quick Test

After selecting a character in **Voice Bank**, the **Quick Test** panel appears on the right.

<img className="screenshot" src="/img/screenshot_quick_tts.png" alt="Quick TTS page" />

1. Type one short test sentence.
2. Click the purple generate button.
3. If the provider is configured correctly, audio enters the shared TTS queue and plays automatically.
4. Generated audio is stored in the voice asset directory and can later be managed by storage scans.

## 6. Next Steps

- Multi-character scripts: [Dialogue TTS](/workflow/dialog-tts)
- Long text / audiobooks: [Phase TTS](/workflow/phase-tts)
- TXT novel reading: [Novel Reader](/workflow/novel-reader)
- Subtitle dubbing: [Video Dubbing](/workflow/video-dub)
- OpenAI-compatible API for external tools: [API Server](/operations/api-server)
