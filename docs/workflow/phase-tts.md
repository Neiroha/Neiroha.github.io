---
title: 段落 TTS
sidebar_label: 段落 TTS
---

段落 TTS 面向长篇叙事、有声书和需要逐段处理的脚本。

## 基础流程

1. 创建项目。
2. 将完整脚本粘贴到文本框中。
3. 使用 **拆分** 将脚本按空行或句子边界切成段落。
4. 审阅并编辑每个段落。
5. 为段落分配角色。
6. 点击 **全部生成** 批量合成。
7. 从状态栏显示的输出目录导出或复制音频。

## 角色分配方向

计划中的 LLM Role Assignment 会把长文本变成带说话人信息的 Phase TTS 片段：

- 从当前脚本运行角色识别。
- 展示片段文本、分类、说话人标签、置信度和建议音色。
- 在应用前允许用户覆盖说话人到语音角色的映射。
- 将映射写回 segment voice assignment。

相关研究资料：

- [MiMo LLM / ASR architecture](/research/mimo-llm-asr-architecture)
- [LLM TTS adapter guide](/research/llm-tts-adapter-guide)

## 导出计划

开发队列中还包含：

- 按段落导出文件夹。
- 导出 manifest，记录段落顺序、说话人、角色和文件路径。
