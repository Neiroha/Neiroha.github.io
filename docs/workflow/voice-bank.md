---
title: 语音角色与语音库
sidebar_label: 语音角色 / 语音库
---

语音角色是 Neiroha 的核心抽象。Provider 只说明“怎么连接服务”，语音角色才说明“这个项目里谁在说话、用哪个模型、用哪个音色、用什么语速和风格”。

<img className="screenshot" src="/img/screenshot_overview.png" alt="语音库页面" />

## 第一次要做什么

1. 先完成 [Provider 配置](/workflow/providers)，并确认 Provider 已启用。
2. 打开 **Voice Bank**。
3. 选择左侧的 **Default Bank**，或点击 **+** 创建新语音库。
4. 在语音库中点击 **New Character**。
5. 选择 Provider、模型、音色或声音模式。
6. 保存角色。
7. 在右侧 **Quick Test** 输入一句话测试。

## 语音库是什么

语音库是一组角色。项目创建时会绑定一个语音库，后续所有角色下拉框都来自这套库。

| 用法 | 建议 |
|---|---|
| 单人旁白 | 一个库里只放一个旁白角色 |
| 广播剧 / 游戏对话 | 一个库放一整套角色 |
| 多语言测试 | 按语言拆库，例如 `中文旁白`、`English Cast` |
| API Server | 把常用角色放进激活语音库，方便 `/v1/audio/voices` 返回 |

## 创建语音库

1. 在 Voice Bank 左侧点击 **+ 新建库**。
2. 填写库名称。
3. 如果这个库要作为默认库，点击 **设为激活**。
4. 后续 Dialog TTS、Phase TTS、Novel Reader、Video Dub 创建项目时选择这个库。

激活语音库会影响本地 API Server 的模型和 voice 列表：

- `/v1/models` 返回激活语音库。
- `/v1/audio/voices` 返回激活语音库中的角色。
- `POST /v1/audio/speech` 可用 `model` 把 voice 查找限定到某个语音库。

## 创建语音角色

进入 **Voice Bank**，选择一个语音库，然后点击 **New Character**。常用字段如下：

| 字段 | 说明 |
|---|---|
| 名称 | 在界面、项目和 API 请求中显示或匹配的角色名 |
| 提供商 | 一个已启用的 Provider |
| 任务模式 | 决定角色编辑器展示预设音色、参考音频或指令式音色字段 |
| 语速 | 合成速度倍率，通常为 0.5 到 2.0 |
| 头像 | 可选图片，在对话气泡中显示 |

## 按后端选择任务模式

| 模式 | 适用后端 | 配置重点 |
|---|---|---|
| 预设音色 | OpenAI、Azure、Windows SAPI、Gemini 等 | 从 Provider 音色列表选择 voice |
| 音色克隆（带提示） | GPT-SoVITS、CosyVoice、VoxCPM2 等 | 提供参考音频和对应文本 |
| 音色设计 | 支持 `voice_instruction` 或 Chat Completions 音频输出的模型 | 用自由文本描述声音风格 |

## 不同 Provider 的角色填写

| Provider | 角色里最重要的字段 |
|---|---|
| OpenAI 兼容 | model、preset voice |
| MiMo | model、preset voice / instruction / clone reference |
| Gemini | model、Gemini 预设 voice、可选 instruction |
| Azure | Azure voice ShortName，例如 `zh-CN-XiaoxiaoNeural` |
| GPT-SoVITS | trained voice，或 reference audio + prompt text |
| CosyVoice | profile / prompt audio / prompt text |
| VoxCPM2 | registered voice、design instruction 或 clone audio |
| Windows SAPI | 本机安装的 SAPI voice |

如果下拉框没有模型或音色，先回到 Provider 页面点 **Fetch All**。如果后端确实没有列表接口，则手动填模型名或 voice 名。

## 创建后立即测试

角色创建完成后，不要马上跑长文本。先在右侧 **Quick Test** 面板测试：

1. 选中刚创建的角色。
2. 在 Quick Test 输入一句短文本。
3. 点击生成按钮。
4. 能播放，说明 Provider、角色和队列都通了。
5. 再进入 Dialog TTS、Phase TTS 或 Novel Reader。

## 常见问题

| 现象 | 处理 |
|---|---|
| 角色保存不了 | 检查必填字段，尤其是 Provider、任务模式、voice 或参考音频 |
| Provider 下拉框为空 | Provider 没启用，或当前平台不支持该 Provider |
| voice 下拉框为空 | 回 Provider 点 Fetch All，或手动填 voice |
| Quick Test 报 401 / 403 | API Key 或云端区域错误 |
| Quick Test 报 429 | 降低 Provider 并发和 RPM / RPD |
| 本地 clone 找不到参考音频 | 确认文件路径在当前设备可访问，Android 不能直接读 Windows 路径 |
