---
title: Neiroha VoxCPM2
sidebar_label: VoxCPM2
---

这一页对应 Neiroha VoxCPM2 本地后端。将 Release 便携包解压，或把源码仓库放到任意目录；下面用 `<backend-root>` 表示这个目录。

它提供 OpenAI 兼容接口、`/api/voxcpm` 原生接口、voice registry、Neiroha Gradio Admin 和可选官方 WebUI。新版本的端口、启动界面、预加载和默认 model preset 都来自 `configs/server.toml`，Pixi task 只保留稳定入口。

<div className="screenshot-grid">
  <figure>
    <img src="/img/admin_voxcpm.png" alt="Neiroha VoxCPM Admin 首页" />
    <figcaption>后端 Admin 用来加载模型、管理 voice registry、试听和查看日志。</figcaption>
  </figure>
</div>

## 能力速查

这部分按 OpenBMB/VoxCPM 官方 README、官方文档和本地后端 voice profile 整理；Neiroha 只负责调用，不会扩大底层模型能力。

| 维度 | 当前结论 |
|---|---|
| 推荐版本 | VoxCPM2 是当前官方推荐的新部署版本，2B 参数，48 kHz 输出。 |
| 支持语言 | 官方列出 30 种：Arabic, Burmese, Chinese, Danish, Dutch, English, Finnish, French, German, Greek, Hebrew, Hindi, Indonesian, Italian, Japanese, Khmer, Korean, Lao, Malay, Norwegian, Polish, Portuguese, Russian, Spanish, Swahili, Swedish, Tagalog, Thai, Turkish, Vietnamese。 |
| 方言 | 官方列出 9 种中文方言：四川话、粤语、吴语、东北话、河南话、陕西话、山东话、天津话、闽南话。方言文本宜使用对应方言的词汇和表达。 |
| 跨语言输出 | 支持多语言合成，也支持用参考音频做跨语言克隆；目标文本仍建议使用官方 30 种语言内的自然书写。 |
| 文本声音设计 | `voxcpm2-design` 不需要参考音频。把年龄、性别、音色、情绪、语速等自然语言描述放在文本开头括号里。 |
| 可控克隆 | `voxcpm2-clone` 使用 `reference_audio` 克隆音色，不需要 prompt 文本；括号里的自然语言提示用于调节情绪、语速、风格。 |
| 高保真克隆 | `voxcpm2-ultimate-clone` 需要 `prompt_audio` + 精确 `prompt_text`，用于延续式 / 对齐式高相似度克隆；这个模式下不应依赖括号控制风格。 |
| 官方速度口径 | 官方 PyTorch 在 RTX 4090 上 RTF 约 `0.30`；Nano-vLLM / vLLM-Omni 加速口径约 `0.13`。官方表格还标注 VoxCPM2 约 8 GB VRAM。 |
| 边界 | 过短文本可能声音发虚；长文本容易出现加速、噪声、无法正常停止或 OOM，生产使用要按句切段。`cfg_value` 过高更贴文本但更容易出现 artifacts。 |

## 默认地址

| 服务 | 默认地址 | 说明 |
|---|---|---|
| FastAPI | `http://127.0.0.1:8000` | Neiroha 提供商连接这里 |
| Admin | `http://127.0.0.1:7860` | 管理 voice、model preset、试听和日志 |

## 安装

推荐使用 Windows 便携包：

1. 打开 [Neiroha-VoxCPM Releases](https://github.com/Neiroha/Neiroha-VoxCPM/releases)。
2. 下载 `V1.0.0` 下的所有分卷：`Neiroha-VoxCPM-portable.7z.001`、`.002`、`.003`、`.004`。
3. 把四个文件放在同一目录，用 7-Zip 从 `.001` 解压。
4. 解压后运行 `start_portable.bat`。

源码或开发环境第一次使用，在 `<backend-root>` 执行：

```powershell
pixi install
pixi run install
```

如果要让 ultimate clone 自动转写参考音频文本，再下载可选 ASR 模型：

```powershell
pixi run install-asr
```

默认情况下 ASR 是关闭的，`ultimate_clone` 需要你手动提供 prompt text。

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
| `pixi run admin` | 只启动 Neiroha Admin，并连接已有 FastAPI |
| `pixi run smoke` | 检查 `/health`、`/v1/models`、`/v1/audio/voices` 和能力接口 |
| `pixi run test` | 运行后端测试 |
| `pixi run launcher-help` | 查看启动参数 |

底层模型路径、`device`、`optimize`、ASR 开关和默认 voice 都从配置读取，不需要再换不同启动 task。

## 默认配置

| 概念 | 默认值 |
|---|---|
| OpenAI `model` / voice set | `default` |
| model preset | `voxcpm2-default` |
| 底层模型 | `models/OpenBMB__VoxCPM2` |
| 默认 voice | `voxcpm2-design` |
| API 预加载 | `true` |
| device | `auto` |
| optimize / denoiser / ASR | 默认关闭 |

默认 voices：

| voice | 模式 | 用途 |
|---|---|---|
| `voxcpm2-design` | `design` | 纯文本声音设计 |
| `voxcpm2-clone` | `clone` | 参考音频可控克隆 |
| `voxcpm2-ultimate-clone` | `ultimate_clone` | `prompt_audio` + `prompt_text` 高保真克隆 |

OpenAI 兼容路由里，`model` 表示 Neiroha voice set，不表示底层 VoxCPM2 权重。底层权重放在 model preset 里。

## 验证后端

```powershell
curl.exe http://127.0.0.1:8000/health
curl.exe http://127.0.0.1:8000/v1/models
curl.exe http://127.0.0.1:8000/v1/audio/voices
curl.exe http://127.0.0.1:8000/api/voxcpm/capabilities
curl.exe http://127.0.0.1:8000/api/voxcpm/voices
```

快速合成：

```powershell
curl.exe -X POST http://127.0.0.1:8000/v1/audio/speech `
  -H "Content-Type: application/json" `
  -d "{\"model\":\"default\",\"input\":\"(A young woman, gentle voice)Hello, this is VoxCPM2.\",\"voice\":\"voxcpm2-design\"}" `
  --output voxcpm-test.wav
```

## 接入 Neiroha

1. 打开 Neiroha 的 **提供商（Providers）**。
2. 新建提供商，适配器类型选 **VoxCPM2 Native**。
3. 基础地址（`Base URL`）填 `http://127.0.0.1:8000`。
4. 本地无鉴权时接口密钥（`API Key`）留空。
5. 点击 **拉取全部（Fetch All）**。
6. 确认能看到 `voxcpm2-design`、`voxcpm2-clone`、`voxcpm2-ultimate-clone`。
7. 打开启用开关，点击 **健康检查（Health Check）**。

Android 模拟器连接宿主机时：

```text
http://10.0.2.2:8000
```

Android 真机连接电脑时，后端需要监听局域网可访问地址，并放行 Windows 防火墙。

## 创建角色

| 目标 | 角色设置 |
|---|---|
| 文本声音设计 | 选 `voxcpm2-design`，在文本开头写自然语言声音描述 |
| 参考音频 clone | 选 `voxcpm2-clone`，提供 reference audio，不需要 prompt text |
| 高保真 clone | 选 `voxcpm2-ultimate-clone`，提供 prompt audio 和 prompt text |
| 复用本地说话人 | 先在 Admin 或 `/api/voxcpm/voices` 注册 voice，再在 Neiroha 里选择它 |

VoxCPM2 当前推荐使用自然语言风格提示，例如：

```text
(A young woman, gentle and sweet voice)Hello, welcome to VoxCPM2.
```

不应依赖未文档化的方括号 token；本地 API 也建议使用自然语言提示和显式字段。

## 注册可复用 voice

原生接口示例：

```powershell
curl.exe -X POST http://127.0.0.1:8000/api/voxcpm/voices `
  -H "Content-Type: application/json" `
  -d "{\"id\":\"demo_cn_01\",\"display_name\":\"Demo CN\",\"mode_hint\":\"reference_with_text\",\"audio_path\":\"file:///path/to/voices/demo/ref.wav\",\"prompt_text\":\"参考文本\",\"copy_audio_to_registry\":true}"
```

注册后，Neiroha **拉取全部（Fetch All）** 会把它作为 voice 候选。

## Admin 页面

| 标签页 | 用途 |
|---|---|
| 首页 | 查看 API 状态、加载 / 卸载 / 重载模型 |
| 试听 | 使用当前 voice set 快速合成 |
| Voice Sets | 管理 OpenAI `model` 对应的 voice set |
| Voices | 创建、编辑、删除可复用 voice profile |
| Downloads | 下载 VoxCPM2 和可选 ASR 模型 |
| Logs | 查看运行日志和 smoke 测试输出 |

## API 口径

稳定 OpenAI 路由：

| 方法 | 路径 | 用途 |
|---|---|---|
| `GET` | `/health` | 健康检查 |
| `GET` | `/v1/models` | 列出 voice set，默认有 `default` |
| `GET` | `/v1/audio/voices` | 列出 voice profile |
| `GET` | `/v1/audio/speakers` | 兼容 speaker 列表 |
| `POST` | `/v1/audio/speech` | OpenAI 兼容合成 |

VoxCPM2 还兼容 `voxcpm2`、`openbmb/VoxCPM2`、`voxcpm-openai-tts` 这类 model alias；`ref_audio` 可作为 `reference_audio` 的别名，`ref_text` 可作为 `prompt_text` 的别名。

标准原生前缀是 `/api/voxcpm`。旧的 `/voxcpm/*` 仍保留兼容，但新文档和新接入应优先使用标准前缀。

| 方法 | 路径 | 用途 |
|---|---|---|
| `GET` | `/api/voxcpm/models` | 列出 model preset / 底层模型 |
| `GET` | `/api/voxcpm/capabilities` | 查看模式、别名、字段和上传能力 |
| `GET` | `/api/voxcpm/meta` | 查看后端元数据 |
| `GET` | `/api/voxcpm/logs` | 读取运行日志 |
| `POST` | `/api/voxcpm/load` | 加载指定 preset |
| `POST` | `/api/voxcpm/unload` | 卸载当前模型 |
| `POST` | `/api/voxcpm/reload` | 重载当前模型 |
| `POST` | `/api/voxcpm/tts` | 原生 JSON 合成 |
| `POST` | `/api/voxcpm/tts/upload` | 上传 reference / prompt audio 并合成 |
| `GET` | `/api/voxcpm/voices` | 列出已注册 voice |
| `POST` | `/api/voxcpm/voices` | 创建或更新 voice |
| `GET` | `/api/voxcpm/voices/{voice_id}` | 查看单个 voice |
| `DELETE` | `/api/voxcpm/voices/{voice_id}` | 删除 voice |

参考音频字段支持本地文件路径、`file://`、`http(s)://` 和 `data:audio/...;base64,...`。如果本地服务设置了 `api_key`，请求需要带 `Authorization: Bearer <key>` 或 `X-API-Key: <key>`。

音频响应头会包含 `X-VoxCPM-RTF`、`X-Neiroha-RTF`、`X-Neiroha-Model-Preset`、`X-Neiroha-Voice`、`X-Neiroha-Audio-Seconds`、`X-Neiroha-Output-Bytes` 和 `X-Neiroha-Output-Path` 等字段。

## 输出和日志

- 当前主要输出格式是 `wav`。
- 合成输出写入 `runtime/outputs/`。
- 上传参考音频只在单次请求中临时使用；要复用请注册到 voice registry。
- 已注册 voice 通过 `DELETE /api/voxcpm/voices/{voice_id}` 删除。

## 资料来源

- [OpenBMB/VoxCPM README](https://github.com/OpenBMB/VoxCPM)
- [VoxCPM2 官方模型说明](https://voxcpm.readthedocs.io/en/latest/models/voxcpm2.html)
- [VoxCPM2 Usage Guide](https://voxcpm.readthedocs.io/en/latest/usage_guide.html)
