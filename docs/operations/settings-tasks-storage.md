---
title: 设置、任务和存储
sidebar_label: 设置 / 任务 / 存储
---

**设置（Settings）** 页面拆分为几个面向运维的区域。

## General

- 配置启动页面。
- 控制切换 screen 时是否继续 TTS。
- 对小说阅读器等长时间播放任务尤其重要。

## Tasks

Tasks 展示全进程共享 TTS 调度器状态。Quick TTS、Dialog TTS、Phase TTS、Novel Reader、Video Dub 和本地 API Server 都进入同一个队列。

当前可查看：

- 正在运行的任务。
- 排队任务。
- 最近完成或失败的任务。
- Provider 限流和并发影响。

开发计划中的 Task System V2 会把当前内存队列升级为持久任务系统，并增加 cancel、retry、history 和 job API。

## API Server

配置本地 HTTP 服务：

- 绑定地址。
- 端口。
- API Key。
- CORS origins。
- 按 IP 限流。
- 最大请求体大小。
- API 日志输出。

## Storage

Storage 管理语音资产根目录、缺失文件扫描和音频归档清理。Neiroha 会为项目和角色保留稳定的文件夹 slug，因此重命名显示名称不会移动已有音频。

## Media Tools

Media Tools 管理 FFmpeg 检测和音频 / 视频导出默认设置。Windows、Linux 和 macOS 可以使用外部 FFmpeg CLI；Android 禁用本地 FFmpeg 媒体处理。
