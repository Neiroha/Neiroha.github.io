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

## 排错顺序

遇到无法合成、无音色、持续排队或 API 调用失败时，按下面顺序定位：

1. 在浏览器或 curl 中直接访问后端 `/health`、`/v1/models` 或 voice 列表，确认后端服务可达。
2. 回到 **Providers**，检查 `Base URL`、`API Key`、适配器类型和端口，再执行 **Fetch All**。
3. **Health Check** 通过后，到 **Voice Bank** 创建或检查角色，确认 Provider、model、voice 和任务模式完整。
4. 用 **Quick Test** 生成一句短文本。Quick Test 未通过前，不建议进入 Dialog、Phase、Novel 或 Video 批量生成。
5. 如果任务持续排队，查看 **Settings → Tasks**，确认 Provider 最大并发不是 `0`，并检查 RPM、TPM、RPD 是否过低。
6. 如果外部 API 调用失败，先用本机 `127.0.0.1:8976` 测试；局域网访问再检查绑定地址、API Key、CORS 和防火墙。

## 常见问题

| 现象 | 解决方案 |
|---|---|
| 健康检查失败 | 确认 Base URL 可访问，API Key 正确，服务端路径和模型列表可用 |
| 快速 TTS 无音色显示 | 激活一个包含至少一个已启用角色的语音库 |
| 音频可播放但显示 `--:--` 时长 | 首次播放时属正常现象，时长会在第一次播放后更新 |
| 小说阅读并发未达到预期 | 提高小说阅读器预取数量，并检查 RPM/TPM 限流 |
| API 服务器在其他机器上无法访问 | 默认绑定 `127.0.0.1`；局域网访问需改成 `0.0.0.0` 并配置 API Key |
| Android 上看不到本地 FFmpeg 导出功能 | 这是当前平台能力边界；本地媒体处理在 Android 禁用 |
