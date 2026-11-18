---
title: Release History
sidebar_label: Release History
---

[Latest stable download](https://github.com/Neiroha/Neiroha/releases/latest) · [Installation guide](./install-release.md)

## v0.5.0

This section follows the release pull request. Check GitHub Releases for official downloads and publication dates. [Release pull request](https://github.com/Neiroha/Neiroha/pull/8)

- **Web workspace** with providers, voice banks and Quick TTS. Browser SQLite saves settings and voice definitions, while generated audio lives in tab memory. OpenAI Speech supports streaming playback and cancellation. See the [Web demo](./web-demo.mdx).
- **Streaming synthesis** in Quick TTS, the novel reader and other previews. The built-in HTTP API streams PCM and cancels synthesis when the client disconnects.
- **Novel role assignment** with planning, segment labeling, review, manual corrections and locks. Set voices per chapter or per line, and configure role models and prompts by workflow. See the [Novel Reader](../workflow/novel-reader.md).
- **macOS** DMGs for Apple Silicon and Intel, with recording and media session support. The DMGs use ad-hoc signing. Microphone and media-key behavior still needs validation on physical devices.
- **SQLite upgrades** now use versioned migrations with tests against historical databases. Desktop databases are backed up before upgrading to schema v33.

## v0.4.2 · 2026-10-14

- Normalize dubbing clips to a voice bank's target loudness, set per-character offsets and restore original audio.
- The Phase TTS editor improves segment navigation and batch actions. Add configurable gaps when merging clips.

[Release and checksums](https://github.com/Neiroha/Neiroha/releases/tag/v0.4.2) · [Commits](https://github.com/Neiroha/Neiroha/compare/v0.4.1...v0.4.2)

## v0.4.1 · 2026-10-11

- Optionally start the API and MCP servers when Neiroha launches.
- The dubbing skill adds guidance for reference audio and voice cloning.

[Release](https://github.com/Neiroha/Neiroha/releases/tag/v0.4.1) · [Commits](https://github.com/Neiroha/Neiroha/compare/v0.4.0...v0.4.1)

## v0.4.0 · 2026-10-11

- Expanded TTS provider and model options and improved the video dubbing voice picker.
- The built-in API server adds an [MCP endpoint](../operations/api-server.md) for agents to manage voices, synthesize speech and work with dubbing projects.
- Android builds now include a universal APK and separate APKs by CPU architecture.

[Release](https://github.com/Neiroha/Neiroha/releases/tag/v0.4.0) · [Commits](https://github.com/Neiroha/Neiroha/compare/v0.3.1...v0.4.0)
