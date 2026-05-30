---
title: Neiroha VoxCPM2
sidebar_label: VoxCPM2
---

This page covers the Neiroha VoxCPM2 local backend. Extract the portable Release package, or place the source repository anywhere; `<backend-root>` refers to that directory.

It provides OpenAI-compatible routes, native `/api/voxcpm` routes, a voice registry, Neiroha Gradio Admin, and optional official WebUI. Startup behavior is controlled by `configs/server.toml`.

<div className="screenshot-grid">
  <figure>
    <img src="/img/admin_voxcpm.png" alt="Neiroha VoxCPM Admin home" />
    <figcaption>The backend Admin loads models, manages the voice registry, runs tests, and displays logs.</figcaption>
  </figure>
</div>

## Capability Summary

| Dimension | Current Notes |
|---|---|
| Recommended version | VoxCPM2 is the current official deployment version, 2B parameters, 48 kHz output. |
| Languages | Official list includes 30 languages: Arabic, Burmese, Chinese, Danish, Dutch, English, Finnish, French, German, Greek, Hebrew, Hindi, Indonesian, Italian, Japanese, Khmer, Korean, Lao, Malay, Norwegian, Polish, Portuguese, Russian, Spanish, Swahili, Swedish, Tagalog, Thai, Turkish, Vietnamese. |
| Dialects | Official list includes 9 Chinese dialects: Sichuanese, Cantonese, Wu, Northeastern, Henan, Shaanxi, Shandong, Tianjin, Minnan. |
| Cross-language output | Supports multilingual synthesis and cross-language reference-audio cloning. |
| Text voice design | `voxcpm2-design` needs no reference audio; put age, gender, tone, emotion, and speed in natural-language text. |
| Controllable clone | `voxcpm2-clone` uses `reference_audio` and does not need prompt text. |
| Ultimate clone | `voxcpm2-ultimate-clone` needs `prompt_audio` and exact `prompt_text`; do not rely on bracket style control in this mode. |
| Official speed reference | Official PyTorch reports RTF around `0.30` on RTX 4090; Nano-vLLM / vLLM-Omni acceleration is around `0.13`. |
| Boundaries | Very short text may sound weak. Long text can speed up, produce noise, fail to stop, or OOM; split by sentence for production. |

## Default Addresses

| Service | Default Address | Purpose |
|---|---|---|
| FastAPI | `http://127.0.0.1:8000` | Neiroha provider connects here. |
| Admin | `http://127.0.0.1:7860` | Manage voices, model presets, tests, and logs. |

## Install

Recommended portable flow:

1. Open [Neiroha-VoxCPM Releases](https://github.com/Neiroha/Neiroha-VoxCPM/releases).
2. Download all `V1.0.0` split archives: `Neiroha-VoxCPM-portable.7z.001`, `.002`, `.003`, `.004`.
3. Put all four files in the same directory and extract from `.001` with 7-Zip.
4. Run `start_portable.bat`.

Source or development environment:

```powershell
pixi install
pixi run install
```

Optional ASR model for automatic prompt text transcription in ultimate clone:

```powershell
pixi run install-asr
```

ASR is disabled by default. `ultimate_clone` normally needs manual prompt text.

## Start

Portable Release:

```powershell
.\start_portable.bat
```

Source environment:

```powershell
pixi run serve
```

Common tasks:

| Command | Purpose |
|---|---|
| `pixi run serve` | Start according to `configs/server.toml [startup].surface`, default API + Admin |
| `pixi run api` | Start FastAPI only |
| `pixi run admin` | Start Neiroha Admin and connect to an existing FastAPI |
| `pixi run smoke` | Check `/health`, `/v1/models`, `/v1/audio/voices`, and capabilities |
| `pixi run test` | Run backend tests |
| `pixi run launcher-help` | Show launcher arguments |

## Connect Neiroha

1. Open **Providers**.
2. Create a provider, adapter type **VoxCPM2 Native**.
3. Set `Base URL` to `http://127.0.0.1:8000`.
4. Leave `API Key` empty if local auth is disabled.
5. Click **Fetch All**.
6. Confirm `voxcpm2-design`, `voxcpm2-clone`, and `voxcpm2-ultimate-clone`.
7. Enable the provider and click **Health Check**.

Android emulator host URL:

```text
http://10.0.2.2:8000
```

## Character Setup

| Goal | Setting |
|---|---|
| Text voice design | Select `voxcpm2-design`; write natural-language voice description at the beginning of the text. |
| Reference clone | Select `voxcpm2-clone`; provide reference audio, no prompt text required. |
| High-fidelity clone | Select `voxcpm2-ultimate-clone`; provide prompt audio and prompt text. |
| Reusable local speaker | Register a voice in Admin or `/api/voxcpm/voices`, then select it in Neiroha. |

VoxCPM2 recommends natural-language style prompts, for example:

```text
(A young woman, gentle and sweet voice)Hello, welcome to VoxCPM2.
```

Do not depend on undocumented square-bracket tokens.

## API Prefix

OpenAI-compatible routes:

| Method | Path | Purpose |
|---|---|---|
| `GET` | `/health` | Health check |
| `GET` | `/v1/models` | List voice sets |
| `GET` | `/v1/audio/voices` | List voice profiles |
| `GET` | `/v1/audio/speakers` | Speaker-list compatibility |
| `POST` | `/v1/audio/speech` | OpenAI-compatible synthesis |

Native prefix is `/api/voxcpm`. Legacy `/voxcpm/*` routes remain for compatibility; new integrations should use the standard prefix.

## Sources

- [OpenBMB/VoxCPM README](https://github.com/OpenBMB/VoxCPM)
- [VoxCPM2 model notes](https://voxcpm.readthedocs.io/en/latest/models/voxcpm2.html)
- [VoxCPM2 Usage Guide](https://voxcpm.readthedocs.io/en/latest/usage_guide.html)
