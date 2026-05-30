---
title: Storage and Troubleshooting
sidebar_label: Storage / Troubleshooting
---

## Database

All settings, characters, voice banks, and history records are stored in SQLite:

```text
%APPDATA%\com.neiroha.neiroha\neiroha.db
```

## Voice Asset Directories

Generated files are stored by default under:

```text
%APPDATA%\com.neiroha.neiroha\voice_asset\quick_tts\
%APPDATA%\com.neiroha.neiroha\voice_asset\phase_tts\
%APPDATA%\com.neiroha.neiroha\voice_asset\dialog_tts\
%APPDATA%\com.neiroha.neiroha\voice_asset\novel_reader\
%APPDATA%\com.neiroha.neiroha\voice_asset\video_dub\
%APPDATA%\com.neiroha.neiroha\voice_asset\voice_character_ref\
```

The voice asset root can be changed in **Settings -> Storage**.

## Troubleshooting Order

For synthesis failures, missing voices, stuck queues, or API errors, debug in this order:

1. Open the backend `/health`, `/v1/models`, or voice list URL directly in a browser or curl to confirm the backend is reachable.
2. Return to **Providers**, check `Base URL`, `API Key`, adapter type, and port, then run **Fetch All**.
3. After **Health Check** passes, create or inspect the character in **Voice Bank**. Confirm provider, `model`, `voice`, and task mode.
4. Run **Quick Test** with one short sentence. Do not batch Dialogue, Phase, Novel, or Video jobs until Quick Test passes.
5. If tasks stay queued, check **Settings -> Tasks**. Confirm provider max concurrency is not `0`, and RPM, TPM, or RPD limits are not too low.
6. If the external API fails, test `127.0.0.1:8976` first. For LAN access, check bind address, API key, CORS, and firewall rules.

## Common Issues

| Symptom | Fix |
|---|---|
| Health check fails | Confirm Base URL reachability, API key, server path, and model list. |
| Quick TTS shows no voices | Activate a voice bank that contains at least one enabled character. |
| Audio plays but duration shows `--:--` | Normal on first display; duration updates after first playback. |
| Novel reader concurrency is lower than expected | Increase novel reader prefetch count and check RPM/TPM limits. |
| API server is unreachable from another machine | Default bind is `127.0.0.1`; LAN access requires `0.0.0.0` and an API key. |
| Android does not show local FFmpeg export | This is a platform boundary; local media processing is disabled on Android. |
