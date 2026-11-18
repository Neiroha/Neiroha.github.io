---
title: GitHub Actions 构建
sidebar_label: GitHub Actions 构建
---

日常使用请从 [GitHub Releases](https://github.com/Neiroha/Neiroha/releases/latest) 下载相应平台的包。各版本变化见 [版本更新](../guide/releases.md)。

## 主程序构建

| 工作流 | 触发方式 | 产物 |
|---|---|---|
| `native-tests.yml` | Push、PR、手动触发 | Flutter 静态分析与测试、Android ARM64 APK 编译 |
| `native-debug-builds.yml` | PR、手动触发 | 原生平台调试包 |
| `native-release-builds.yml` | 版本 tag、手动触发 | Windows ZIP、Linux TAR.GZ、Android 通用及分架构 APK。v0.5.0 起还有两种 macOS DMG 及 Web ZIP |
| `web-builds.yml` | 相关路径的 PR、手动触发、正式版构建调用 | v0.5.0 起生成 `neiroha-Web-<版本>.zip`，内含 Flutter Web、SQLite Wasm 与 Drift worker |

版本构建将 SHA-256 写入 Release 正文的 **Checksums** 表。调试包与 PR 产物可在对应 GitHub Actions 运行页面下载。

## Wiki 的 Web 演示

Wiki 仓库的页面构建从主程序的最新正式 Release 读取同版本 Web ZIP，验证 GitHub 提供的 SHA-256 与 ZIP 内部版本，再放到 `/demo/`。中英文 [Web 演示](../guide/web-demo.mdx) 页面使用同一份构建。草稿或预发行版不会进入公开演示。没有正式 Web 资产时，演示页会显示等待提示。

Wiki 每小时检查一次，版本与校验值有变化时才重建和发布。Wiki 主分支更新或手动运行也会重新同步。主程序配置 `WIKI_DISPATCH_TOKEN` 时，正式版资产发布完成后会立即通知 Wiki。此可选凭据只需能向 Wiki 仓库发起 `repository_dispatch`。配置细节见 [Wiki 仓库说明](https://github.com/Neiroha/Neiroha.github.io#web-演示发布)。

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
