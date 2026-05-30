---
title: Neiroha GPT-SoVITS
sidebar_label: GPT-SoVITS
---

This page covers the Neiroha GPT-SoVITS local backend. Extract the portable Release package, or place the source repository anywhere; `<backend-root>` refers to that directory.

It provides FastAPI, Gradio Admin, TOML model presets, TOML voice sets, an OpenAI-compatible TTS API, and native `/api/gpt-sovits` routes. Startup is configuration-driven through `configs/server.toml`.

<div className="screenshot-grid">
  <figure>
    <img src="/img/admin_gpt_sovits.png" alt="Neiroha GPT-SoVITS Admin home" />
    <figcaption>The backend Admin shows API state, loads presets, manages voices, downloads assets, and displays logs.</figcaption>
  </figure>
</div>

## Capability Summary

| Dimension | Current Notes |
|---|---|
| Recommended preset | Default model preset is `v2proplus-clone`, using GPT-SoVITS v2ProPlus SoVITS weights. |
| Languages | Official cross-lingual inference range: Chinese, English, Japanese, Korean, Cantonese. Neiroha uses `zh` / `en` / `ja` / `ko` / `yue`. |
| Cross-language output | Supported when target language stays within the supported range. |
| Dialects | Officially explicit dialect support is Cantonese. Other Mandarin regional dialects are better handled by separate training or CosyVoice3 / VoxCPM2. |
| Clone prompt text | Required. Clone needs reference audio, matching reference text, prompt language, and text language. |
| Reference audio | Official zero-shot examples use around 5 seconds. The local backend recommends clean 3 to 10 second clips. |
| Official speed reference | Official README reports v2ProPlus RTF around `0.028` on RTX 4060Ti, `0.014` on RTX 4090, and `0.526` on M4 CPU. |
| Boundaries | Split long text. Reference text/audio mismatch increases missing words, repetition, and articulation risk. |

## Default Addresses

| Service | Default Address | Purpose |
|---|---|---|
| FastAPI | `http://127.0.0.1:9880` | Neiroha provider connects here. |
| Admin | `http://127.0.0.1:7860` | Manage presets, voices, downloads, and logs. |

If a port is occupied, the launcher chooses a free random port and writes it to the terminal and `runtime/logs/backend.log`.

## Install

Recommended portable package flow. The current package is built for NVIDIA GPU / CUDA environments and mainly targets RTX 30 / 40 / 50 series users:

1. Open [Neiroha-GPT-SoVITS V1.0.0 Release](https://github.com/Neiroha/Neiroha-GPT-SoVITS/releases/tag/V1.0.0).
2. Download all `V1.0.0` split archives: `Neiroha-GPT-SoVITS-Portable.7z.001`, `.002`, `.003`.
3. If GitHub downloads are unstable, use the [Baidu Netdisk mirror](https://pan.baidu.com/s/1TFbb4mlrANKJlz0-wuWY8g?pwd=neir) from the Release body.
4. Put all three files in the same directory and extract from `.001` with 7-Zip.
5. Run `start_portable.bat serve`.

Source or development environment:

```powershell
pixi install
pixi run install
pixi run install-sample-voice
```

These commands initialize the GPT-SoVITS submodule, install upstream dependencies, download base pretrained assets, and install one sample voice. Existing `.ckpt` / `.pth` weights can be registered in Admin Model Presets and clone configuration.

## Start

Portable Release:

```powershell
.\start_portable.bat serve
```

Source environment:

```powershell
pixi run serve
```

Common Pixi tasks:

| Command | Purpose |
|---|---|
| `pixi run serve` | Start according to `configs/server.toml [startup].surface`, default API + Admin |
| `pixi run api` | Start FastAPI only |
| `pixi run admin` | Start Gradio Admin only and connect to an existing FastAPI |
| `pixi run smoke` | Check `/health`, `/v1/models`, `/v1/audio/voices` |
| `pixi run test` | Run backend tests |
| `pixi run launcher-help` | Show launcher arguments |

`admin` mode starts Gradio Admin only. To run API and Admin together, keep `[startup].surface = "both"` and run `pixi run serve`.

## Connect Neiroha

1. Open **Providers**.
2. Create a provider, adapter type **GPT-SoVITS**.
3. Set `Base URL` to `http://127.0.0.1:9880`, or the actual address printed in logs.
4. Leave `API Key` empty if local auth is disabled.
5. Click **Fetch All**.
6. Confirm `default` voice set and `genshin-keqing` voice are visible.
7. Enable the provider and click **Health Check**.

Android emulator host URL:

```text
http://10.0.2.2:9880
```

## Character Setup

| Goal | Setting |
|---|---|
| Default sample voice | Preset / trained voice mode, voice `genshin-keqing` |
| Custom trained weights | Add `.ckpt` / `.pth` in Admin Model Presets, then create a voice |
| Reference-audio clone | Provide reference audio, reference text, reference language, and target text language |
| Multiple voice sets | Create a voice set and expose desired voices to Neiroha |

v2ProPlus clone is sensitive to reference length. Use clean 3 to 10 second clips without background music.

## Native API Prefix

Stable OpenAI-compatible routes:

| Method | Path | Purpose |
|---|---|---|
| `GET` | `/health` | Health check |
| `GET` | `/v1/models` | List voice sets |
| `GET` | `/v1/audio/voices` | List voice profiles |
| `POST` | `/v1/audio/speech` | Synthesize with registered voice |

Native prefix is `/api/gpt-sovits`. Legacy `/gpt-sovits/*` and `/tts` remain for compatibility, but new integrations should prefer the standard prefix.

## Logs and Output

- Output audio: `runtime/outputs/`
- Current log: `runtime/logs/backend.log`
- Previous log: `runtime/logs/backend.previous.log`
- Download logs: `runtime/logs/admin-download.out.log` and `runtime/logs/admin-download.err.log`

## Sources

- [RVC-Boss/GPT-SoVITS README](https://github.com/RVC-Boss/GPT-SoVITS/blob/main/README.md)
- [GPT-SoVITS v2Pro / v2ProPlus pretrained model notes](https://huggingface.co/lj1995/GPT-SoVITS/tree/main)
