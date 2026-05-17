---
title: 快速 TTS
sidebar_label: 快速 TTS
---

快速 TTS 用于单角色试听和小段音频生成。它位于 **语音库（Voice Bank）** 的角色检查器中。

## 使用步骤

1. 选择一个语音库。
2. 选择一个已配置 Provider 的角色。
3. 在快速测试输入框中输入文本。
4. 点击生成按钮。
5. 生成的音频会通过共享队列合成、保存到磁盘并自动播放。

<img className="screenshot" src="/img/screenshot_quick_tts.png" alt="快速 TTS 页面" />

## 输出归档

快速 TTS 的结果会进入 Quick TTS 归档，方便之后复用、清理和存储扫描。默认语音资产根目录在：

```text
%APPDATA%\com.neiroha.neiroha\voice_asset\quick_tts\
```

语音资产根目录可以在 **设置 → Storage** 中调整。
