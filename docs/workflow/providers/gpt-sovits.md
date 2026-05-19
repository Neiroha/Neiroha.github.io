---
title: Neiroha GPT-SoVITS
sidebar_label: GPT-SoVITS
---

这一页对应 Neiroha GPT-SoVITS 本地启动器。将启动器克隆或解压到任意目录；下面用 `<backend-root>` 表示这个目录。

它包含 FastAPI、Gradio Admin、TOML 配置、默认 voice set 和一个示例 voice。

<div className="screenshot-grid">
  <figure>
    <img src="/img/admin_gpt_sovits.png" alt="Neiroha GPT-SoVITS Admin 首页" />
    <figcaption>后端 Admin 用来查看 API 状态、加载 preset、管理 voice 和日志。</figcaption>
  </figure>
  <figure>
    <img src="/img/screenshot_providers.png" alt="Neiroha Providers 配置页" />
    <figcaption>Neiroha 的 Providers 页面负责填写 Base URL、拉取模型和 voice。</figcaption>
  </figure>
</div>

截图使用 `admin` 模式采集，所以首页可能显示 API 离线；实际使用 `start_api_admin.bat` 或 `pixi run api-admin-preload` 会同时启动 API 和 Admin。

## 官方能力速查

这部分按 RVC-Boss/GPT-SoVITS 官方 README 和本地启动器实际字段整理；Neiroha 只负责调用，不会扩大底层模型能力。

| 维度 | 当前结论 |
|---|---|
| 推荐版本 | 本地默认 preset 是 `v2proplus-clone`，使用 v2ProPlus 的 SoVITS 权重。 |
| 支持语言 | 官方列出的跨语言推理范围是中文、英语、日语、韩语、粤语。Neiroha 里对应 `zh` / `en` / `ja` / `ko` / `yue`。 |
| 跨语言输出 | 支持。参考音频和目标文本可以不同语言，但目标语言仍要落在上面的语言范围内。 |
| 方言 | 官方明确支持的是粤语。其他普通话区域方言不要当成已覆盖能力；需要方言口音时更适合单独训练或改用 CosyVoice3 / VoxCPM2。 |
| 克隆是否需要 prompt 文本 | 需要。GPT-SoVITS 的 clone 路径需要参考音频、参考音频对应文本、prompt language 和 text language。 |
| 参考音频 | 官方零样本说法是 5 秒声音样本；本地启动器建议 3 到 10 秒、干净、无背景音乐。v2ProPlus 对超长参考音频较敏感。 |
| 官方速度口径 | 官方 README 给出的 v2ProPlus RTF：RTX 4060Ti 约 `0.028`，RTX 4090 约 `0.014`，M4 CPU 约 `0.526`。这是官方实现的自测值，不等于所有显卡/驱动/文本长度。 |
| 边界 | 长文本请切段；参考文本和音频不匹配会明显降低相似度并增加漏字、重复、口齿异常风险。 |

## 默认地址

| 服务 | 默认地址 | 说明 |
|---|---|---|
| FastAPI | `http://127.0.0.1:19880` | Neiroha Provider 连接这里 |
| Admin | `http://127.0.0.1:17860` | 管理模型 preset、voice、下载和日志 |

端口被占用时，launcher 会自动选择可用随机端口，并写入终端和 `runtime/logs/backend.log`。如果截图或教程里的端口打不开，先看日志里的实际地址。

## 安装

第一次使用在项目目录执行：

```powershell
cd <backend-root>
pixi install
pixi run submodule-init
pixi run install-deps
pixi run install-assets
pixi run install-sample-voice
```

这些命令分别负责创建 Pixi 环境、拉取 GPT-SoVITS 子模块、安装依赖、下载基础预训练资产和安装示例参考声音。

## 启动

最简单：

```powershell
cd <backend-root>
.\start_api_admin.bat
```

这个 bat 会使用 `.pixi\envs\default\python.exe` 启动：

```powershell
scripts\launch_gpt_sovits.py --mode api-admin-preload
```

常用 Pixi task：

| 命令 | 用途 |
|---|---|
| `pixi run api` | 只启动 FastAPI，不预加载模型 |
| `pixi run api-preload` | 启动 FastAPI 并预加载模型 |
| `pixi run admin` | 只启动 Gradio Admin |
| `pixi run api-admin` | 同时启动 API 和 Admin |
| `pixi run api-admin-preload` | 同时启动 API 和 Admin，并预加载模型 |

## 验证后端

启动完成后先测试列表接口：

```powershell
curl.exe http://127.0.0.1:19880/health
curl.exe http://127.0.0.1:19880/v1/models
curl.exe http://127.0.0.1:19880/v1/audio/voices
```

默认配置里：

| 概念 | 默认值 |
|---|---|
| voice set / OpenAI model | `default` |
| voice | `genshin-keqing` |
| model preset | `v2proplus-clone` |
| 参考音频 | `runtime/voices/genshin-keqing/reference.wav` |

快速合成：

```powershell
curl.exe http://127.0.0.1:19880/v1/audio/speech `
  -H "Content-Type: application/json" `
  -d '{ "model":"default", "voice":"genshin-keqing", "input":"你好，这是一次 GPT-SoVITS 测试。", "response_format":"wav" }' `
  --output gpt-sovits-test.wav
```

## 接入 Neiroha

1. 打开 Neiroha 的 **Providers**。
2. 新建 Provider，Adapter Type 选 **GPT-SoVITS**。
3. `Base URL` 填 `http://127.0.0.1:19880`。
4. 本地无鉴权时 `API Key` 留空。
5. 默认模型可填 `gpt-sovits`，也可以使用服务端返回的 voice set。
6. 点击 **Fetch All**。
7. 确认能看到 `genshin-keqing` 或你自己注册的 voice。
8. 打开启用开关，点击 **Health Check**。

<img className="screenshot" src="/img/screenshot_quick_tts.png" alt="Neiroha Quick TTS 试听页面" />

Android 模拟器连接宿主机时，把 Base URL 改成：

```text
http://10.0.2.2:19880
```

## 创建角色

在 **Voice Bank** 新建角色：

| 场景 | 角色设置 |
|---|---|
| 用默认示例声音 | 任务模式选预设/已训练 voice，voice 选 `genshin-keqing` |
| 用已训练权重 | 在 Admin 的 Model Presets 新增 `.ckpt` / `.pth`，再创建 voice |
| 一次性参考音频 clone | 任务模式选音色克隆，填写参考音频、参考文本、语言 |

GPT-SoVITS v2ProPlus clone 对参考音频长度较敏感；本地启动器会对 clone 请求做临时音频规范化，但最好仍准备 3 到 10 秒、干净、无背景音乐的参考音频。

## Admin 里常用页面

| 标签页 | 用途 |
|---|---|
| 首页 | 查看 API 状态、加载/卸载当前 preset |
| 试听 | 用当前 voice set 快速合成 |
| 克隆配置 | 上传参考音频，保存新的 voice profile |
| Model Presets | 登记底层 GPT / SoVITS 权重 |
| 下载 | 下载基础资产和示例参考音频 |
| 日志 | 查看 `runtime/logs/backend.log` |

## 输出和日志

- 合成输出会写入 `runtime/outputs/`。
- 响应头会包含 `X-Neiroha-Output-Path`、`X-Neiroha-Audio-Seconds`、`X-Neiroha-Elapsed-Seconds`、`X-Neiroha-RTF`。
- Admin 日志页读取 `runtime/logs/backend.log`。

## 资料来源

- [RVC-Boss/GPT-SoVITS README](https://github.com/RVC-Boss/GPT-SoVITS/blob/main/README.md)
- [GPT-SoVITS v2Pro / v2ProPlus 预训练模型说明](https://huggingface.co/lj1995/GPT-SoVITS/tree/main)
