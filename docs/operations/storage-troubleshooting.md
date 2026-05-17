---
title: 数据存储与故障排除
sidebar_label: 存储 / 故障排除
---

## 数据库

所有设置、角色、语音库及历史记录存储在 SQLite 数据库中：

```text
%APPDATA%\com.neiroha.neiroha\neiroha.db
```

## 语音资产目录

默认生成文件存储在：

```text
%APPDATA%\com.neiroha.neiroha\voice_asset\quick_tts\
%APPDATA%\com.neiroha.neiroha\voice_asset\phase_tts\
%APPDATA%\com.neiroha.neiroha\voice_asset\dialog_tts\
%APPDATA%\com.neiroha.neiroha\voice_asset\novel_reader\
%APPDATA%\com.neiroha.neiroha\voice_asset\video_dub\
%APPDATA%\com.neiroha.neiroha\voice_asset\voice_character_ref\
```

语音资产根目录可以在 **设置 → Storage** 中修改。

## 常见问题

| 现象 | 解决方案 |
|---|---|
| 健康检查失败 | 确认 Base URL 可访问，API Key 正确，服务端路径和模型列表可用 |
| 快速 TTS 无音色显示 | 激活一个包含至少一个已启用角色的语音库 |
| 音频可播放但显示 `--:--` 时长 | 首次播放时属正常现象，时长会在第一次播放后更新 |
| 小说阅读并发看起来没生效 | 提高小说阅读器预取数量，并检查 RPM/TPM 限流 |
| API 服务器在其他机器上访问不到 | 默认绑定 `127.0.0.1`；局域网访问需改成 `0.0.0.0` 并配置 API Key |
| Android 上看不到本地 FFmpeg 导出功能 | 当前平台能力边界设计如此，本地媒体处理在 Android 禁用 |
