---
title: 小说阅读器
sidebar_label: 小说阅读器
---

小说阅读器用于长篇 TXT 阅读和缓存式 TTS 播放。

## 使用流程

1. 从 TXT 文件或文件夹创建小说项目。
2. 从项目绑定的语音库中选择旁白音色和对话音色。
3. 配置切片、跳过纯标点片段、预取数量、自动翻页和章节自动推进。
4. 点击播放。

播放时，阅读器会生成缺失音频、写入磁盘缓存，并通过共享 TTS 队列预取后续片段。

## 连续播放

如果希望切到设置或任务页时小说继续朗读，保持：

```text
设置 → General → Keep TTS Running Across Screens
```

## 并发说明

Provider 并发数会作用在小说阅读器的生成任务上，但实际并发还取决于阅读器预取数量。要跑满 Provider 并发，请让预取数量不低于 Provider 并发数，并确认 RPM/TPM 等限流没有触发。

## 缓存路径

默认输出目录：

```text
%APPDATA%\com.neiroha.neiroha\voice_asset\novel_reader\
```
