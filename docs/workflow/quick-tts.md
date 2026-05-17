---
title: 快速 TTS
sidebar_label: 快速 TTS
---

快速 TTS 用于单角色试听和小段音频生成。它位于 **Voice Bank** 的角色检查器里，是每个 Provider 和角色配置完成后的第一道验证。

<img className="screenshot" src="/img/screenshot_quick_tts.png" alt="快速 TTS 页面" />

## 什么时候用 Quick TTS

| 场景 | 为什么先用它 |
|---|---|
| 新接了 Provider | 用一句话验证 URL、API Key、模型和 voice |
| 新建角色 | 确认角色绑定的 Provider 和任务模式没错 |
| 调声音设计 | 快速比较 instruction 的效果 |
| 试免费额度 | 避免 Dialog / Phase 一次消耗大量请求 |

## 使用步骤

1. 选择一个语音库。
2. 选择一个已配置 Provider 的角色。
3. 看右侧角色详情，确认 Provider、模型、voice 和任务模式正确。
4. 在快速测试输入框输入短文本。
5. 点击紫色生成按钮。
6. 生成任务会进入共享 TTS 队列。
7. 完成后音频会保存到磁盘并自动播放。

## 建议的第一句测试文本

先用短句，不要直接粘贴长段落：

```text
你好，这是一段 Neiroha 快速语音测试。
```

如果是英文 voice：

```text
Hello, this is a short Neiroha voice test.
```

如果是 Gemini 或 MiMo 声音设计，可以在角色 instruction 里写风格，正文仍保持短句。

## 输出归档

快速 TTS 的结果会进入 Quick TTS 归档，方便之后复用、清理和存储扫描。默认语音资产根目录在：

```text
%APPDATA%\com.neiroha.neiroha\voice_asset\quick_tts\
```

语音资产根目录可以在 **设置 → Storage** 中调整。

## 排错顺序

| 现象 | 先检查 |
|---|---|
| 点击后马上失败 | 角色是否绑定了已启用 Provider |
| 401 / 403 | 云端 API Key、Azure 区域、MiMo key 是否正确 |
| 404 | Base URL 是否多写或少写 `/v1` |
| 429 | Provider 限流太高，或免费层额度触顶 |
| 一直排队 | Provider 最大并发为 0，或前面任务卡住 |
| 生成了但没有声音 | 系统音量、音频文件格式、播放器权限 |

Quick TTS 通过后，再进入 [对话 TTS](/workflow/dialog-tts) 或 [段落 TTS](/workflow/phase-tts)。
