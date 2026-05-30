---
title: Neiroha GPT-SoVITS
sidebar_label: GPT-SoVITS
---

这一页对应 Neiroha GPT-SoVITS 本地后端。将 Release 便携包解压，或把源码仓库放到任意目录；下面用 `<backend-root>` 表示这个目录。

它提供 FastAPI、Gradio Admin、TOML model preset、TOML voice set、OpenAI 兼容 TTS 接口和 `/api/gpt-sovits` 原生接口。新版本已经改成配置驱动启动：端口、启动界面、预加载和默认 preset 都来自 `configs/server.toml`，不再使用旧的预加载专用 task。

<div className="screenshot-grid">
  <figure>
    <img src="/img/admin_gpt_sovits.png" alt="Neiroha GPT-SoVITS Admin 首页" />
    <figcaption>后端 Admin 用来查看 API 状态、加载 preset、管理 voice、下载资产和查看日志。</figcaption>
  </figure>
</div>

## 能力速查

这部分按 RVC-Boss/GPT-SoVITS 官方 README 和本地后端当前配置整理；Neiroha 只负责调用，不会扩大底层模型能力。

| 维度 | 当前结论 |
|---|---|
| 推荐版本 | 默认 model preset 是 `v2proplus-clone`，使用 GPT-SoVITS v2ProPlus SoVITS 权重。 |
| 支持语言 | 官方列出的跨语言推理范围是中文、英语、日语、韩语、粤语。Neiroha 里对应 `zh` / `en` / `ja` / `ko` / `yue`。 |
| 跨语言输出 | 支持。参考音频和目标文本可以不同语言，但目标语言仍要落在上面的语言范围内。 |
| 方言 | 官方明确支持的是粤语。其他普通话区域方言不要当成已覆盖能力；需要方言口音时更适合单独训练或改用 CosyVoice3 / VoxCPM2。 |
| 克隆是否需要 prompt 文本 | 需要。clone 路径需要参考音频、参考音频对应文本、prompt language 和 text language。 |
| 参考音频 | 官方零样本说法是 5 秒声音样本；本地后端建议 3 到 10 秒、干净、无背景音乐。v2ProPlus 对超长参考音频较敏感。 |
| 官方速度口径 | 官方 README 给出的 v2ProPlus RTF：RTX 4060Ti 约 `0.028`，RTX 4090 约 `0.014`，M4 CPU 约 `0.526`。这是官方实现自测值，不等于所有显卡、驱动和文本长度。 |
| 边界 | 长文本请切段；参考文本和音频不匹配会明显降低相似度，并增加漏字、重复、口齿异常风险。 |

## 默认地址

| 服务 | 默认地址 | 说明 |
|---|---|---|
| FastAPI | `http://127.0.0.1:9880` | Neiroha 提供商连接这里 |
| Admin | `http://127.0.0.1:7860` | 管理模型 preset、voice、下载和日志 |

如果端口被占用，launcher 会自动选择可用随机端口，并写入终端和 `runtime/logs/backend.log`。默认端口无法访问时，先查看日志里的实际地址。

## 安装

推荐使用 Windows 便携包：

1. 打开 [Neiroha-GPT-SoVITS Releases](https://github.com/Neiroha/Neiroha-GPT-SoVITS/releases)。
2. 下载 `V1.0.0` 下的所有分卷：`Neiroha-GPT-SoVITS-Portable.7z.001`、`.002`、`.003`。
3. 把三个文件放在同一目录，用 7-Zip 从 `.001` 解压。
4. 解压后运行 `start_portable.bat serve`。

源码或开发环境第一次使用，在 `<backend-root>` 执行：

```powershell
pixi install
pixi run install
pixi run install-sample-voice
```

这些命令会初始化 GPT-SoVITS 子模块、安装上游依赖、下载基础预训练资产，并安装一个默认示例 voice。新版本不再默认下载大批角色权重；已有 `.ckpt` / `.pth` 可在 Admin 的 Model Presets 和克隆配置里登记。

## 启动

使用便携 Release 包时：

```powershell
.\start_portable.bat serve
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
| `pixi run smoke` | 检查 `/health`、`/v1/models`、`/v1/audio/voices` |
| `pixi run test` | 运行后端测试 |
| `pixi run launcher-help` | 查看启动参数 |

`admin` 模式只启动 Gradio Admin；如果要 API 和 Admin 一起起来，请保持 `[startup].surface = "both"` 后运行 `pixi run serve`。现在不再把 Gradio mount 到 FastAPI 里。

## 默认配置

| 概念 | 默认值 |
|---|---|
| OpenAI `model` / voice set | `default` |
| OpenAI `voice` | `genshin-keqing` |
| model preset | `v2proplus-clone` |
| GPT 权重 | `models/pretrained/GPT-SoVITS/GPT_SoVITS/pretrained_models/s1v3.ckpt` |
| SoVITS 权重 | `models/pretrained/GPT-SoVITS/GPT_SoVITS/pretrained_models/v2Pro/s2Gv2ProPlus.pth` |
| 运行配置 | `runtime/cache/tts_infer.yaml` |
| API 预加载 | `true` |

OpenAI 兼容路由里，`model` 表示 Neiroha voice set，不表示底层 GPT-SoVITS 权重。底层权重放在 model preset 里。

## 验证后端

```powershell
curl.exe http://127.0.0.1:9880/health
curl.exe http://127.0.0.1:9880/v1/models
curl.exe http://127.0.0.1:9880/v1/audio/voices
curl.exe http://127.0.0.1:9880/api/gpt-sovits/capabilities
```

快速合成：

```powershell
curl.exe http://127.0.0.1:9880/v1/audio/speech `
  -H "Content-Type: application/json" `
  -d '{ "model":"default", "voice":"genshin-keqing", "input":"你好，这是一次 GPT-SoVITS 测试。", "response_format":"wav" }' `
  --output gpt-sovits-test.wav
```

## 接入 Neiroha

1. 打开 Neiroha 的 **提供商（Providers）**。
2. 新建提供商，适配器类型选 **GPT-SoVITS**。
3. 基础地址（`Base URL`）填 `http://127.0.0.1:9880`，如果日志显示随机端口就填日志里的实际地址。
4. 本地无鉴权时接口密钥（`API Key`）留空。
5. 点击 **拉取全部（Fetch All）**。
6. 确认能看到 `default` voice set 和 `genshin-keqing` voice。
7. 打开启用开关，点击 **健康检查（Health Check）**。

Android 模拟器连接宿主机时，把基础地址改成：

```text
http://10.0.2.2:9880
```

Android 真机连接电脑时，后端需要监听局域网可访问地址，并放行 Windows 防火墙。

## 创建角色

| 场景 | 角色设置 |
|---|---|
| 用默认示例声音 | 任务模式选预设 / 已训练 voice，voice 选 `genshin-keqing` |
| 使用自有训练权重 | 在 Admin 的 Model Presets 新增 `.ckpt` / `.pth`，再创建 voice |
| 参考音频 clone | 选择 clone 流程，提供参考音频、参考文本、参考语言和目标文本语言 |
| 多套声音 | 新建 voice set，把需要暴露给 Neiroha 的 voice 放进去 |

GPT-SoVITS v2ProPlus clone 对参考音频长度较敏感。本地后端会对 clone 请求做临时音频规范化，仍建议准备 3 到 10 秒、干净、无背景音乐的参考音频。

## Admin 页面

| 标签页 | 用途 |
|---|---|
| 首页 | 查看 API 状态、启动 / 停止 API、加载 / 卸载当前 preset |
| 试听 | 用当前 voice set 快速合成 |
| Model Presets | 登记底层 GPT / SoVITS 权重 |
| 克隆配置 | 上传参考音频，保存新的 voice profile |
| 下载 | 下载 v2ProPlus 基础资产和示例参考声音 |
| 日志 | 查看 `runtime/logs/backend.log`、下载日志和最新事件 |

## API 口径

稳定 OpenAI 路由：

| 方法 | 路径 | 用途 |
|---|---|---|
| `GET` | `/health` | 健康检查 |
| `GET` | `/v1/models` | 列出 voice set，默认有 `default` |
| `GET` | `/v1/audio/voices` | 列出 voice profile |
| `POST` | `/v1/audio/speech` | 使用已注册 voice 合成 |

标准原生前缀是 `/api/gpt-sovits`。旧的 `/gpt-sovits/*` 和 `/tts` 仍保留兼容，但新文档和新接入应优先用标准前缀。

| 方法 | 路径 | 用途 |
|---|---|---|
| `GET` | `/api/gpt-sovits/models` | 列出 model preset / 底层权重 |
| `GET` | `/api/gpt-sovits/voices` | 列出 voice profile |
| `GET` | `/api/gpt-sovits/capabilities` | 查看 clone、音频规范化和接口能力 |
| `GET` | `/api/gpt-sovits/logs` | 读取运行日志 |
| `POST` | `/api/gpt-sovits/tts` | 按原生 JSON 参数合成 |
| `POST` | `/api/gpt-sovits/clone` | JSON clone 请求 |
| `POST` | `/api/gpt-sovits/clone/upload` | 上传参考音频并 clone |
| `POST` | `/api/gpt-sovits/load` | 加载指定 preset |
| `POST` | `/api/gpt-sovits/unload` | 卸载当前模型 |
| `POST` | `/api/gpt-sovits/reload` | 重载当前模型 |

音频响应头会包含 `X-Neiroha-Backend`、`X-Neiroha-Model-Preset`、`X-Neiroha-Voice`、`X-Neiroha-Sample-Rate`、`X-Neiroha-Inference-Ms`、`X-Neiroha-Output-Path` 和 `X-Neiroha-RTF` 等字段。

## 输出和日志

- 合成输出写入 `runtime/outputs/`。
- 本轮日志写入 `runtime/logs/backend.log`，上轮日志会轮转到 `runtime/logs/backend.previous.log`。
- 下载任务日志写入 `runtime/logs/admin-download.out.log` 和 `runtime/logs/admin-download.err.log`。

## 资料来源

- [RVC-Boss/GPT-SoVITS README](https://github.com/RVC-Boss/GPT-SoVITS/blob/main/README.md)
- [GPT-SoVITS v2Pro / v2ProPlus 预训练模型说明](https://huggingface.co/lj1995/GPT-SoVITS/tree/main)
