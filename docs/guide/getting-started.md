---
title: 快速开始
sidebar_label: 快速开始
---

## 环境要求

- Flutter SDK 3.11 或更新版本
- Windows 10/11，当前主要支持平台
- 至少一个可访问的 TTS 后端，可以是云端、本机或局域网服务

## 从源码运行

在 Neiroha 源码仓库中执行：

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run -d windows
```

## CI 构建产物

主程序仓库已经支持 GitHub Actions 原生构建。Pull request 和手动触发会生成 Android、Linux、Windows debug 产物；打 `v*.*` tag 或手动输入 tag 时会生成 release 产物并发布到 GitHub Release。

详细说明见 [GitHub Actions 构建](/operations/github-actions-builds)。

## 第一次配置路径

1. 打开 **提供商（Providers）**，新增一个 TTS 后端。
2. 填写 Base URL、API Key 和默认模型名。
3. 点击 **Fetch** 或 **Fetch All** 拉取模型和音色。
4. 保存并启用提供商，然后执行健康检查。
5. 打开 **语音库（Voice Bank）**，创建语音库和语音角色。
6. 在角色检查器顶部使用快速 TTS 面板进行第一次合成。

## 默认本地服务

Neiroha 的本地 API Server 默认监听：

```text
127.0.0.1:8976
```

默认绑定回环地址，只允许本机访问。只有在明确需要局域网调用时，才把绑定地址改为 `0.0.0.0`，并配置 API Key。

## 常用源码目录

| 路径 | 用途 |
|---|---|
| `lib/server/api_server.dart` | 本地 OpenAI 兼容 API 服务器 |
| `lib/data/adapters/` | 上游 TTS Provider 适配器 |
| `lib/data/services/tts_queue_service.dart` | 共享 TTS 任务队列、Provider 并发和限流 |
| `lib/presentation/screens/` | 主屏幕 |
| `lib/presentation/widgets/` | 各工作流组件 |
| `docs/` | 活跃项目文档、计划、缺陷、API 参考和研究资料 |
