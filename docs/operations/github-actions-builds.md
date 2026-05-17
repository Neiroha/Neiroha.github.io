---
title: GitHub Actions 构建
sidebar_label: GitHub Actions 构建
---

Neiroha 主程序仓库已经配置了原生平台 CI，不再只依赖本地机器产物。

## 工作流

| Workflow | 触发方式 | 输出 |
|---|---|---|
| `native-tests.yml` | Pull request、手动触发 | Flutter / Dart 测试与基础校验 |
| `native-debug-builds.yml` | Pull request、手动触发 | Android debug APK、Linux debug bundle、Windows debug bundle |
| `native-release-builds.yml` | `v*.*` tag、手动输入 tag | Android release APK、Linux release tar.gz、Windows release zip、校验和与 release assets |

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

Android release APK 还会执行 provenance attestation。最终资产由 release workflow 发布到 GitHub Release。

## Wiki 截图更新

本 wiki 仓库提供一个本地辅助脚本，用于从已启动的 Android 模拟器更新截图：

```powershell
.\scripts\update-android-screenshots.ps1
```

默认假设：

- Android SDK 在 `D:\Programs\Android_SDK`
- 模拟器 serial 为 `emulator-5554`
- APK 为 `D:\Web_Project\Neiroha\build\app\outputs\flutter-apk\app-debug.apk`

推荐使用 `neiroha_tablet_16x10` AVD，设备输出为 `2560x1600`。脚本会安装 debug APK、清理 app 数据、打开应用并覆盖 `static/img/screenshot_*.png`。
