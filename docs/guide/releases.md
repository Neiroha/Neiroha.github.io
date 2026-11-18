---
title: 版本更新
sidebar_label: 版本更新
---

[最新正式版下载](https://github.com/Neiroha/Neiroha/releases/latest) · [安装指南](./install-release.md)

## v0.5.0

本节根据发布 PR 整理。正式安装包和发布时间以 GitHub Release 为准。 [查看发布 PR](https://github.com/Neiroha/Neiroha/pull/8)

- **Web 工作区**支持提供商、音色库和快速 TTS。浏览器内 SQLite 保留设置和音色，语音留在标签页内存中。OpenAI Speech 支持流式试听和取消。见 [Web 演示](./web-demo.mdx)。
- **流式合成**覆盖 Quick TTS、小说阅读器等试听入口。内置 HTTP API 可按块返回 PCM，并在客户端断开时取消请求。
- **小说分角色**支持自动规划、片段标注和复核、人工校对与锁定、章级音色和句级覆盖。模型和提示词可按工作流配置。见 [小说阅读器](../workflow/novel-reader.md)。
- **macOS**分发 Apple Silicon 和 Intel 两种 DMG，新增录音与媒体会话支持。发布包采用 ad-hoc 签名，麦克风和媒体按键仍有实机验收项。
- **SQLite 升级**按 schema 版本拆分迁移，覆盖历史数据库升级测试。桌面数据库升级到 v33 前会建立备份。

## v0.4.2 · 2026-10-14

- 配音项目可以按语音库的目标响度批量统一音量，按角色设置响度偏移，并还原原始音频。
- 段落 TTS 编辑器改进片段查看、定位和批量操作。合并音频可设置片段之间的空白。

[Release 与校验值](https://github.com/Neiroha/Neiroha/releases/tag/v0.4.2) · [提交记录](https://github.com/Neiroha/Neiroha/compare/v0.4.1...v0.4.2)

## v0.4.1 · 2026-10-11

- 可让 API 与 MCP 服务在应用启动时自动开启。
- Agent 配音技能补充参考音频和声音克隆的操作说明。

[Release](https://github.com/Neiroha/Neiroha/releases/tag/v0.4.1) · [提交记录](https://github.com/Neiroha/Neiroha/compare/v0.4.0...v0.4.1)

## v0.4.0 · 2026-10-11

- 扩充 TTS 提供商与模型选择，改进视频配音的角色选择器。
- 在内置 API 服务器增加 Agent 可用的 [MCP 接口](../operations/api-server.md)，支持音色管理、合成和配音操作。
- Android 同时提供通用 APK 和按 CPU 架构拆分的 APK。

[Release](https://github.com/Neiroha/Neiroha/releases/tag/v0.4.0) · [提交记录](https://github.com/Neiroha/Neiroha/compare/v0.3.1...v0.4.0)
