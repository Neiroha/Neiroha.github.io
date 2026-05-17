---
title: 从源码运行
sidebar_label: 开发者源码运行
---

这一页面面向开发者。普通用户请优先使用 [安装 Release 包](/guide/install-release)，因为主程序仓库已经用 GitHub Actions 自动构建 Windows、Android 和 Linux Release 产物。

## 环境要求

- Flutter SDK 3.41.6 或与主仓库 CI 配置一致的版本。
- Windows 10/11、Linux x64 或 Android SDK。
- Java 17，用于 Android 构建。

## 本地运行 Windows 桌面版

在 Neiroha 主程序仓库中执行：

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run -d windows
```

## 构建 Android Debug APK

```bash
flutter pub get
flutter build apk --debug
```

产物路径：

```text
build/app/outputs/flutter-apk/app-debug.apk
```

## GitHub Actions

主程序仓库已经支持 GitHub Actions 原生构建。Pull request 和手动触发会生成 Android、Linux、Windows debug 产物；打 `v*.*` tag 或手动输入 tag 时会生成 release 产物并发布到 GitHub Release。

详细说明见 [GitHub Actions 构建](/operations/github-actions-builds)。

## 常用源码目录

| 路径 | 用途 |
|---|---|
| `lib/server/api_server.dart` | 本地 OpenAI 兼容 API 服务器 |
| `lib/data/adapters/` | 上游 TTS Provider 适配器 |
| `lib/data/services/tts_queue_service.dart` | 共享 TTS 任务队列、Provider 并发和限流 |
| `lib/presentation/screens/` | 主屏幕 |
| `lib/presentation/widgets/` | 各工作流组件 |
| `docs/` | 活跃项目文档、计划、缺陷、API 参考和研究资料 |
