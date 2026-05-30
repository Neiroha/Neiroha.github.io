---
sidebar_label: Chinese API
---

# Chinese API Reference

This route is kept so the English locale mirrors the default wiki sidebar. The Chinese-language API reference is available in the default locale at [/api-zh](/api-zh).

For English readers, use the full [English Audio API Reference](/api). It covers:

- The built-in OpenAI-compatible API server.
- Voice banks as API models.
- Provider adapter routes for OpenAI-compatible TTS, MiMo-style Chat Completions TTS, CosyVoice, GPT-SoVITS, VoxCPM2, Azure, Gemini, and Windows system TTS.
- Response headers and troubleshooting order.

If you are integrating Neiroha from an external app, start with the built-in server:

```bash
curl http://localhost:8976/v1/audio/speech \
  -H "Content-Type: application/json" \
  -d '{
    "model": "Default Bank",
    "voice": "Default Voice",
    "input": "Hello, world!",
    "response_format": "wav"
  }' \
  --output hello.wav
```

Enable an API key before exposing the server to a LAN.
