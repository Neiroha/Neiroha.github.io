---
title: 连接本地推理引擎
sidebar_label: 本地推理引擎
---

本地推理引擎适合有本机 GPU、局域网推理服务器，或不希望把文本发到云端的场景。Neiroha 不负责启动模型服务；它负责把 UI、队列、项目和本地 API 请求转发给你已经启动好的 TTS 服务。

<img className="screenshot" src="/img/screenshot_providers.png" alt="本地提供商配置入口" />

## 连接前检查

1. 先启动你的 TTS 后端，确认它监听在固定端口。
2. 在运行 Neiroha 的机器上打开后端的健康检查或模型列表地址。
3. 如果 Neiroha 跑在 Android 模拟器里，宿主机地址用 `10.0.2.2`，不要用 `127.0.0.1`。
4. 如果 Neiroha 跑在 Android 真机里，使用电脑的局域网 IP，并放行 Windows 防火墙。
5. 回到 Neiroha 的 **Providers**，新增或编辑 Provider。

## 常用适配器

| 后端类型 | Neiroha 适配器 | Base URL 示例 | 角色配置重点 |
|---|---|---|---|
| OpenAI 兼容 TTS | OpenAI TTS API Compatible | `http://127.0.0.1:8880/v1` | 选模型和 preset voice |
| GPT-SoVITS | GPT-SoVITS | `http://127.0.0.1:19880` | trained profile 或参考音频 clone |
| CosyVoice3 | CosyVoice Native | `http://127.0.0.1:19890` | prompt clone、cross-lingual、instruct |
| VoxCPM2 | VoxCPM2 Native | `http://127.0.0.1:8000` | registered voice、voice design、clone |
| Windows 系统声音 | Windows System TTS | 留空 | Windows 桌面端直接枚举 SAPI voice |

本地后端的完整教程：

- [Neiroha GPT-SoVITS](/workflow/providers/gpt-sovits)
- [Neiroha VoxCPM2](/workflow/providers/voxcpm)
- [Neiroha CosyVoice3](/workflow/providers/cosyvoice)

## OpenAI 兼容服务

OpenAI 兼容是最容易接的本地协议，适合 Kokoro、XTTS、Orpheus、KoboldCpp 或你自己包的一层 `/v1/audio/speech` 服务。

1. Provider 适配器选 **OpenAI TTS API Compatible**。
2. `Base URL` 填到 API 版本层，例如 `http://127.0.0.1:8880/v1`。
3. 本地服务没有鉴权时，`API Key` 可以留空。
4. 点 **Fetch All**。Neiroha 会尝试 `models`、`audio/voices`、`speakers` 等常见列表接口。
5. 如果 voice 列表为空，在创建角色时手动填后端支持的 voice 名称。
6. Health Check 通过后，创建一个 preset voice 角色并做 Quick Test。

## GPT-SoVITS

GPT-SoVITS 适合已经有训练好的说话人 profile，或需要参考音频克隆的工作流。

1. Provider 适配器选 **GPT-SoVITS**。
2. `Base URL` 填服务根地址。Neiroha GPT-SoVITS 本地启动器默认是 `http://127.0.0.1:19880`。
3. 默认模型可保留 `gpt-sovits`。
4. 点 **Fetch All** 拉取 `/gpt-sovits/models` 和 `/gpt-sovits/voices`。
5. 创建角色时选择：
   - trained/profile：选服务端已有 voice。
   - clone：上传参考音频，并填写参考文本和语言。
6. Quick Test 成功后再用于 Dialog / Phase 批量生成。

## CosyVoice Native

CosyVoice Native 使用 Neiroha 的原生 JSON / multipart 适配，不要求后端伪装成 OpenAI。

1. Provider 适配器选 **CosyVoice Native**。
2. `Base URL` 填服务根地址。Neiroha CosyVoice3 本地启动器默认是 `http://127.0.0.1:19890`。
3. Health Check 会访问 `/health`。
4. 创建角色时可以使用服务端 profiles，也可以用参考音频走 upload 路径。
5. 如果要跨语言或 instruct 风格，优先在角色里补齐 prompt text / voice instruction。

## VoxCPM2 Native

VoxCPM2 Native 支持 registered voice、自然语言声音设计和参考音频克隆。

1. Provider 适配器选 **VoxCPM2 Native**。
2. `Base URL` 填 `http://127.0.0.1:8000` 或你的实际服务地址。
3. **Fetch All** 会尝试 `/v1/models` 和 `/voxcpm/voices`。
4. 创建角色时按需求选择 registered voice、design、clone 或 ultimate clone。
5. clone 类角色需要可访问的本地参考音频文件。

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
| Fetch All 为空 | 后端没有列表接口 | 手动填模型和 voice，再做 Quick Test |
| 批量生成卡住 | 本地显存或并发过高 | Provider 最大并发先设为 `1` |
