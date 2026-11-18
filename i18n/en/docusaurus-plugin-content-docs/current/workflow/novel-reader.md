---
title: Novel Reader
sidebar_label: Novel Reader
---

Novel Reader is for long TXT reading with cached TTS playback. It is meant for personal listening and iterative reading, not final audiobook mastering.

## Best Use Cases

| Scenario | Recommendation |
|---|---|
| Personal listening | Use Novel Reader with caching and prefetch enabled. |
| Formal audiobook production | Use Phase TTS for review, correction, and export control. |
| Multi-character dialogue polishing | Use Dialogue TTS or split text through Phase TTS. |

## Basic Flow

1. Create a novel project from a TXT file or folder.
2. Select narrator and dialogue voices from the project's voice bank.
3. Configure slicing, punctuation-only skip, prefetch count, automatic page turning, and automatic chapter advance.
4. Click play.

During playback, Novel Reader generates missing audio, writes cache files to disk, and prefetches upcoming segments through the shared TTS queue.

## Role Review and Streaming in v0.5.0

1. In Role Review, create characters manually or select a provider and text model for automatic analysis.
2. Review the proposed cast before continuing to batch labeling and review. Open flagged segments in the original text to correct the speaker, category, voice or style.
3. Assign voices at the book or chapter level. A line-level override takes precedence over chapter and book assignments, with project defaults used for unassigned lines.
4. Confirm or lock reviewed segments. Automatic analysis preserves the original text and confirmed assignments.

Supported voices start playback as soon as the first audio chunk arrives. Complete audio can be replayed from cache. Cancelling discards incomplete audio. See the [v0.5.0 release notes](../guide/releases.md).

## First Configuration

| Setting | Suggested Value |
|---|---|
| Max slice characters | `40` to `80`, adjusted by model stability. |
| Skip punctuation-only fragments | Enabled. |
| Prefetch count | `1` to `2` for cloud free tiers; raise gradually for local services. |
| Auto page turn | Enable when continuous listening is needed. |
| Auto chapter advance | Keep disabled during the first test, then enable after cache behavior is confirmed. |

## Continuous Playback

To keep reading while switching to settings or task pages, keep this option enabled:

```text
Settings -> General -> Keep TTS Running Across Screens
```

## Concurrency

Provider concurrency applies to Novel Reader generation tasks, but actual parallelism also depends on the reader prefetch count. To fully use local backend concurrency, set prefetch count at least as high as provider concurrency and confirm RPM / TPM limits are not being hit.

Do not raise both prefetch count and provider concurrency aggressively on cloud free tiers. The reader fills cache while it plays, and high prefetch can consume many requests quickly.

## Cache Path

Default output directory on Windows:

```text
%APPDATA%\com.neiroha.neiroha\voice_asset\novel_reader\
```

## Cache Status

| Status | Meaning |
|---|---|
| No cache | Audio must be generated when playback reaches this segment. |
| Current cache | Text and character settings are unchanged; audio can play directly. |
| Stale cache | Text, character, or settings changed; audio must be regenerated. |

If the text is sliced again, older cache files may no longer map to the new segments. For long projects, decide the slicing strategy before generating a large cache.
