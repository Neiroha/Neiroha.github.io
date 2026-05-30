---
title: Settings, Tasks, and Storage
sidebar_label: Settings / Tasks / Storage
---

The **Settings** page is split into operations-oriented sections.

## General

- Configure the startup page.
- Control whether TTS continues when switching screens.
- This matters for long-running playback workflows such as the novel reader.

## Tasks

The Tasks page shows the process-wide shared TTS scheduler. Quick TTS, Dialogue TTS, Phase TTS, Novel Reader, Video Dubbing, and the local API Server all use the same queue.

Currently visible:

- Running tasks.
- Queued tasks.
- Recently completed or failed tasks.
- Provider rate limits and concurrency effects.

Tasks are currently mainly for runtime observation. Temporary in-memory queue entries are not retained as a full job history after the app exits.

## API Server

Configure the local HTTP server:

- Bind address.
- Port.
- API key.
- CORS origins.
- Per-IP rate limit.
- Maximum request body size.
- API log output.

## Storage

Storage manages the voice asset root, missing-file scans, and audio archive cleanup. Neiroha keeps stable folder slugs for projects and characters, so renaming display names does not move existing audio files.

## Media Tools

Media Tools manages FFmpeg detection and audio/video export defaults. Windows and Linux can use external FFmpeg CLI. Android disables local FFmpeg media processing.
