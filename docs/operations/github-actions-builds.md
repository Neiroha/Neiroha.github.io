---
title: GitHub Actions 构建
sidebar_label: GitHub Actions 构建
---

Neiroha 主程序仓库已经配置了原生平台 CI，不再只依赖本地机器产物。

日常安装应直接从 [Neiroha Releases](https://github.com/Neiroha/Neiroha/releases) 下载构建好的包。当前最新 Release 是 [`v0.3.0`](https://github.com/Neiroha/Neiroha/releases/tag/v0.3.0)，包含 Android、Linux x64、Windows x64 三个平台资产。

## 工作流

| Workflow | 触发方式 | 输出 |
|---|---|---|
| `native-tests.yml` | Pull request、手动触发 | Flutter / Dart 测试与基础校验 |
| `native-debug-builds.yml` | Pull request、手动触发 | Android debug APK、Linux debug bundle、Windows debug bundle |
| `native-release-builds.yml` | `v*.*` tag、手动输入 tag | Android release APK、Linux release tar.gz、Windows release zip、Release 正文校验表与 release assets |

## Android Debug APK

Debug workflow 会执行：

```bash
flutter build apk --debug
```

产物会被打包成 artifact：

```text
neiroha-android-debug-apk
dist/neiroha-android-debug.apk
dist/SHA256SUMS-android-debug.txt
```

本地同路径产物通常在：

```text
build/app/outputs/flutter-apk/app-debug.apk
```

本站截图当前使用该 debug APK 安装到 2560x1600 Android 模拟器后采集。

## Release Builds

Release workflow 会在 tag 发布或手动输入 tag 时构建：

- `neiroha-<tag>-android-release.apk`
- `neiroha-<tag>-linux-x64-release.tar.gz`
- `neiroha-<tag>-windows-x64-release.zip`

SHA256 不再作为单独 txt 资产上传，而是写入 GitHub Release 正文的 **Checksums** 表。Android release APK 还会执行 provenance attestation。最终资产由 release workflow 发布到 GitHub Release。

因此，wiki 的快速开始不再要求用户从源码构建；源码运行仅保留给开发者、调试者和需要修改代码的贡献者。

## Wiki 截图更新

本 wiki 仓库提供一个本地辅助脚本，用于从已启动的 Android 模拟器更新截图：

```powershell
.\scripts\update-android-screenshots.ps1
```

默认假设：

- Android SDK 位于本机 Android SDK 目录
- 模拟器 serial 为 `emulator-5554`
- APK 为主程序仓库的 `build\app\outputs\flutter-apk\app-debug.apk`

推荐使用 `neiroha_tablet_16x10` AVD，设备输出为 `2560x1600`。脚本会安装 debug APK、清理 app 数据、打开应用并覆盖 `static/img/screenshot_*.png`。
