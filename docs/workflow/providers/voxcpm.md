---
title: Neiroha VoxCPM2
sidebar_label: VoxCPM2
---

这一页对应 Neiroha VoxCPM2 本地启动器。将启动器克隆或解压到任意目录；下面用 `<backend-root>` 表示这个目录。

它提供 OpenAI 兼容接口、VoxCPM 原生接口、voice registry 和 Gradio Admin。

<div className="screenshot-grid">
  <figure>
    <img src="/img/admin_voxcpm.png" alt="Neiroha VoxCPM Admin 首页" />
    <figcaption>后端 Admin 用来加载模型、管理 voice registry、查看日志。</figcaption>
  </figure>
  <figure>
    <img src="/img/screenshot_providers.png" alt="Neiroha Providers 配置页" />
    <figcaption>Neiroha 的 Providers 页面负责连接 `http://127.0.0.1:8000` 并拉取 voice。</figcaption>
  </figure>
</div>

截图使用 `admin` 模式采集，所以首页可能显示 API 离线；实际使用 `start_api_admin.bat` 或 `pixi run api-admin-preload` 会同时启动 API 和 Admin。

## 官方能力速查

这部分按 OpenBMB/VoxCPM 官方 README、官方文档和本地启动器 voice profile 整理；Neiroha 只负责调用，不会扩大底层模型能力。

| 维度 | 当前结论 |
|---|---|
| 推荐版本 | VoxCPM2 是当前官方推荐的新部署版本，2B 参数，48 kHz 输出。 |
| 支持语言 | 官方列出 30 种：Arabic, Burmese, Chinese, Danish, Dutch, English, Finnish, French, German, Greek, Hebrew, Hindi, Indonesian, Italian, Japanese, Khmer, Korean, Lao, Malay, Norwegian, Polish, Portuguese, Russian, Spanish, Swahili, Swedish, Tagalog, Thai, Turkish, Vietnamese。 |
| 方言 | 官方列出 9 种中文方言：四川话、粤语、吴语、东北话、河南话、陕西话、山东话、天津话、闽南话。方言文本最好写成本方言自己的词汇和表达，不要只把普通话句子交给模型。 |
| 跨语言输出 | 支持多语言合成，也支持用参考音频做跨语言克隆；目标文本仍建议使用官方 30 种语言内的自然书写。 |
| 文本声音设计 | `voxcpm2-design` 不需要参考音频。把年龄、性别、音色、情绪、语速等自然语言描述放在文本开头括号里。 |
| 可控克隆 | `voxcpm2-clone` 使用 `reference_audio` 克隆音色，不需要 prompt 文本；括号里的自然语言提示用于调节情绪、语速、风格。 |
| 高保真克隆 | `voxcpm2-ultimate-clone` 需要 `prompt_audio` + 精确 `prompt_text`，用于延续式/对齐式高相似度克隆；这个模式下不要再依赖括号控制风格。 |
| 官方速度口径 | 官方 PyTorch 在 RTX 4090 上 RTF 约 `0.30`；Nano-vLLM / vLLM-Omni 加速口径约 `0.13`。官方表格还标注 VoxCPM2 约 8 GB VRAM。 |
| 边界 | 太短文本可能声音发虚；长文本容易加速、噪声、停不下来或 OOM，生产使用要按句切段。`cfg_value` 过高更贴文本但更容易出 artifacts。 |

## 默认地址

| 服务 | 默认地址 | 说明 |
|---|---|---|
| FastAPI | `http://127.0.0.1:8000` | Neiroha Provider 连接这里 |
| Admin | `http://127.0.0.1:7860` | 管理 voice、model preset、试听和日志 |

## 安装

```powershell
cd <backend-root>
pixi install
pixi run install
```

如果要使用 ultimate clone 的 ASR 辅助能力，再执行：

```powershell
pixi run install-asr
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
| `pixi run api` | 只启动 API，默认关闭 torch compile 优化 |
| `pixi run api-optimize` | 启用优化的 API |
| `pixi run api-asr` | 启用 ASR 的 API |
| `pixi run admin` | 只启动 Neiroha Admin |
| `pixi run webui` | 只启动官方 VoxCPM WebUI |
| `pixi run api-admin` | API + Neiroha Admin |
| `pixi run combined` | API + 官方 WebUI |
| `pixi run api-admin-preload` | 兼容其他本地后端命名的启动方式 |

## 默认配置

| 概念 | 默认值 |
|---|---|
| voice set / OpenAI model | `default` |
| model preset | `voxcpm2-default` |
| 底层模型 | `models/OpenBMB__VoxCPM2` |
| 默认 voice | `voxcpm2-design` |
| API 预加载 | `true` |

默认 voice：

| voice | 模式 | 用途 |
|---|---|---|
| `voxcpm2-design` | `design` | 纯文本声音设计 |
| `voxcpm2-clone` | `clone` | 参考音频可控克隆 |
| `voxcpm2-ultimate-clone` | `ultimate_clone` | `prompt_audio` + `prompt_text` 高保真克隆 |

## 验证后端

```powershell
curl.exe http://127.0.0.1:8000/health
curl.exe http://127.0.0.1:8000/v1/models
curl.exe http://127.0.0.1:8000/v1/audio/voices
curl.exe http://127.0.0.1:8000/voxcpm/voices
```

快速合成：

```powershell
curl.exe -X POST http://127.0.0.1:8000/v1/audio/speech `
  -H "Content-Type: application/json" `
  -d "{\"model\":\"default\",\"input\":\"Hello, this is VoxCPM2.\",\"voice\":\"voxcpm2-design\"}" `
  --output voxcpm-test.wav
```

## 接入 Neiroha

1. 打开 Neiroha 的 **Providers**。
2. 新建 Provider，Adapter Type 选 **VoxCPM2 Native**。
3. `Base URL` 填 `http://127.0.0.1:8000`。
4. 本地无鉴权时 `API Key` 留空。
5. 默认模型填 `voxcpm2` 或保留 `voxcpm2-default` 语义。
6. 点击 **Fetch All**。
7. 确认能看到 `voxcpm2-design`、`voxcpm2-clone`、`voxcpm2-ultimate-clone`。
8. 打开启用开关，点击 **Health Check**。

<img className="screenshot" src="/img/screenshot_quick_tts.png" alt="Neiroha Quick TTS 试听页面" />

Android 模拟器连接宿主机时：

```text
http://10.0.2.2:8000
```

## 创建角色

| 目标 | 角色设置 |
|---|---|
| 文本声音设计 | 选 `voxcpm2-design`，在 voice instruction 写自然语言声音描述 |
| 参考音频 clone | 选 `voxcpm2-clone`，提供 reference audio |
| 高保真 clone | 选 `voxcpm2-ultimate-clone`，提供 prompt audio 和 prompt text |
| 复用本地说话人 | 先在 Admin 或 `/voxcpm/voices` 注册 voice，再在 Neiroha 里选择它 |

VoxCPM2 当前推荐使用自然语言风格提示，例如：

```text
(A young woman, gentle and sweet voice)Hello, welcome to VoxCPM2.
```

不要依赖未文档化的方括号 token；本地 API 文档里也明确建议用自然语言提示和显式字段。

## 注册可复用 voice

原生接口示例：

```powershell
curl.exe -X POST http://127.0.0.1:8000/voxcpm/voices `
  -H "Content-Type: application/json" `
  -d "{\"id\":\"taichi_cn_01\",\"display_name\":\"Taichi CN\",\"mode_hint\":\"reference_with_text\",\"audio_path\":\"file:///path/to/voices/taichi/ref.wav\",\"prompt_text\":\"参考文本\",\"copy_audio_to_registry\":true}"
```

注册后，Neiroha Fetch All 会把它作为 voice 候选。

## 输出和日志

- 当前输出格式主要是 `wav`。
- 合成输出会写入 `runtime/outputs/`。
- 响应头包含 `X-VoxCPM-RTF` 和 `X-Neiroha-RTF` 等性能指标。
- Admin 日志页可查看本轮服务日志。

## 资料来源

- [OpenBMB/VoxCPM README](https://github.com/OpenBMB/VoxCPM)
- [VoxCPM2 官方模型说明](https://voxcpm.readthedocs.io/en/latest/models/voxcpm2.html)
- [VoxCPM2 Usage Guide](https://voxcpm.readthedocs.io/en/latest/usage_guide.html)
