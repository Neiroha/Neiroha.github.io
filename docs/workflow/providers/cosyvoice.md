---
title: Neiroha CosyVoice3
sidebar_label: CosyVoice3
---

这一页对应 Neiroha CosyVoice3 本地启动器。将启动器克隆或解压到任意目录；下面用 `<backend-root>` 表示这个目录。

它提供 FastAPI、Gradio Admin、TOML voice profile、OpenAI 兼容接口和 CosyVoice 原生接口。

<div className="screenshot-grid">
  <figure>
    <img src="/img/admin_cosyvoice.png" alt="Neiroha CosyVoice3 Admin 首页" />
    <figcaption>后端 Admin 用来查看 API、voice set、模型 preset、克隆配置和日志。</figcaption>
  </figure>
  <figure>
    <img src="/img/screenshot_providers.png" alt="Neiroha Providers 配置页" />
    <figcaption>Neiroha 的 Providers 页面负责连接 `http://127.0.0.1:19890` 并拉取 voice。</figcaption>
  </figure>
</div>

截图使用 `admin` 模式采集，所以首页可能显示 API 离线；实际使用 `start_api_admin.bat` 或 `pixi run api-admin` 会同时启动 API 和 Admin。

## 官方能力速查

这部分按 FunAudioLLM 官方模型卡、CosyVoice3 论文、官方示例和本地启动器 voice profile 整理；Neiroha 只负责调用，不会扩大底层模型能力。

| 维度 | 当前结论 |
|---|---|
| 推荐版本 | 本地默认使用 `Fun-CosyVoice3-0.5B`，输出采样率为 24 kHz。 |
| 支持语言 | 官方模型卡列出 9 种通用语言：中文、英语、日语、韩语、德语、西班牙语、法语、意大利语、俄语。 |
| 方言/口音 | 官方模型卡写明 18+ 中文方言/口音，并列举广东、闽南、四川、东北、山西/陕西、上海、天津、山东、宁夏、甘肃等。论文数据图还出现湖北、吴中、苏杭、湖南、河南、江西、云南、贵州等。实际质量会随文本写法和参考音频波动。 |
| 跨语言输出 | 支持 multilingual / cross-lingual zero-shot voice cloning。目标语言仍建议落在官方 9 种语言内；日语按官方示例最好先转成片假名读法。 |
| prompt clone | `prompt-clone` / `zero_shot` 需要参考音频和 prompt text；prompt text 应是参考音频对应文本。 |
| cross-lingual clone | `cross-lingual-clone` 需要参考音频，不需要 prompt text；目标文本决定输出语言。 |
| instruct clone | `instruct-clone` 需要参考音频和 instruction；适合语速、情绪、方言、音量等指令控制，但不是严格可验证的规则系统。 |
| 官方速度口径 | 官方模型卡强调 bi-streaming，可低至约 150 ms 延迟；没有给出像 GPT-SoVITS/VoxCPM2 那样的官方 PyTorch RTF 表。Neiroha 会在响应头记录本机实测 `X-Neiroha-RTF`。 |
| 边界 | 论文指出罕见词、绕口令、专业术语仍是难点；情绪控制更依赖文本语义，和目标文本无关的情绪要求稳定性较差。 |

## 默认地址

| 服务 | 默认地址 | 说明 |
|---|---|---|
| FastAPI | `http://127.0.0.1:19890` | Neiroha Provider 连接这里 |
| Admin | `http://127.0.0.1:17870` | 管理 voice set、克隆配置、模型 preset、下载和日志 |

端口被占用时，launcher 会自动选择可用随机端口，并在终端、`runtime/logs/backend.log` 和 `/health` 中显示实际地址。

## 安装

```powershell
cd <backend-root>
pixi install
pixi run submodule-init
pixi run install
```

`pixi run install` 默认下载 CosyVoice3 模型到：

```text
models/Fun-CosyVoice3-0.5B
```

Windows 下还会预热 wetext 资源到项目内 `models/_cache`，避免第一次推理才写入系统缓存。

可选：

```powershell
pixi run install-wetext
pixi run install-ttsfrd
```

## 启动

最简单：

```powershell
cd <backend-root>
.\start_api_admin.bat
```

常用命令：

| 命令 | 用途 |
|---|---|
| `pixi run api` | 只启动 FastAPI |
| `pixi run api-preload` | 启动并预加载模型 |
| `pixi run admin` | 只启动 Gradio Admin |
| `pixi run api-admin` | 同时启动 API 和 Admin |
| `pixi run api-admin-preload` | 同时启动并预加载 |

默认配置里 `[api] preload_model = true`，所以首次启动可能需要等模型加载。

## 默认配置

| 概念 | 默认值 |
|---|---|
| voice set / OpenAI model | `default` |
| model preset | `cosyvoice3-default` |
| 底层模型目录 | `models/Fun-CosyVoice3-0.5B` |
| 默认 voice | `prompt-clone` |

默认 voices：

| voice | 模式 | 需要的关键字段 |
|---|---|---|
| `prompt-clone` | `prompt_clone` / `zero_shot` | 参考音频 + prompt text |
| `cross-lingual-clone` | `cross_lingual` | 参考音频 |
| `instruct-clone` | `instruct` | 参考音频 + instruction |

## 验证后端

```powershell
curl.exe http://127.0.0.1:19890/health
curl.exe http://127.0.0.1:19890/v1/models
curl.exe http://127.0.0.1:19890/v1/audio/voices
curl.exe http://127.0.0.1:19890/cosyvoice/profiles
```

快速合成：

```powershell
curl.exe http://127.0.0.1:19890/v1/audio/speech `
  -H "Content-Type: application/json" `
  -d '{ "model":"default", "voice":"prompt-clone", "input":"你好，这是一次 CosyVoice3 测试。", "response_format":"wav" }' `
  --output cosyvoice-test.wav
```

## 接入 Neiroha

1. 打开 Neiroha 的 **Providers**。
2. 新建 Provider，Adapter Type 选 **CosyVoice Native**。
3. `Base URL` 填 `http://127.0.0.1:19890`。
4. 本地无鉴权时 `API Key` 留空。
5. 默认模型可留空，voice set 由后端返回。
6. 点击 **Fetch All**。
7. 确认能看到 `prompt-clone`、`cross-lingual-clone`、`instruct-clone`。
8. 打开启用开关，点击 **Health Check**。

<img className="screenshot" src="/img/screenshot_quick_tts.png" alt="Neiroha Quick TTS 试听页面" />

Android 模拟器连接宿主机时：

```text
http://10.0.2.2:19890
```

## 创建角色

| 目标 | 角色设置 |
|---|---|
| 零样本提示克隆 | 选择 `prompt-clone`，确认有参考音频和 prompt text |
| 跨语言克隆 | 选择 `cross-lingual-clone`，输入目标语言文本 |
| 指令控制 | 选择 `instruct-clone`，在 instruction 写声音要求 |
| 自己的声音 | 在 Admin 的克隆配置页上传参考音频并保存新的 voice |

参考音频建议保持干净、短句、无背景音乐。`prompt_clone` 模式必须有参考文本；`instruct` 模式必须有 instruction。

## Admin 里常用页面

| 标签页 | 用途 |
|---|---|
| 首页 | 查看 API、模型、voice set 和默认 voice |
| 试听 | 直接用已注册 voice 合成一小段 |
| 克隆配置 | 上传参考音频并写入 `runtime/voices/<id>/voice.toml` |
| 音色集合 | 查看和管理 voice set |
| 模型预设 | 管理底层 CosyVoice3 模型目录 |
| 下载 | 下载模型和文本前端资源 |
| 日志 | 查看 backend / admin 日志 |

## 输出和日志

- 合成输出会写入 `runtime/outputs/`。
- 响应头包含 `X-Neiroha-Output-Path`、`X-Neiroha-Audio-Seconds`、`X-Neiroha-Elapsed-Seconds`、`X-Neiroha-RTF`。
- `X-Neiroha-CosyVoice-Mode` 会标出实际使用的 CosyVoice 模式。

## 资料来源

- [Fun-CosyVoice3-0.5B-2512 模型卡](https://huggingface.co/FunAudioLLM/Fun-CosyVoice3-0.5B-2512)
- [FunAudioLLM/CosyVoice 官方示例](https://github.com/FunAudioLLM/CosyVoice/blob/main/example.py)
- [CosyVoice3 论文](https://arxiv.org/abs/2505.17589)
