---
title: IndexTTS 2.5 WebUI
sidebar_label: IndexTTS 2.5
---

Neiroha connects to a separately running IndexTTS 2.5 Gradio WebUI. On Windows, you can follow the instructions in the community-maintained `opc-run/tts-index-tts-bundle` and launch `start-webui.bat`. Neiroha connects to the service started by that bundle. [Community bundle](https://github.com/opc-run/tts-index-tts-bundle)

1. Open the WebUI in your browser and check that it can synthesize audio. The default address is `http://127.0.0.1:7860`.
2. In Neiroha Providers, choose **IndexTTS 2.5 (WebUI)**, enter the WebUI base address, then save and run Health Check.
3. In Voice Bank, assign a reference recording to your character. Leave the output language at `auto` or choose `ZH`, `EN`, `JA`, `AR` or `ES`. Each synthesis request uses the recording. Emotion descriptions are used when the WebUI starts with its experimental emotion-text mode enabled.

## Model Compatibility

| Model | Native | Neiroha Web | Streaming playback |
|---|---|---|---|
| IndexTTS 2.5 (Gradio `/gen_single`) | Reachable WebUI and a reference file | Unavailable | Plays after generation |

The adapter uploads the reference file, waits for Gradio's SSE completion event, and downloads the finished audio. If Health Check fails, test the WebUI directly and check that your deployment exposes `/gen_single` and Gradio's API info endpoint. [v0.5.0 adapter](https://github.com/Neiroha/Neiroha/blob/v0.5.0/lib/data/adapters/index_tts_adapter.dart)
