---
title: 项目文档维护
sidebar_label: 文档维护
---

Neiroha 源项目的 `docs/` 目录用于保存小而当前的产品说明。历史会话记录和长篇研究资料分开存放，避免根文档变成第二个 backlog。

## 活跃文档

| 文件 | 用途 |
|---|---|
| [plan.md](/plan) | 当前实现队列和重构优先级 |
| [bugs.md](/bugs) | 已确认缺陷和产品风险 |
| [api.md](/api) | 英文 API 与适配器参考 |
| [api-zh.md](/api-zh) | 中文 API 与适配器参考 |

## 归档与研究

- [archive](/category/archive) 保存有日期的实现记录和旧 review 记录。这些是历史资料，不是当前需求。
- [research](/category/research) 保存仍有参考价值的后端、API 和架构研究。

## 维护规则

- 功能进入或离开活跃队列时更新 [plan.md](/plan)。
- 只把已确认问题或具体风险写入 [bugs.md](/bugs)。
- 端点行为变化时保持 [api.md](/api) 和 [api-zh.md](/api-zh) 对齐。
- 有日期的会话记录放入 `archive/`。
- 研究、架构和长篇设计说明放入 `research/`。
- 根 `docs/` 不新增一次性 Markdown，除非它会成为长期入口文档。
