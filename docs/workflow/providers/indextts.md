---
title: IndexTTS 2.5 WebUI
sidebar_label: IndexTTS 2.5
---

Neiroha 可以连接单独运行的 IndexTTS 2.5 Gradio WebUI。Windows 可参考社区整合包 `opc-run/tts-index-tts-bundle`，依照项目说明安装后运行 `start-webui.bat`。这个包由社区维护，Neiroha 客户端只连接它启动的服务。[社区整合包](https://github.com/opc-run/tts-index-tts-bundle)

1. 先在浏览器打开 WebUI，确认服务能生成音频。默认地址是 `http://127.0.0.1:7860`。
2. 在 Neiroha 的「提供商」选择 **IndexTTS 2.5 (WebUI)**，填 WebUI 根地址，保存并做健康检查。
3. 到语音库为角色选择参考音频。输出语言可以留在 `auto`，也可指定 `ZH`、`EN`、`JA`、`AR` 或 `ES`。同一角色每次合成都使用这份参考。启动 WebUI 时启用了实验性的情感文本功能，才会使用 Neiroha 里写的情感描述。

## 模型兼容性

| 模型 | 原生端 | Neiroha Web | 流式播放 |
|---|---|---|---|
| IndexTTS 2.5（Gradio `/gen_single`） | 可连接能访问的 WebUI，角色要有参考文件 | 不可用 | 整段生成后播放 |

适配器上传参考文件，等 Gradio 的 SSE 任务返回完成事件，再下载音频文件。手动打开后端的 WebUI 可以测试服务本身。若健康检查不通过，确认部署版本暴露 `/gen_single` 和 Gradio 的 API 信息页。[v0.5.0 适配器](https://github.com/Neiroha/Neiroha/blob/v0.5.0/lib/data/adapters/index_tts_adapter.dart)
