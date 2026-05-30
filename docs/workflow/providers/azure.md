---
title: Azure Speech
sidebar_label: Azure
---

Azure Speech 在 Neiroha 中使用 **Azure Speech Service** 适配器，调用 Microsoft Speech Text-to-Speech REST API。它适合需要稳定语音列表、SSML prosody 和 Azure F0 免费层的场景。

## 免费层和官方入口

Azure Speech 定价页显示 Free F0 的 Neural Text to Speech 有每月免费字符额度；页面当前列出 Neural TTS `0.5 million characters free per month`。价格和区域会变化，最终以 Azure 定价页和订阅控制台为准。

官方页面：

- [Azure Text-to-Speech docs](https://learn.microsoft.com/en-us/azure/ai-services/speech-service/index-text-to-speech)
- [Azure Speech pricing](https://azure.microsoft.com/en-us/pricing/details/speech/)

## 创建 Azure Speech 资源

1. 打开 Azure Portal。
2. 创建 **Speech service** 或在 Foundry / Azure AI services 中创建 Speech 资源。
3. 选择区域，例如 `eastus`、`westus2`、`southeastasia`。
4. 在资源的 **Keys and Endpoint** 页面复制 key。
5. 记下区域名。区域和 key 必须来自同一个资源。

## 提供商填写

| 字段 | 推荐值 |
|---|---|
| Adapter Type | `Azure Speech Service` |
| Name | `Azure Speech East US` |
| 基础地址（Base URL） | `eastus`，或 `https://eastus.tts.speech.microsoft.com` |
| 接口密钥（API Key） | Azure Speech subscription key |
| 默认模型（Default Model） | 留空 |

Neiroha 接受三种基础地址写法：

```text
eastus
https://eastus.tts.speech.microsoft.com
https://eastus.api.cognitive.microsoft.com
```

内部会规范化到 `https://{region}.tts.speech.microsoft.com`。

## 拉取声音

1. 保存提供商。
2. 点 **拉取全部（Fetch All）**。
3. Azure 会通过 `/cognitiveservices/voices/list` 返回 voice 列表。
4. 创建角色时，在 voice 下拉框选择类似 `en-US-AriaNeural`、`zh-CN-XiaoxiaoNeural` 的 ShortName。
5. 用快速测试生成一句短文本。

## 语速和格式

Azure 适配器使用 SSML 合成：

| Neiroha 字段 | Azure 行为 |
|---|---|
| voice | 写入 `<voice name="...">` |
| speed | 写入 `<prosody rate="...">` |
| response_format | 映射到 Azure `X-Microsoft-OutputFormat` |

默认输出 WAV；也可以请求 mp3、ogg/opus 或 pcm。

## 常见失败

| 现象 | 常见原因 | 处理 |
|---|---|---|
| `401` / `403` | key 和区域不匹配，或 key 复制错 | 回 Azure Portal 重新复制同一资源的 key 和 region |
| 拉取全部为空 | 基础地址不是 Speech TTS endpoint | 直接填区域名，例如 `eastus` |
| 中文声音不可用 | 选了不支持目标语言的 voice | 换 `zh-CN-*Neural` 或官方 voice list 中对应语言 |
| 免费额度用完 | F0 字符额度耗尽 | 等下月刷新或升级付费层 |
