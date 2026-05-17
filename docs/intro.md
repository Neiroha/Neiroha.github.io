---
id: intro
slug: /
title: Neiroha Wiki
sidebar_label: 项目总览
sidebar_position: 1
description: Neiroha 的产品说明、使用手册、API 参考和开发文档入口。
---

<div className="wiki-hero">
  <img className="wiki-hero__logo" src="/img/neiroha_logo.png" alt="Neiroha Logo" />

  <div>
    <h1>Neiroha</h1>
    <p><strong>AI 音频中间件 & 配音工作站</strong></p>
    <p>
      Neiroha 是一款基于 Flutter 的 Windows 桌面应用，用一个统一前端连接本地或云端 TTS 后端，
      并把语音角色、语音库、长文本朗读、对话配音、视频配音和 OpenAI 兼容 HTTP API 放在同一套工作流里。
    </p>
  </div>

  <img className="wiki-hero__screenshot" src="/img/screenshot_overview.png" alt="Neiroha 总览" />
</div>

## 文档入口

<div className="wiki-grid">
  <a className="wiki-card" href="/guide/getting-started">
    <strong>快速开始</strong>
    <p>环境要求、源码运行命令和第一个 TTS 后端的配置路径。</p>
  </a>
  <a className="wiki-card" href="/workflow/providers">
    <strong>核心工作流</strong>
    <p>提供商、语音角色、语音库、快速 TTS、对话 TTS、段落 TTS、小说阅读器和视频配音。</p>
  </a>
  <a className="wiki-card" href="/operations/api-server">
    <strong>API 服务器</strong>
    <p>本地 OpenAI 兼容 HTTP 服务、鉴权、CORS、限流和请求示例。</p>
  </a>
  <a className="wiki-card" href="/plan">
    <strong>开发状态</strong>
    <p>当前计划、已确认风险、研究资料与历史归档。</p>
  </a>
</div>

## 功能概览

| 模块 | 功能说明 |
|---|---|
| 提供商 | 连接 TTS 后端，支持 OpenAI 兼容、Azure、GPT-SoVITS、CosyVoice、VoxCPM2、Gemini 和 Windows 系统 TTS |
| 语音角色 | 绑定提供商、音色或模型、语速、任务模式和可选参考音频 |
| 语音库 | 将角色分组管理，并作为项目创建和 API 模型列表的默认音色池 |
| 快速 TTS | 单角色试听，生成结果会进入 Quick TTS 归档 |
| 对话 TTS | 多角色对话项目，使用聊天气泡视图组织台词和音频 |
| 段落 TTS | 长篇脚本拆分、逐段分配角色并批量合成 |
| 小说阅读器 | 导入 TXT 或文件夹，使用缓存 TTS、预取、自动翻页和持续播放朗读长篇文本 |
| 视频配音 | 导入视频、音频和字幕，为字幕 cue 生成 TTS 并导出音频或配音视频 |
| 设置 / 任务 | 查看共享 TTS 队列、Provider 限流、API 日志、存储和媒体工具配置 |
| 本地 API | 暴露 OpenAI 兼容 TTS 接口，方便脚本、游戏、DAW 或其他工具接入 |

## 平台范围

Neiroha 当前把平台支持看作具体能力边界，而不是承诺所有屏幕在所有平台都有同等原生能力。

| 平台 | 当前范围 |
|---|---|
| Windows | 主要桌面目标。Windows SAPI 和外部 FFmpeg CLI 可用。 |
| Linux / macOS | 桌面形态目标。安装或配置 FFmpeg 后支持外部 CLI；平台原生系统 TTS 尚未实现。 |
| Android 手机 / 平板 | 支持 UI 和 TTS 客户端工作流。本地 FFmpeg 混流、裁剪、波形提取和视频导出禁用。 |

系统 TTS 当前只实现 Windows SAPI。Android、Apple 或 Linux 系统 TTS 需要先有原生平台适配器，才应在界面中暴露。
