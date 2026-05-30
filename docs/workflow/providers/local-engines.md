---
title: 连接本地推理引擎
sidebar_label: 本地推理引擎
---

本地推理引擎适合有本机 GPU、局域网推理服务器，或不希望把文本发到云端的场景。Neiroha 不负责替你训练模型；它负责把 UI、队列、项目和本地 API 请求转发给已经启动好的 TTS 服务。

## 连接前检查

1. 先启动你的 TTS 后端，确认终端或日志里显示了真实监听地址。
2. 在运行 Neiroha 的机器上打开后端的 `/health`、`/v1/models` 或 voice 列表地址。
3. 如果 Neiroha 跑在 Android 模拟器里，宿主机地址用 `10.0.2.2`，不要用 `127.0.0.1`。
4. 如果 Neiroha 跑在 Android 真机里，使用电脑的局域网 IP，并放行 Windows 防火墙。
5. 回到 Neiroha 的 **Providers**，新增或编辑 Provider。

## 常用适配器

| 后端类型 | Neiroha 适配器 | Base URL 示例 | 角色配置重点 |
|---|---|---|---|
| OpenAI 兼容 TTS | OpenAI TTS API Compatible | `http://127.0.0.1:8880/v1` | 选模型和 preset voice |
| GPT-SoVITS | GPT-SoVITS | `http://127.0.0.1:9880` | 已训练 voice 或参考音频 clone |
| CosyVoice3 | CosyVoice Native | `http://127.0.0.1:9880` | prompt clone、cross-lingual、instruct |
| VoxCPM2 | VoxCPM2 Native | `http://127.0.0.1:8000` | registered voice、voice design、clone |
| Windows 系统声音 | Windows System TTS | 留空 | Windows 桌面端直接枚举 SAPI voice |

CosyVoice3 和 GPT-SoVITS 当前都默认使用 `9880`。如果同时启动两个后端，请改其中一个 `configs/server.toml` 的 `[api].port`，或使用 launcher 自动选择的随机端口，并把日志里的实际地址填到 Neiroha。

本地后端完整教程：

- [Neiroha GPT-SoVITS](/workflow/providers/gpt-sovits)
- [Neiroha VoxCPM2](/workflow/providers/voxcpm)
- [Neiroha CosyVoice3](/workflow/providers/cosyvoice)

## Windows 便携后端包

本地后端可以直接下载便携 Release，不需要先装完整开发环境。分卷包必须全部下载到同一个目录，再用 7-Zip 从 `.001` 解压。

| 后端 | Release | 当前资产命名 |
|---|---|---|
| GPT-SoVITS | [Neiroha-GPT-SoVITS Releases](https://github.com/Neiroha/Neiroha-GPT-SoVITS/releases) | `Neiroha-GPT-SoVITS-Portable.7z.001` 到 `.003` |
| VoxCPM2 | [Neiroha-VoxCPM Releases](https://github.com/Neiroha/Neiroha-VoxCPM/releases) | `Neiroha-VoxCPM-portable.7z.001` 到 `.004` |
| CosyVoice3 | [Neiroha-Cosyvoice Releases](https://github.com/Neiroha/Neiroha-Cosyvoice/releases) | `neiroha-cosyvoice3-portable.7z.001` 到 `.006`，以 Release 页面实际资产为准 |

便携包启动后仍然在解压目录下使用 `runtime/` 存放日志、输出、临时文件和 voice registry。不要只移动其中一个分卷，也不要把分卷解压到系统临时目录后直接长期使用。

## OpenAI 兼容服务

OpenAI 兼容是最容易接的本地协议，适合 Kokoro、XTTS、Orpheus、KoboldCpp 或你自己包的一层 `/v1/audio/speech` 服务。

1. Provider 适配器选 **OpenAI TTS API Compatible**。
2. `Base URL` 填到 API 版本层，例如 `http://127.0.0.1:8880/v1`。
3. 本地服务没有鉴权时，`API Key` 可以留空。
4. 点 **Fetch All**。Neiroha 会尝试 `models`、`audio/voices`、`speakers` 等常见列表接口。
5. 如果 voice 列表为空，在创建角色时手动填后端支持的 voice 名称。
6. Health Check 通过后，创建一个 preset voice 角色并做 Quick Test。

## GPT-SoVITS

GPT-SoVITS 适合已经有训练好的说话人 voice，或需要参考音频克隆的工作流。

1. 启动后端：便携包运行 `start_portable.bat serve`，源码环境运行 `pixi run serve`。
2. Provider 适配器选 **GPT-SoVITS**。
3. `Base URL` 填服务根地址，默认是 `http://127.0.0.1:9880`。
4. 点 **Fetch All**。新后端会提供 `/v1/models`、`/v1/audio/voices` 和 `/api/gpt-sovits/voices`。
5. 创建角色时选择：
   - 已注册 voice：选服务端已有 voice，例如 `genshin-keqing`。
   - clone：上传参考音频，并填写参考文本、参考语言和目标文本语言。
6. Quick Test 成功后再用于 Dialog / Phase 批量生成。

## CosyVoice Native

CosyVoice Native 使用 Neiroha 的原生 JSON / multipart 适配，不要求后端伪装成纯 OpenAI 服务。

1. 启动后端：便携包运行 `start_portable.bat`，源码环境运行 `pixi run serve`。
2. Provider 适配器选 **CosyVoice Native**。
3. `Base URL` 填服务根地址，默认是 `http://127.0.0.1:9880`。
4. Health Check 会访问 `/health`。
5. **Fetch All** 会读取 `/v1/models`、`/v1/audio/voices` 和 `/api/cosyvoice/voices`。
6. 创建角色时按模式补齐字段：`prompt_clone` 需要参考音频和 prompt text；`cross_lingual` 只需要参考音频；`instruct` 需要参考音频和 instruction。

## VoxCPM2 Native

VoxCPM2 Native 支持 registered voice、自然语言声音设计和参考音频克隆。

1. 启动后端：便携包运行 `start_portable.bat`，源码环境运行 `pixi run serve`。
2. Provider 适配器选 **VoxCPM2 Native**。
3. `Base URL` 填 `http://127.0.0.1:8000` 或你的实际服务地址。
4. **Fetch All** 会读取 `/v1/models`、`/v1/audio/voices` 和 `/api/voxcpm/voices`。
5. 创建角色时按需求选择 registered voice、design、clone 或 ultimate clone。
6. `clone` 需要参考音频但不需要参考文本；`ultimate_clone` 需要参考音频和对应文本。

## Android 连接本机后端

| Neiroha 运行位置 | 后端运行位置 | Base URL 应该写 |
|---|---|---|
| Windows 桌面 Neiroha | 同一台 Windows | `http://127.0.0.1:端口` |
| Android 模拟器 | 宿主 Windows | `http://10.0.2.2:端口` |
| Android 真机 | 局域网电脑 | `http://电脑局域网 IP:端口` |
| Android 真机 | 公网服务器 | `https://你的域名` 或公网 IP |

如果真机访问失败，先在手机浏览器打开同一个地址。浏览器也打不开时，问题通常在防火墙、端口监听地址、代理或局域网隔离。

## 常见失败

| 现象 | 常见原因 | 处理 |
|---|---|---|
| Health Check 失败 | URL 层级错了，或端口没开 | OpenAI 兼容通常带 `/v1`，原生适配器通常填服务根地址 |
| 模拟器连不上本机 | 写了 `127.0.0.1` | 改成 `10.0.2.2` |
| 真机连不上电脑 | 防火墙拦截或后端只监听 localhost | 后端改监听 `0.0.0.0`，并放行端口 |
| Fetch All 为空 | 后端没有列表接口，或端口填到了错误服务 | 打开 `/v1/models` 和 voice 列表检查，再手动填模型和 voice |
| 批量生成卡住 | 本地显存或并发过高 | Provider 最大并发先设为 `1` |
