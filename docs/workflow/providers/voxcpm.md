---
title: Neiroha VoxCPM2
sidebar_label: VoxCPM2
---

这一页对应本机项目：

```text
D:\Python_Project\VoxCPM
```

它是给 Neiroha 使用的 VoxCPM2 后端，提供 OpenAI 兼容接口、VoxCPM 原生接口、voice registry 和 Gradio Admin。

<img className="screenshot" src="/img/admin_voxcpm.png" alt="Neiroha VoxCPM Admin" />

## 默认地址

| 服务 | 默认地址 | 说明 |
|---|---|---|
| FastAPI | `http://127.0.0.1:8000` | Neiroha Provider 连接这里 |
| Admin | `http://127.0.0.1:7860` | 管理 voice、model preset、试听和日志 |

## 安装

```powershell
cd D:\Python_Project\VoxCPM
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
cd D:\Python_Project\VoxCPM
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
  -d "{\"id\":\"taichi_cn_01\",\"display_name\":\"Taichi CN\",\"mode_hint\":\"reference_with_text\",\"audio_path\":\"file:///D:/voices/taichi/ref.wav\",\"prompt_text\":\"参考文本\",\"copy_audio_to_registry\":true}"
```

注册后，Neiroha Fetch All 会把它作为 voice 候选。

## 输出和日志

- 当前输出格式主要是 `wav`。
- 合成输出会写入 `runtime/outputs/`。
- 响应头包含 `X-VoxCPM-RTF` 和 `X-Neiroha-RTF` 等性能指标。
- Admin 日志页可查看本轮服务日志。
