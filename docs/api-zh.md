---
sidebar_label: 中文 API
---

# Neiroha — 音频 API 参考文档

Neiroha 有两类 API：

1. **Neiroha 内置 API 服务器**：把当前应用里的语音库暴露成 OpenAI 兼容 TTS 服务，适合脚本、游戏、DAW 或其他工具调用 Neiroha。
2. **提供商上游适配器**：Neiroha 作为客户端，去调用本地或云端 TTS 后端。

## 1. 内置 API 服务器

内置服务器默认运行在 `127.0.0.1:8976`，可从 **设置 → API 服务器（API Server）** 开关。只有在明确需要局域网访问时，才把绑定地址改成 `0.0.0.0`。

### 安全与运行配置

| 设置 | 默认值 | 说明 |
|---|---|---|
| 绑定地址 | `127.0.0.1` | 默认仅本机回环访问 |
| 端口 | `8976` | 修改后需要重启服务器 |
| 接口密钥（API Key） | 空 | 设置后请求需发送 `Authorization: Bearer <key>` 或 `X-API-Key: <key>` |
| CORS origins | 空 | 空值拒绝浏览器跨域访问；`*` 允许任意 origin |
| 限流 | `60` req/min/IP | `0` 表示禁用 |
| 最大请求体 | `1048576` 字节 | `0` 表示不检查声明的 Content-Length |
| API 日志输出 | 关闭 | 仅记录元数据；不会记录请求体和认证头 |

所有合成请求都会进入共享的 `TtsQueueService`，因此提供商并发数和限流规则同时作用于桌面界面和外部 API 客户端。

### 音色库作为模型

内置 API 用**语音库（Voice Bank）**作为 `model`：

- 激活的音色库会在 `/v1/models` 中作为模型出现。
- API 请求中的 `model` 值是音色库名称。
- `/v1/audio/voices` 和 `/speakers` 只列出激活音色库中的声音。

### 端点

| 方法 | 路径 | 说明 |
|---|---|---|
| `POST` | `/v1/audio/speech` | 将文本合成为语音 |
| `GET` | `/v1/audio/voices` | 列出激活音色库中的声音 |
| `GET` | `/v1/models` | 将激活音色库列为 OpenAI 风格模型 |
| `GET` | `/speakers` | SillyTavern 风格说话人列表 |
| `GET` | `/health` | 健康检查 |

### `POST /v1/audio/speech`

```json
{
  "input": "要合成的文本",
  "model": "My Bank",
  "voice": "character_name",
  "speed": 1.0,
  "response_format": "wav"
}
```

| 字段 | 类型 | 是否必填 | 说明 |
|---|---|---|---|
| `input` | string | 是 | 要合成的文本 |
| `voice` | string | 是 | 声音角色名称 |
| `model` | string | 否 | 音色库名称；提供后只在该库中查找 voice |
| `speed` | number | 否 | 播放速度倍数，默认 `1.0` |
| `response_format` | string | 否 | 输出格式提示，会传给上游适配器 |

响应是原始音频字节，`Content-Type` 随输出格式变化。

常见错误：

| 状态码 | 含义 |
|---|---|
| `400` | 缺少 `input` 或 `voice` |
| `401` | 配置鉴权后缺少或传入错误接口密钥 |
| `413` | 请求体超过配置大小 |
| `429` | 超过按 IP 统计的请求预算 |
| `404` | 未找到声音角色 |
| `500` | 未找到提供商或上游合成失败 |

## 2. 提供商上游适配器

提供商的基础地址（`Base URL`）规则取决于适配器：OpenAI 兼容服务通常填到 `/v1`，Neiroha 原生本地后端通常填服务根地址。

### OpenAI TTS API Compatible

适用于任何暴露标准 OpenAI TTS API 的服务。

| 操作 | 方法 | 相对路径 |
|---|---|---|
| 合成 | `POST` | `/audio/speech` |
| 健康检查 / 模型列表 | `GET` | `/models` |
| 语音列表 | `GET` | `/audio/voices`，失败后尝试 `/speakers` |

示例请求：

```json
{
  "model": "tts-1",
  "input": "text",
  "voice": "alloy",
  "speed": 1.0,
  "response_format": "wav"
}
```

### Chat Completions TTS

适用于通过 Chat Completions 返回音频的 TTS 提供商，例如 MiMo 风格音频模型。

| 操作 | 方法 | 相对路径 |
|---|---|---|
| 合成 | `POST` | `/chat/completions` |
| 健康检查 / 模型列表 | `GET` | `/models` |
| 语音列表 | `GET` | `/speakers` |

Neiroha 会从 `choices[0].message.audio.data` 读取 base64 音频。MiMo 风格提供商默认使用 `api-key` 请求头。

### CosyVoice Native

用于 Neiroha CosyVoice3 本地后端。默认服务根地址是 `http://127.0.0.1:9880`；如果端口被占用，以后端日志里的实际地址为准。

稳定 OpenAI 路由：

| 方法 | 路径 | 说明 |
|---|---|---|
| `GET` | `/health` | 健康检查 |
| `GET` | `/v1/models` | 列出 voice set |
| `GET` | `/v1/audio/voices` | 列出 voice profile |
| `POST` | `/v1/audio/speech` | 使用已注册 voice 合成 |

标准原生路由：

| 方法 | 路径 | 说明 |
|---|---|---|
| `GET` | `/api/cosyvoice/voices` | 列出已注册 voice |
| `GET` | `/api/cosyvoice/meta` | 后端元数据 |
| `GET` | `/api/cosyvoice/capabilities` | 模式、字段和上传能力 |
| `GET` | `/api/cosyvoice/logs` | 运行日志 |
| `POST` | `/api/cosyvoice/tts` | JSON 合成 |
| `POST` | `/api/cosyvoice/tts/upload` | 上传参考音频并合成 |

旧的 `/cosyvoice/*` 和 `/cosyvoice3/*` 仍保留兼容；新接入优先使用 `/api/cosyvoice/*`。

JSON 合成示例：

```json
{
  "text": "要合成的文本",
  "model": "default",
  "voice": "prompt-clone",
  "mode": "zero_shot",
  "speed": 1.0,
  "response_format": "wav",
  "prompt_audio_path": "/path/to/voices/demo.wav",
  "prompt_text": "参考文本",
  "instruct_text": "用温柔平静的语气朗读"
}
```

模式要求：

| 模式 | 说明 | 必填字段 |
|---|---|---|
| `zero_shot` / `prompt_clone` | 提示克隆 | 参考音频 + `prompt_text` |
| `cross_lingual` | 跨语言克隆 | 参考音频 |
| `instruct` | 指令控制 | 参考音频 + `instruct_text` |

### GPT-SoVITS

用于 Neiroha GPT-SoVITS 本地后端。默认服务根地址是 `http://127.0.0.1:9880`；如果和其他后端冲突，以日志里的实际地址为准。

稳定 OpenAI 路由：

| 方法 | 路径 | 说明 |
|---|---|---|
| `GET` | `/health` | 健康检查 |
| `GET` | `/v1/models` | 列出 voice set |
| `GET` | `/v1/audio/voices` | 列出 voice profile |
| `POST` | `/v1/audio/speech` | 使用已注册 voice 合成 |

标准原生路由：

| 方法 | 路径 | 说明 |
|---|---|---|
| `GET` | `/api/gpt-sovits/models` | 列出 model preset / 底层权重 |
| `GET` | `/api/gpt-sovits/voices` | 列出 voice profile |
| `GET` | `/api/gpt-sovits/capabilities` | clone 和音频规范化能力 |
| `GET` | `/api/gpt-sovits/logs` | 运行日志 |
| `POST` | `/api/gpt-sovits/tts` | 原生 JSON 合成 |
| `POST` | `/api/gpt-sovits/clone` | JSON clone 请求 |
| `POST` | `/api/gpt-sovits/clone/upload` | 上传参考音频并 clone |
| `POST` | `/api/gpt-sovits/load` | 加载指定 preset |
| `POST` | `/api/gpt-sovits/unload` | 卸载当前模型 |
| `POST` | `/api/gpt-sovits/reload` | 重载当前模型 |

旧的 `/gpt-sovits/*` 和 `/tts` 仍保留兼容；新接入优先使用 `/api/gpt-sovits/*`。

clone 请求示例：

```json
{
  "input": "要合成的文本",
  "speaker": "clone",
  "text_lang": "zh",
  "ref_audio_path": "/path/to/ref.wav",
  "prompt_text": "参考文本",
  "prompt_lang": "zh",
  "speed": 1.0,
  "response_format": "wav"
}
```

### VoxCPM2 Native

用于 Neiroha VoxCPM2 本地后端。默认服务根地址是 `http://127.0.0.1:8000`。

稳定 OpenAI 路由：

| 方法 | 路径 | 说明 |
|---|---|---|
| `GET` | `/health` | 健康检查 |
| `GET` | `/v1/models` | 列出 voice set |
| `GET` | `/v1/audio/voices` | 列出 voice profile |
| `GET` | `/v1/audio/speakers` | speaker 列表兼容路径 |
| `POST` | `/v1/audio/speech` | OpenAI 兼容合成 |

标准原生路由：

| 方法 | 路径 | 说明 |
|---|---|---|
| `GET` | `/api/voxcpm/models` | 列出 model preset / 底层模型 |
| `GET` | `/api/voxcpm/capabilities` | 模式、别名、字段和上传能力 |
| `GET` | `/api/voxcpm/meta` | 后端元数据 |
| `GET` | `/api/voxcpm/logs` | 运行日志 |
| `POST` | `/api/voxcpm/load` | 加载指定 preset |
| `POST` | `/api/voxcpm/unload` | 卸载当前模型 |
| `POST` | `/api/voxcpm/reload` | 重载当前模型 |
| `POST` | `/api/voxcpm/tts` | 原生 JSON 合成 |
| `POST` | `/api/voxcpm/tts/upload` | 上传 reference / prompt audio 并合成 |
| `GET` | `/api/voxcpm/voices` | 列出已注册 voice |
| `POST` | `/api/voxcpm/voices` | 创建或更新 voice |
| `GET` | `/api/voxcpm/voices/{voice_id}` | 查看单个 voice |
| `DELETE` | `/api/voxcpm/voices/{voice_id}` | 删除 voice |

旧的 `/voxcpm/*` 仍保留兼容；新接入优先使用 `/api/voxcpm/*`。

OpenAI 扩展字段：

| 字段 | 说明 |
|---|---|
| `reference_audio` / `ref_audio` | 参考音频，支持本地路径、`file://`、`http(s)://`、`data:audio/...;base64,...` |
| `prompt_audio` | ultimate clone 的 prompt audio |
| `prompt_text` / `ref_text` | prompt audio 对应文本 |
| `mode` | `design`、`clone`、`ultimate_clone` 或兼容别名 |
| `instruction` | 自然语言声音描述 |
| `auto_asr` | 配合可选 ASR 模型自动转写 prompt text |
| `cfg_value`、`inference_timesteps`、`normalize`、`denoise` | VoxCPM2 推理控制参数 |

### Azure Speech Service

| 操作 | 方法 | 路径 |
|---|---|---|
| 合成 | `POST` | `/cognitiveservices/v1` |
| 健康检查 / 语音列表 | `GET` | `/cognitiveservices/voices/list` |

基础地址（Base URL）可以填区域名，例如 `eastus`，也可以填 `https://eastus.tts.speech.microsoft.com`。接口密钥使用 Azure 订阅密钥，Neiroha 会放到 `Ocp-Apim-Subscription-Key` 头。

### Google Gemini TTS

Gemini TTS 使用 Google AI Studio 接口密钥。提供商中填写 `https://generativelanguage.googleapis.com`，然后选择 Gemini TTS 模型和音色。

### Windows 系统语音

Windows 桌面端通过系统 SAPI 合成，无需基础地址或接口密钥。Android、Apple 和 Linux 的系统 TTS 在原生适配器实现前不会作为可用提供商暴露。

## 3. 响应头和排错

Neiroha 本地后端的音频响应通常会带这些头，具体字段按后端不同略有差异：

| 响应头 | 含义 |
|---|---|
| `X-Neiroha-Backend` | 后端名称 |
| `X-Neiroha-Model-Preset` | 底层 model preset |
| `X-Neiroha-Voice` | 实际使用的 voice |
| `X-Neiroha-Sample-Rate` | 输出采样率 |
| `X-Neiroha-Inference-Ms` | 推理耗时 |
| `X-Neiroha-Audio-Seconds` | 输出音频长度 |
| `X-Neiroha-Output-Path` | 服务端输出文件路径 |
| `X-Neiroha-RTF` | 本机实测 RTF |

排错顺序：

1. 浏览器或 `curl` 先打开 `/health`。
2. 再检查 `/v1/models` 和 `/v1/audio/voices`。
3. 提供商里点 **拉取全部（Fetch All）**，确认模型和 voice 已缓存。
4. 先用 Quick TTS 单句测试，再上 Dialog / Phase / Video 批量生成。
