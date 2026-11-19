---
id: intro
slug: /
title: Neiroha Wiki
sidebar_label: 项目总览
sidebar_position: 1
description: Neiroha 的产品说明、使用手册、配置运维和 API 参考入口。
---

<div className="wiki-hero">
  <img className="wiki-hero__logo" src="/img/neiroha_logo.png" alt="Neiroha Logo" />

  <div>
    <h1>Neiroha</h1>
    <p><strong>AI 音频中间件 & 配音工作站</strong></p>
    <p>
      Neiroha 是一款基于 Flutter 的跨平台语音工作站，连接本地或云端 TTS 后端，
      并把语音角色、语音库、长文本朗读、对话配音、视频配音和 OpenAI 兼容 HTTP API 放在同一套工作流里。
    </p>
  </div>

  <img className="wiki-hero__screenshot" src="/img/screenshot_overview.png" alt="Neiroha 总览" />
</div>

## 文档入口

<div className="wiki-grid">
  <a className="wiki-card" href="/guide/getting-started">
    <strong>快速开始</strong>
    <p>先下载 GitHub Release 发布包，再配置第一个本地或云端 TTS 后端。</p>
  </a>
  <a className="wiki-card" href="/workflow/providers">
    <strong>核心工作流</strong>
    <p>提供商、语音角色、语音库、快速合成、对话配音、段落配音、小说阅读器和视频配音。</p>
  </a>
  <a className="wiki-card" href="/operations/api-server">
    <strong>API 服务器</strong>
    <p>本地 OpenAI 兼容 HTTP 服务、鉴权、跨域、限流和请求示例。</p>
  </a>
  <a className="wiki-card" href="/guide/web-demo">
    <strong>Web 演示</strong>
    <p>在浏览器试用提供商、音色库和快速 TTS。</p>
  </a>
</div>

查看 [版本更新](./guide/releases.md)，了解各版新增功能与发布时间。

## 功能概览

| 模块 | 功能说明 |
|---|---|
| 提供商 | 连接 TTS 后端，支持 OpenAI 官方与兼容服务、ElevenLabs、MiniMax、IndexTTS 2.5、Azure、GPT-SoVITS、CosyVoice、VoxCPM2、Gemini 和 Windows 系统语音 |
| 语音角色 | 绑定提供商、音色或模型、语速、任务模式和可选参考音频 |
| 语音库 | 将角色分组管理，并作为项目创建和 API 模型列表的默认音色池 |
| 快速合成 | 单角色试听。原生端归档完整音频，Web 保存在当前标签页 |
| 对话 TTS | 多角色对话项目，使用聊天气泡视图组织台词和音频 |
| 段落 TTS | 长篇脚本拆分、逐段分配角色并批量合成 |
| 小说阅读器 | 导入 TXT 或文件夹，使用缓存 TTS、预取、自动翻页和持续播放朗读长篇文本 |
| 视频配音 | 导入视频、音频和字幕，为字幕 cue 生成 TTS 并导出音频或配音视频 |
| 设置 / 任务 | 查看共享 TTS 队列、提供商限流、API 日志、存储和媒体工具配置 |
| 本地 API | 暴露 OpenAI 兼容 TTS 接口，方便脚本、游戏、DAW 或其他工具接入 |

## 平台范围

| v0.5.0 | Windows、macOS、Linux | Android | Web |
|---|---|---|---|
| 获取应用 | [桌面安装包](./guide/install-release.md) | [APK](./guide/install-release.md) | [在线演示](./guide/web-demo.mdx)和 Release ZIP |
| 配置提供商、音色和快速试听 | 支持 | 支持 | 支持，需 [兼容的 HTTP 提供商](./workflow/providers.md) |
| 小说、对话、段落和自动分角色 | 支持 | 支持 | 不可用 |
| 本机或局域网推理服务 | 连接可达的服务 | 可连接局域网服务 | 要求浏览器可访问、允许跨域 |
| 系统音色 | Windows SAPI | 不可用 | 不可用 |
| FFmpeg 与视频导出 | 需本机安装 FFmpeg | 不可用 | 不可用 |
