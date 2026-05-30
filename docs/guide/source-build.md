---
title: 从源码运行
sidebar_label: 开发者源码运行
---

这一页面面向需要修改代码、调试问题或提交 PR 的开发者。日常使用请优先选择 [安装 Release 包](/guide/install-release)，主程序仓库已经用 GitHub Actions 自动构建 Windows、Android 和 Linux Release 产物。

## 准备环境

| 工具 | 要求 |
|---|---|
| Git | 用于 clone、创建分支和提交 PR |
| Flutter | `3.41.6`，与主仓库 CI 配置一致 |
| Dart | 使用 Flutter SDK 自带版本即可 |
| Java | `17`，用于 Android 构建 |
| Windows 桌面构建 | Windows 10/11 + Visual Studio 2022，安装 Desktop development with C++ |
| Android 构建 | Android Studio 或 Android SDK command-line tools |
| Linux 桌面构建 | 需要 GTK、GStreamer、mpv、CMake、Ninja 等桌面依赖 |

安装好后先检查：

```bash
flutter doctor
```

仅开发 Windows 桌面版时，至少需要 Windows desktop toolchain 可用；如需构建 Android，还需要 Android toolchain 和 Java 17 可用。

## Fork 和 Clone

外部贡献者应先 fork 主仓库，再从个人 fork clone。避免直接在上游 `main` 或 `dev` 上提交。

1. 在 GitHub 打开 [Neiroha/Neiroha](https://github.com/Neiroha/Neiroha)。
2. 点击 **Fork**，创建到个人账号下。
3. clone 个人 fork：

```bash
git clone https://github.com/<your-name>/Neiroha.git
cd Neiroha
```

4. 添加上游仓库：

```bash
git remote add upstream https://github.com/Neiroha/Neiroha.git
git fetch upstream
```

5. 从上游 `dev` 创建功能分支：

```bash
git switch dev
git pull upstream dev
git switch -c feature/<short-name>
```

分支名建议简短明确，例如 `feature/provider-health-timeout`、`feature/novel-cache-controls`。

## 安装依赖

```bash
flutter pub get
```

项目使用代码生成。首次运行、更新 model/provider/schema 后，执行：

```bash
dart run build_runner build --delete-conflicting-outputs
```

生成文件冲突时，先确认生成文件未被手工修改；正常情况下重新运行上面的命令即可。

## 本地运行 Windows 桌面版

```bash
flutter config --enable-windows-desktop
flutter run -d windows
```

开发调试时常用完整流程：

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter analyze
flutter test
flutter run -d windows
```

Windows debug bundle 可用：

```bash
flutter build windows --debug
```

产物通常在：

```text
build/windows/x64/runner/Debug/
```

## 构建 Android Debug APK

确认 Android SDK 和 Java 17 可用后：

```bash
flutter pub get
flutter build apk --debug
```

产物路径：

```text
build/app/outputs/flutter-apk/app-debug.apk
```

如需安装到已连接设备或模拟器：

```bash
flutter install -d <device-id>
```

设备列表可用：

```bash
flutter devices
```

## 本地检查

提交前至少跑：

```bash
flutter analyze
flutter test
```

改动涉及代码生成时，再运行：

```bash
dart run build_runner build --delete-conflicting-outputs
```

改动涉及平台构建时，按影响范围补充运行：

```bash
flutter build windows --debug
flutter build apk --debug
flutter build linux --debug
```

Linux 构建依赖系统包，Windows 上不需要强行本地跑；PR 后会由 GitHub Actions 在 Linux runner 上验证。

## 提交代码

在当前 `feature/<short-name>` 分支提交：

```bash
git status
git add <changed-files>
git commit -m "feat: describe the change"
git push origin feature/<short-name>
```

提交信息保持短而具体。常见前缀：

| 前缀 | 用途 |
|---|---|
| `feat:` | 新功能 |
| `fix:` | 修复问题 |
| `docs:` | 文档 |
| `refactor:` | 重构 |
| `test:` | 测试 |
| `chore:` | 构建、依赖、维护 |

## 提 Pull Request

PR 流程：

1. 在 GitHub 从个人 fork 打开 Pull Request。
2. `base repository` 选 `Neiroha/Neiroha`。
3. `base` 选 `dev`，避免直接提交到 `main`。
4. `compare` 选个人 `feature/<short-name>` 分支。
5. PR 标题说明用户可见变化或修复点。
6. PR 描述里写清楚：
   - 改了什么。
   - 为什么要改。
   - 本地已运行哪些检查命令。
   - 是否影响 Windows、Android、Linux、数据迁移或旧项目。
7. 等 GitHub Actions 自动检查通过。
8. 根据人工 review 反馈修改，继续 push 到同一个 `feature/<short-name>` 分支。
9. 自动 workflow 通过且人工 review 通过后，维护者才会合并到 `dev`。

当前 PR 会触发：

| Workflow | 作用 |
|---|---|
| `native-tests.yml` | `flutter analyze` 和 `flutter test` |
| `native-debug-builds.yml` | Android debug APK、Linux debug bundle、Windows debug bundle |

`native-release-builds.yml` 只在发布 tag 或手动发布时运行；普通 PR 不会发布 Release。

## 同步上游 dev

分支开发时间较长时，合并前先同步上游 `dev`：

```bash
git fetch upstream
git switch dev
git pull upstream dev
git switch feature/<short-name>
git merge dev
```

解决冲突后重新运行本地检查，再 push：

```bash
flutter analyze
flutter test
git push origin feature/<short-name>
```

## GitHub Actions

主程序仓库已经支持 GitHub Actions 原生构建。Pull request 会生成 Android、Linux、Windows debug 产物；打 `v*.*` tag 或手动输入 tag 时会生成 release 产物并发布到 GitHub Release。

详细说明见 [GitHub Actions 构建](/operations/github-actions-builds)。
