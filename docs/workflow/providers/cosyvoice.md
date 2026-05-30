---
title: Neiroha CosyVoice3
sidebar_label: CosyVoice3
---

这一页对应 Neiroha CosyVoice3 本地后端。将 Release 便携包解压，或把源码仓库放到任意目录；下面用 `<backend-root>` 表示这个目录。

它提供 FastAPI、Gradio Admin、TOML model preset、TOML voice set、OpenAI 兼容 TTS 接口和 `/api/cosyvoice` 原生接口。新版本默认使用独立 CosyVoice3 后端，官方 `FunAudioLLM/CosyVoice` 作为子模块存在。

<div className="screenshot-grid">
  <figure>
    <img src="/img/admin_cosyvoice.png" alt="Neiroha CosyVoice3 Admin 首页" />
    <figcaption>后端 Admin 用来查看 API、voice set、模型 preset、克隆配置和日志。</figcaption>
  </figure>
</div>

## 能力速查

这部分按 FunAudioLLM 官方模型卡、CosyVoice3 论文、官方示例和本地后端 voice profile 整理；Neiroha 只负责调用，不会扩大底层模型能力。

| 维度 | 当前结论 |
|---|---|
| 推荐版本 | 默认使用 `Fun-CosyVoice3-0.5B`，输出采样率为 24 kHz。 |
| 支持语言 | 官方模型卡列出 9 种通用语言：中文、英语、日语、韩语、德语、西班牙语、法语、意大利语、俄语。 |
| 方言 / 口音 | 官方模型卡写明 18+ 中文方言 / 口音，并列举广东、闽南、四川、东北、山西 / 陕西、上海、天津、山东、宁夏、甘肃等。实际质量会随文本写法和参考音频波动。 |
| 跨语言输出 | 支持 multilingual / cross-lingual zero-shot voice cloning。目标语言仍建议落在官方 9 种语言内；日语按官方示例最好先转成片假名读法。 |
| prompt clone | `prompt-clone` / `zero_shot` 需要参考音频和 prompt text；prompt text 应是参考音频对应文本。 |
| cross-lingual clone | `cross-lingual-clone` 需要参考音频，不需要 prompt text；目标文本决定输出语言。 |
| instruct clone | `instruct-clone` 需要参考音频和 instruction；适合语速、情绪、方言、音量等指令控制，但不是严格可验证的规则系统。 |
| 官方速度口径 | 官方模型卡强调 bi-streaming，可低至约 150 ms 延迟；没有给出统一 PyTorch RTF 表。Neiroha 会在响应头记录本机实测 `X-Neiroha-RTF`。 |
| 边界 | 罕见词、绕口令、专业术语仍可能不稳定；情绪控制更依赖文本语义，和目标文本无关的情绪要求稳定性较差。 |

## 默认地址

| 服务 | 默认地址 | 说明 |
|---|---|---|
| FastAPI | `http://127.0.0.1:9880` | Neiroha Provider 连接这里 |
| Admin | `http://127.0.0.1:7880` | 管理 voice set、克隆配置、模型 preset、下载和日志 |

CosyVoice3 和 GPT-SoVITS 当前都默认使用 API 端口 `9880`。如果你要同时运行多个本地后端，请在其中一个后端的 `configs/server.toml` 修改端口，或使用 launcher 自动选择的随机端口，并把日志里的实际地址填到 Neiroha。

## 安装

Windows 便携包上传完成后，优先从 [Neiroha-Cosyvoice Releases](https://github.com/Neiroha/Neiroha-Cosyvoice/releases) 下载分卷包。命名按同一规则使用 `Neiroha-Cosyvoice-portable.7z.001`、`.002`、`.003` 这类分卷文件；下载时以 Release 页面实际资产为准，把所有分卷放在同一目录后从 `.001` 解压。

源码或开发环境第一次使用，在 `<backend-root>` 执行：

```powershell
pixi install
pixi run submodule-init
pixi run install
```

`pixi run install` 会下载 CosyVoice3 模型到：

```text
models/Fun-CosyVoice3-0.5B
```

Windows 下还会预热 wetext 资源到项目内 `models/_cache`，避免第一次推理才写入系统缓存。

可选资源：

```powershell
pixi run install-wetext
pixi run install-ttsfrd
```

## 启动

使用便携 Release 包时：

```powershell
.\start_portable.bat
```

使用源码或完整开发环境时：

```powershell
pixi run serve
```

常用 Pixi task：

| 命令 | 用途 |
|---|---|
| `pixi run serve` | 按 `configs/server.toml [startup].surface` 启动，默认 API + Admin |
| `pixi run api` | 只启动 FastAPI |
| `pixi run admin` | 只启动 Gradio Admin，并连接已有 FastAPI |
| `pixi run smoke` | 检查 `/health`、`/v1/models`、`/v1/audio/voices` 和合成 |
| `pixi run clone-smoke` | 检查 clone 相关流程 |
| `pixi run test` | 运行后端测试 |
| `pixi run launcher-help` | 查看启动参数 |

默认 `[startup].preload_model = true`，首次启动会先加载模型，等待时间取决于显卡、磁盘和依赖缓存。

## 默认配置

| 概念 | 默认值 |
|---|---|
| OpenAI `model` / voice set | `default` |
| model preset | `cosyvoice3-default` |
| 底层模型目录 | `models/Fun-CosyVoice3-0.5B` |
| 默认 voice | `prompt-clone` |
| API 预加载 | `true` |

默认 voices：

| voice | 模式 | 需要的关键字段 |
|---|---|---|
| `prompt-clone` | `prompt_clone` / `zero_shot` | 参考音频 + prompt text |
| `cross-lingual-clone` | `cross_lingual` | 参考音频 |
| `instruct-clone` | `instruct` | 参考音频 + instruction |

OpenAI 兼容路由里，`model` 表示 Neiroha voice set，不表示底层 CosyVoice3 权重。底层权重放在 model preset 里。

## 验证后端

```powershell
curl.exe http://127.0.0.1:9880/health
curl.exe http://127.0.0.1:9880/v1/models
curl.exe http://127.0.0.1:9880/v1/audio/voices
curl.exe http://127.0.0.1:9880/api/cosyvoice/voices
curl.exe http://127.0.0.1:9880/api/cosyvoice/capabilities
```

快速合成：

```powershell
curl.exe http://127.0.0.1:9880/v1/audio/speech `
  -H "Content-Type: application/json" `
  -d '{ "model":"default", "voice":"prompt-clone", "input":"你好，这是一次 CosyVoice3 测试。", "response_format":"wav" }' `
  --output cosyvoice-test.wav
```

## 接入 Neiroha

1. 打开 Neiroha 的 **Providers**。
2. 新建 Provider，Adapter Type 选 **CosyVoice Native**。
3. `Base URL` 填 `http://127.0.0.1:9880`，如果日志显示随机端口就填日志里的实际地址。
4. 本地无鉴权时 `API Key` 留空。
5. 点击 **Fetch All**。
6. 确认能看到 `prompt-clone`、`cross-lingual-clone`、`instruct-clone`。
7. 打开启用开关，点击 **Health Check**。

Android 模拟器连接宿主机时：

```text
http://10.0.2.2:9880
```

如果你同时运行 GPT-SoVITS 和 CosyVoice3，模拟器地址也要跟随实际端口变化。

## 创建角色

| 目标 | 角色设置 |
|---|---|
| 零样本提示克隆 | 选择 `prompt-clone`，提供参考音频和 prompt text |
| 跨语言克隆 | 选择 `cross-lingual-clone`，提供参考音频和目标语言文本 |
| 指令控制 | 选择 `instruct-clone`，在 instruction 写声音要求 |
| 自己的声音 | 在 Admin 的克隆配置页上传参考音频并保存新的 voice |

参考音频建议保持干净、短句、无背景音乐。`prompt_clone` 模式必须有参考文本；`instruct` 模式必须有 instruction。

## Admin 页面

| 标签页 | 用途 |
|---|---|
| 首页 | 查看 API、模型、voice set、默认 voice 和预加载状态 |
| 试听 | 直接用已注册 voice 合成一小段 |
| 克隆配置 | 上传参考音频并写入 `runtime/voices/<voice-id>/voice.toml` |
| 音色集合 | 查看和管理 voice set |
| 模型预设 | 管理底层 CosyVoice3 模型目录 |
| 下载 | 下载 CosyVoice3、wetext、ttsfrd 等资源 |
| 日志 | 查看 backend / admin / download 日志 |

## API 口径

稳定 OpenAI 路由：

| 方法 | 路径 | 用途 |
|---|---|---|
| `GET` | `/health` | 健康检查 |
| `GET` | `/v1/models` | 列出 voice set，默认有 `default` |
| `GET` | `/v1/audio/voices` | 列出 voice profile |
| `POST` | `/v1/audio/speech` | 使用已注册 voice 合成 |

标准原生前缀是 `/api/cosyvoice`。旧的 `/cosyvoice/*` 和 `/cosyvoice3/*` 仍保留兼容，但新文档和新接入应优先使用标准前缀。

| 方法 | 路径 | 用途 |
|---|---|---|
| `GET` | `/api/cosyvoice/voices` | 列出已注册 voice |
| `GET` | `/api/cosyvoice/meta` | 查看后端元数据 |
| `GET` | `/api/cosyvoice/capabilities` | 查看模式、字段和上传能力 |
| `GET` | `/api/cosyvoice/logs` | 读取运行日志 |
| `POST` | `/api/cosyvoice/tts` | JSON 合成 |
| `POST` | `/api/cosyvoice/tts/upload` | 上传参考音频并合成 |

常见错误码包括 `voice_not_found`、`model_preset_not_found`、`model_not_loaded`、`unsupported_format`、`invalid_reference_audio`、`inference_failed`、`engine_unavailable` 和 `auth_required`。

音频响应头会包含 `X-Neiroha-Backend`、`X-Neiroha-Model-Preset`、`X-Neiroha-Voice`、`X-Neiroha-Sample-Rate`、`X-Neiroha-Inference-Ms`、`X-Neiroha-Output-Path`、`X-Neiroha-Audio-Seconds`、`X-Neiroha-Elapsed-Seconds` 和 `X-Neiroha-RTF` 等字段。

## 输出和日志

- 合成输出写入 `runtime/outputs/`。
- 本轮日志写入 `runtime/logs/backend.log`，上一轮日志会轮转到 `runtime/logs/backend.previous.log`。
- 便携包运行时仍把日志、输出、缓存和临时文件留在解压目录内的 `runtime/` 或 `models/_cache/`。

## 资料来源

- [Fun-CosyVoice3-0.5B-2512 模型卡](https://huggingface.co/FunAudioLLM/Fun-CosyVoice3-0.5B-2512)
- [FunAudioLLM/CosyVoice 官方示例](https://github.com/FunAudioLLM/CosyVoice/blob/main/example.py)
- [CosyVoice3 论文](https://arxiv.org/abs/2505.17589)
