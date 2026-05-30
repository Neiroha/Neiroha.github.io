---
title: Connect Local Inference Backends
sidebar_label: Local Inference Backends
---

Local inference backends are useful for local GPUs, LAN inference servers, or workflows that keep text local. Neiroha does not train models; it forwards UI, queue, project, and local API requests to already running TTS services.

## Pre-Connection Checklist

1. Start the TTS backend and confirm the real listening address in the terminal or logs.
2. On the machine running Neiroha, open the backend `/health`, `/v1/models`, or voice list URL.
3. If Neiroha runs in an Android emulator, use `10.0.2.2` for the host machine, not `127.0.0.1`.
4. If Neiroha runs on an Android phone, use the computer's LAN IP and allow the port through Windows Firewall.
5. Return to **Providers** in Neiroha and add or edit a provider.

## Common Adapters

| Backend Type | Neiroha Adapter | Base URL Example | Character Setup |
|---|---|---|---|
| OpenAI-compatible TTS | OpenAI TTS API Compatible | `http://127.0.0.1:8880/v1` | Model and preset voice |
| GPT-SoVITS | GPT-SoVITS | `http://127.0.0.1:9880` | Trained voice or reference-audio clone |
| CosyVoice3 | CosyVoice Native | `http://127.0.0.1:9880` | Prompt clone, cross-lingual clone, instruct |
| VoxCPM2 | VoxCPM2 Native | `http://127.0.0.1:8000` | Registered voice, voice design, clone |
| Windows system voice | Windows System TTS | Empty | Enumerates local Windows SAPI voices |

CosyVoice3 and GPT-SoVITS both default to port `9880`. When running both, change one backend's `[api].port` in `configs/server.toml`, or use the random port chosen by the launcher and copy the logged address into Neiroha.

Backend guides:

- [Neiroha GPT-SoVITS](/workflow/providers/gpt-sovits)
- [Neiroha VoxCPM2](/workflow/providers/voxcpm)
- [Neiroha CosyVoice3](/workflow/providers/cosyvoice)

## Windows Portable Backend Packages

Local backends can be downloaded as portable Releases without a full development environment. Download all split archive parts into the same directory, then extract from `.001` with 7-Zip.

| Backend | Release Page | Current Asset Pattern |
|---|---|---|
| GPT-SoVITS | [Neiroha-GPT-SoVITS Releases](https://github.com/Neiroha/Neiroha-GPT-SoVITS/releases) | `Neiroha-GPT-SoVITS-Portable.7z.001` through `.003` |
| VoxCPM2 | [Neiroha-VoxCPM Releases](https://github.com/Neiroha/Neiroha-VoxCPM/releases) | `Neiroha-VoxCPM-portable.7z.001` through `.004` |
| CosyVoice3 | [Neiroha-Cosyvoice Releases](https://github.com/Neiroha/Neiroha-Cosyvoice/releases) | `neiroha-cosyvoice3-portable.7z.001` through `.006`; use the actual Release assets as source of truth |

Portable packages use `runtime/` under the extracted directory for logs, outputs, temporary files, and voice registry. Do not move only one split part, and avoid long-term use from a system temporary directory.

## Source Environments and Multiple Backends

Neiroha local backend projects use [Pixi](https://pixi.sh/) to manage Python, Conda, PyPI dependencies, and common launch commands. When running multiple inference backends long-term on one machine, building each backend from source and downloading only the required model assets is usually easier to upgrade, debug, and keep under disk control than keeping several full portable packages.

Pixi's underlying ecosystem reuses rattler/Conda package cache and uv/PyPI cache, and can reuse files through hard links when available. Repeated dependencies across backends usually do not take a full duplicate copy. Model weights, sample voices, and runtime outputs are not automatically shared across projects; organize them by backend and model version.

## OpenAI-Compatible Services

OpenAI-compatible TTS is the lowest-friction local protocol for Kokoro, XTTS, Orpheus, KoboldCpp, or a custom `/v1/audio/speech` wrapper.

1. Select **OpenAI TTS API Compatible**.
2. Set `Base URL` to the API version layer, for example `http://127.0.0.1:8880/v1`.
3. Leave `API Key` empty if the local service has no authentication.
4. Click **Fetch All**. Neiroha tries common list endpoints such as `models`, `audio/voices`, and `speakers`.
5. If the voice list is empty, manually fill the backend-supported voice name when creating a character.
6. After Health Check passes, create a preset voice character and run Quick Test.

## GPT-SoVITS

GPT-SoVITS is useful for trained speaker voices and reference-audio cloning.

1. Start the backend: portable package uses `start_portable.bat serve`; source environment uses `pixi run serve`.
2. Select the **GPT-SoVITS** adapter.
3. Set `Base URL` to the service root, default `http://127.0.0.1:9880`.
4. Click **Fetch All**. The backend provides `/v1/models`, `/v1/audio/voices`, and `/api/gpt-sovits/voices`.
5. Create characters with either:
   - Registered voice: select a server voice such as `genshin-keqing`.
   - Clone: upload reference audio and fill reference text, prompt language, and target text language.
6. Use it in Dialogue or Phase batches only after Quick Test succeeds.

## CosyVoice Native

CosyVoice Native uses Neiroha's JSON / multipart adapter and does not need the backend to pretend to be a pure OpenAI service.

1. Start the backend: portable package uses `start_portable.bat`; source environment uses `pixi run serve`.
2. Select **CosyVoice Native**.
3. Set `Base URL` to the service root, default `http://127.0.0.1:9880`.
4. Health Check calls `/health`.
5. **Fetch All** reads `/v1/models`, `/v1/audio/voices`, and `/api/cosyvoice/voices`.
6. Fill character fields by mode: `prompt_clone` needs reference audio and prompt text; `cross_lingual` only needs reference audio; `instruct` needs reference audio and instruction.

## VoxCPM2 Native

VoxCPM2 Native supports registered voices, natural-language voice design, and reference-audio cloning.

1. Start the backend: portable package uses `start_portable.bat`; source environment uses `pixi run serve`.
2. Select **VoxCPM2 Native**.
3. Set `Base URL` to `http://127.0.0.1:8000` or your actual service address.
4. **Fetch All** reads `/v1/models`, `/v1/audio/voices`, and `/api/voxcpm/voices`.
5. Create characters using registered voice, design, clone, or ultimate clone.
6. `clone` needs reference audio but not reference text; `ultimate_clone` needs reference audio and matching prompt text.

## Android Connecting to a Local Backend

| Neiroha Location | Backend Location | Base URL |
|---|---|---|
| Windows desktop Neiroha | Same Windows machine | `http://127.0.0.1:port` |
| Android emulator | Host Windows machine | `http://10.0.2.2:port` |
| Android phone | LAN computer | `http://LAN-IP:port` |
| Android phone | Public server | `https://domain` or public IP |

If a phone cannot access the service, open the same address in the phone browser first. If the browser also fails, check firewall, listening address, proxy, or LAN isolation.

## Common Failures

| Symptom | Common Cause | Fix |
|---|---|---|
| Health Check fails | Wrong URL layer or unopened port | OpenAI-compatible usually includes `/v1`; native adapters usually use service root. |
| Emulator cannot reach host | Used `127.0.0.1` | Use `10.0.2.2`. |
| Phone cannot reach computer | Firewall block or backend only listens on localhost | Bind backend to `0.0.0.0` and allow the port. |
| Fetch All is empty | Backend lacks list APIs or the port points to the wrong service | Open `/v1/models` and voice list manually, then fill model and voice if needed. |
| Batch generation stalls | Local VRAM or concurrency is too high | Start provider max concurrency at `1`. |
