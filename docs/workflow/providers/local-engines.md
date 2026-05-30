---
title: 连接本地推理引擎
sidebar_label: 本地推理引擎
---

本地推理引擎适合有本机 GPU、局域网推理服务器，或需要文本留在本地的场景。Neiroha 不训练模型；它负责把 UI、队列、项目和本地 API 请求转发给已经启动的 TTS 服务。

## 连接前检查

1. 启动 TTS 后端，确认终端或日志里显示了真实监听地址。
2. 在运行 Neiroha 的机器上打开后端的 `/health`、`/v1/models` 或 voice 列表地址。
3. 如果 Neiroha 运行在 Android 模拟器中，宿主机地址用 `10.0.2.2`，不能使用 `127.0.0.1`。
4. 如果 Neiroha 运行在 Android 真机中，使用电脑的局域网 IP，并放行 Windows 防火墙。
5. 回到 Neiroha 的 **提供商（Providers）**，新增或编辑提供商。

## 常用适配器

| 后端类型 | Neiroha 适配器 | 基础地址示例 | 角色配置重点 |
|---|---|---|---|
| OpenAI 兼容 TTS | OpenAI TTS API Compatible | `http://127.0.0.1:8880/v1` | 选模型和预设音色 |
| GPT-SoVITS | GPT-SoVITS | `http://127.0.0.1:9880` | 已训练音色或参考音频克隆 |
| CosyVoice3 | CosyVoice Native | `http://127.0.0.1:9880` | 提示克隆、跨语言克隆、指令控制 |
| VoxCPM2 | VoxCPM2 Native | `http://127.0.0.1:8000` | 已注册音色、声音设计、克隆 |
| Windows 系统声音 | Windows System TTS | 留空 | Windows 桌面端直接枚举 SAPI voice |

CosyVoice3 和 GPT-SoVITS 当前都默认使用 `9880`。如果同时启动两个后端，请改其中一个 `configs/server.toml` 的 `[api].port`，或使用 launcher 自动选择的随机端口，并把日志里的实际地址填到 Neiroha。

本地后端完整教程：

- [Neiroha GPT-SoVITS](/workflow/providers/gpt-sovits)
- [Neiroha VoxCPM2](/workflow/providers/voxcpm)
- [Neiroha CosyVoice3](/workflow/providers/cosyvoice)

## Windows 便携后端包

本地后端可以直接下载便携 Release，不需要先装完整开发环境。当前 Windows 便携包按 NVIDIA GPU / CUDA 环境打包，主要面向 RTX 30 / 40 / 50 系列显卡用户。分卷包必须全部下载到同一个目录，再用 7-Zip 从 `.001` 解压。

| 后端 | GitHub Release | 百度网盘镜像 | 当前资产命名 |
|---|---|---|---|
| GPT-SoVITS | [V1.0.0](https://github.com/Neiroha/Neiroha-GPT-SoVITS/releases/tag/V1.0.0) | [网盘备用](https://pan.baidu.com/s/1TFbb4mlrANKJlz0-wuWY8g?pwd=neir) | `Neiroha-GPT-SoVITS-Portable.7z.001` 到 `.003` |
| VoxCPM2 | [V1.0.0](https://github.com/Neiroha/Neiroha-VoxCPM/releases/tag/V1.0.0) | [网盘备用](https://pan.baidu.com/s/1NT_4Uwu4CYOFpZ6ImKe_ig?pwd=neir) | `Neiroha-VoxCPM-portable.7z.001` 到 `.004` |
| CosyVoice3 | [V1.0.0](https://github.com/Neiroha/Neiroha-Cosyvoice/releases/tag/V1.0.0) | [网盘备用](https://pan.baidu.com/s/1YloShmszdxrnXxbdDGlqoA?pwd=neir) | `neiroha-cosyvoice3-portable.7z.001` 到 `.006` |

便携包启动后仍然在解压目录下使用 `runtime/` 存放日志、输出、临时文件和语音注册表。分卷不可单独移动，也不宜解压到系统临时目录后长期使用。

## 后端选择速查

下表是当前 Neiroha Windows 便携后端的相对经验排序，不是统一硬件 benchmark。显存友好度星越多表示越省显存，速度星越多表示合成越快；实际结果会受显卡、驱动、文本长度、参考音频、并发和模型预加载影响。

| 后端 | 显存门槛 | 显存友好度 | 合成速度 | 适合场景 | 备注 |
|---|---|---|---|---|---|
| GPT-SoVITS v2ProPlus | 8 GB 显存更稳 | ★★★★★ | ★★★★★ | 已有训练音色、参考音频克隆、批量生成 | 三者中占用最少、速度最快；clone 需要参考文本 |
| CosyVoice3 0.5B | 建议 8 GB 显存起步 | ★★★☆☆ | ★★★☆☆ | 跨语言克隆、指令控制、多语种试听 | 能力更全面，速度和显存占用居中 |
| VoxCPM2 | 官方口径约 8 GB VRAM | ★★☆☆☆ | ★★☆☆☆ | 声音设计、多语言和方言覆盖、高保真克隆 | 三者中占用最高、速度最慢；8 GB 显存可跑，建议并发从 `1` 开始 |

## 源码环境与多后端

Neiroha 的本地后端项目使用 [Pixi](https://pixi.sh/) 管理 Python、Conda、PyPI 依赖和常用启动命令。需要在同一台机器上长期运行多个后端推理引擎时，推荐按需从源码构建各后端，并只下载实际需要的模型资产；这样比同时保留多套完整便携包更便于升级、排错和控制磁盘占用。

Pixi 底层生态会复用 rattler/Conda 包缓存和 uv/PyPI 缓存，并在可用时通过硬链接复用文件，因此多个后端之间的重复依赖通常不会按完整副本重复占用空间。模型权重、示例音色和运行输出不会自动跨项目共享，仍建议按后端和模型版本单独整理。

## OpenAI 兼容服务

OpenAI 兼容是接入成本较低的本地协议，适合 Kokoro、XTTS、Orpheus、KoboldCpp 或自建的 `/v1/audio/speech` 服务。

1. 提供商适配器选 **OpenAI TTS API Compatible**。
2. 基础地址（`Base URL`）填到 API 版本层，例如 `http://127.0.0.1:8880/v1`。
3. 本地服务没有鉴权时，接口密钥（`API Key`）可以留空。
4. 点 **拉取全部（Fetch All）**。Neiroha 会尝试 `models`、`audio/voices`、`speakers` 等常见列表接口。
5. 如果 voice 列表为空，在创建角色时手动填后端支持的 voice 名称。
6. 健康检查通过后，创建一个预设音色角色并做快速测试。

## GPT-SoVITS

GPT-SoVITS 适合已经有训练好的说话人音色，或需要参考音频克隆的工作流。

1. 启动后端：便携包运行 `start_portable.bat serve`，源码环境运行 `pixi run serve`。
2. 提供商适配器选 **GPT-SoVITS**。
3. 基础地址（`Base URL`）填服务根地址，默认是 `http://127.0.0.1:9880`。
4. 点 **拉取全部（Fetch All）**。新后端会提供 `/v1/models`、`/v1/audio/voices` 和 `/api/gpt-sovits/voices`。
5. 创建角色时选择：
   - 已注册音色：选服务端已有 voice，例如 `genshin-keqing`。
   - 克隆：上传参考音频，并填写参考文本、参考语言和目标文本语言。
6. 快速测试成功后再用于对话 / 段落批量生成。

## CosyVoice Native

CosyVoice Native 使用 Neiroha 的原生 JSON / multipart 适配，不要求后端伪装成纯 OpenAI 服务。

1. 启动后端：便携包运行 `start_portable.bat`，源码环境运行 `pixi run serve`。
2. 提供商适配器选 **CosyVoice Native**。
3. 基础地址（`Base URL`）填服务根地址，默认是 `http://127.0.0.1:9880`。
4. 健康检查会访问 `/health`。
5. **拉取全部（Fetch All）** 会读取 `/v1/models`、`/v1/audio/voices` 和 `/api/cosyvoice/voices`。
6. 创建角色时按模式补齐字段：`prompt_clone` 需要参考音频和 prompt text；`cross_lingual` 仅需参考音频；`instruct` 需要参考音频和 instruction。

## VoxCPM2 Native

VoxCPM2 Native 支持已注册音色、自然语言声音设计和参考音频克隆。

1. 启动后端：便携包运行 `start_portable.bat`，源码环境运行 `pixi run serve`。
2. 提供商适配器选 **VoxCPM2 Native**。
3. 基础地址（`Base URL`）填 `http://127.0.0.1:8000` 或实际服务地址。
4. **拉取全部（Fetch All）** 会读取 `/v1/models`、`/v1/audio/voices` 和 `/api/voxcpm/voices`。
5. 创建角色时按需求选择已注册音色、声音设计、克隆或高保真克隆。
6. `clone` 需要参考音频但不需要参考文本；`ultimate_clone` 需要参考音频和对应文本。

## Android 连接本机后端

| Neiroha 运行位置 | 后端运行位置 | 基础地址填写值 |
|---|---|---|
| Windows 桌面 Neiroha | 同一台 Windows | `http://127.0.0.1:端口` |
| Android 模拟器 | 宿主 Windows | `http://10.0.2.2:端口` |
| Android 真机 | 局域网电脑 | `http://电脑局域网地址:端口` |
| Android 真机 | 公网服务器 | `https://域名` 或公网 IP |

如果真机访问失败，先在手机浏览器打开同一个地址。浏览器也无法访问时，问题通常在防火墙、端口监听地址、代理或局域网隔离。

## 常见失败

| 现象 | 常见原因 | 处理 |
|---|---|---|
| 健康检查失败 | URL 层级错误，或端口未监听 | OpenAI 兼容通常带 `/v1`，原生适配器通常填服务根地址 |
| 模拟器连不上本机 | 写了 `127.0.0.1` | 改成 `10.0.2.2` |
| 真机连不上电脑 | 防火墙拦截或后端只监听 localhost | 后端改监听 `0.0.0.0`，并放行端口 |
| 拉取全部为空 | 后端没有列表接口，或端口填到了错误服务 | 打开 `/v1/models` 和 voice 列表检查，再手动填模型和 voice |
| 批量生成卡住 | 本地显存或并发过高 | 提供商最大并发先设为 `1` |
