---
id: intro
slug: /
title: Neiroha Wiki
sidebar_label: Overview
sidebar_position: 1
description: Product guide, workflows, operations notes, and API reference for Neiroha.
---

<div className="wiki-hero">
  <img className="wiki-hero__logo" src="/img/neiroha_logo.png" alt="Neiroha Logo" />

  <div>
    <h1>Neiroha</h1>
    <p><strong>AI audio middleware and dubbing workstation</strong></p>
    <p>
      Neiroha is a cross-platform Flutter workstation for local and cloud TTS backends.
      It brings voice characters, voice banks, long-form reading, dialogue dubbing, video dubbing,
      and an OpenAI-compatible HTTP API into one workflow.
    </p>
  </div>

  <img className="wiki-hero__screenshot" src="/img/screenshot_overview.png" alt="Neiroha overview" />
</div>

## Documentation Entry Points

<div className="wiki-grid">
  <a className="wiki-card" href="/en/guide/getting-started">
    <strong>Quick Start</strong>
    <p>Download a GitHub Release build, then configure your first local or cloud TTS backend.</p>
  </a>
  <a className="wiki-card" href="/en/workflow/providers">
    <strong>Core Workflows</strong>
    <p>Providers, voice characters, voice banks, quick synthesis, dialogue TTS, phase TTS, novel reading, and video dubbing.</p>
  </a>
  <a className="wiki-card" href="/en/operations/api-server">
    <strong>API Server</strong>
    <p>Local OpenAI-compatible HTTP service, authentication, CORS, rate limits, and request examples.</p>
  </a>
  <a className="wiki-card" href="/en/guide/web-demo">
    <strong>Web Demo</strong>
    <p>Try providers, voice banks, and Quick TTS in your browser.</p>
  </a>
</div>

See the [release history](./guide/releases.md) for new features and publication dates.

## Feature Overview

| Module | What It Does |
|---|---|
| Providers | Connects TTS backends, including OpenAI and compatible services, ElevenLabs, MiniMax, IndexTTS 2.5, Azure, GPT-SoVITS, CosyVoice, VoxCPM2, Gemini and Windows system voices. |
| Voice Characters | Bind a provider, model, voice, speed, mode, and optional reference audio into a reusable character. |
| Voice Banks | Group multiple characters and expose them to projects and the API model list. |
| Quick TTS | Preview a single character. The native client archives complete clips. Web keeps clips in the current tab. |
| Dialogue TTS | Multi-character dialogue projects with chat-style lines and per-line audio. |
| Phase TTS | Long-form script splitting, per-segment character assignment, and batch synthesis. |
| Novel Reader | Import TXT files or folders, synthesize missing audio on demand, cache output, prefetch, and keep reading across screens. |
| Video Dubbing | Import video, audio, and subtitles, synthesize speech per cue, and export audio or dubbed video on desktop platforms. |
| Settings / Tasks | Inspect shared TTS queue state, provider limits, API logs, storage, and media tool configuration. |
| Local API | Expose an OpenAI-compatible TTS endpoint for scripts, games, DAWs, and other tools. |

## Platform Scope

| v0.5.0 | Windows, macOS, Linux | Android | Web |
|---|---|---|---|
| Get the app | [Desktop build](./guide/install-release.md) | [APK](./guide/install-release.md) | [Demo](./guide/web-demo.mdx) or the Release ZIP |
| Providers, voices and Quick TTS | Supported | Supported | Requires a [compatible HTTP provider](./workflow/providers.md) |
| Novel, dialogue, phase and automatic roles | Supported | Supported | Unavailable |
| Local and LAN inference services | Connect to a reachable service | Connect to a LAN service | Browser access and CORS required |
| System voices | Windows SAPI | Unavailable | Unavailable |
| FFmpeg and video export | Requires local FFmpeg | Unavailable | Unavailable |
