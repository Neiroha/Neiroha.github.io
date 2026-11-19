---
title: Automatic Role Assignment
sidebar_label: Automatic Roles
---

Automatic role assignment suggests speakers and narration labels alongside the source text. Review the cast and assignments before choosing voices. In v0.5.0, this feature is available in Novel Reader and Phase TTS in the native client.

## Analysis Provider and Model

Configure a connection in Providers, then select a text model with function calling in the role analysis panel. Neiroha may send a short capability check if tool support is unknown. The analysis model and the voices in your voice bank can use different providers. The text is sent to the analysis provider you select. Start with a short chapter if you want to check the results first.

Edit per-stage prompts in the role assignment profile. Novel Reader and long-form analysis share the profile. Project task connections and explicit model choices take precedence. Changing the text, model or profile requires a fresh analysis. [Workflow and evaluation notes](https://github.com/Neiroha/Neiroha/blob/v0.5.0/assets/docs/streaming-and-roles-zh.md)

## Novel Reader

1. Open a chapter and choose automatic role analysis in Role Review. Select the provider and model, then start analyzing the chapter.
2. Review the proposed cast and scene before continuing. You can add aliases, identify the narrator or people present, and replan with feedback.
3. Resume to label segments in batches, validate results and review uncertain lines. You can pause and continue. Each run allows up to 12 analysis requests, plus a capability check when needed.
4. Open flagged lines in the source and verify their category and speaker. Confirm or lock reviewed lines. You can still change voices or preview a line separately.

Line overrides take precedence over chapter and book voice assignments. Unassigned roles use project defaults. Voice casting and delivery suggestions require review before applying. Casting preserves existing bindings. Delivery suggestions apply only to unconfirmed, unlocked segments without an existing style. [Novel Reader](./novel-reader.md)

## Phase TTS

Enter the script, choose a voice bank, and open automatic role assignment. Add optional dubbing directions and analyze to preview. Review source text, nearby segments and speakers, then assign voices. Applying the preview replaces the current segments and leaves the existing audio on disk. You can fill missing voice assignments later and start synthesis separately.

Each analysis allows up to 40 model calls, with progress in the task monitor. The input limit is 360 semantic segments or 64,000 UTF-16 code units. Split longer material by chapter. Reanalyze before applying if the text, segmentation, voice bank or profile changes. [Phase TTS](./phase-tts.md)

## What to Review First

Start with flagged or conflicting lines. Nested narration, anonymous interjections, group chats and changing aliases can make attribution ambiguous. Review nearby text before batch synthesis. Analysis writes labels by segment ID and preserves source text, punctuation and whitespace.
