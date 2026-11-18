# Neiroha Wiki

这是 Neiroha 的 Docusaurus 文档站点，面向 GitHub Pages 部署。

## 本地开发

```bash
npm install
npm run start
```

## 构建

```bash
npm run build
```

## 部署

`.github/workflows/deploy.yml` 会在 `main` 或 `master` 分支推送后构建站点，并通过 GitHub Pages Actions artifact 发布 `build/` 目录。

### Web 演示发布

Wiki 的 `/guide/web-demo` 和 `/en/guide/web-demo` 共用 `/demo/` 下的 Flutter 应用。部署工作流查询 `Neiroha/Neiroha` 的最新正式 Release。若同版本的 `neiroha-Web-<tag>.zip` 已上传，工作流校验 GitHub 资产的 SHA-256、ZIP 内的应用版本和必要文件，将 Flutter 入口调整为子路径，再随 Wiki 一起发布。演示用包由工作流生成，`build/` 保持 Git 忽略。

- **默认同步**：Wiki 在每小时第 23 分钟检查最新正式版。版本和 SHA-256 与线上一致时跳过构建。推送 Wiki 主分支或手动运行 **Deploy to GitHub Pages** 时立即重新同步。GitHub 会在公开仓库连续 60 天无活动时停用计划任务，可在 Actions 重新启用。
- **发布时通知（可选）**：在主程序 `Neiroha/Neiroha` 的 Actions secrets 添加 `WIKI_DISPATCH_TOKEN`。使用仅授权 `Neiroha/Neiroha.github.io` 仓库的细粒度令牌，授予 `Contents: Read and write`，用于发送 `neiroha-stable-release` 事件。令牌由 CI 读取，定时同步不依赖该令牌。
- **验证**：Wiki 工作流成功后打开 `/guide/web-demo`，确认显示的版本与主程序 Release 相同，再打开 `/demo/`。宿主需为 `.wasm` 提供 `application/wasm`，为 `.mjs` 提供 JavaScript MIME 类型。

可用 Python 3.11 或以上版本和已有 Web ZIP 在本机验收子路径与浏览器启动。每次先运行 `npm run build` 生成干净的 `build/`，再执行以下命令，将示例 ZIP 路径改为实际文件位置。

```powershell
python scripts/release_demo.py local path/to/neiroha-Web-v0.5.0.zip v0.5.0 build
npx docusaurus serve --host 127.0.0.1 --port 8080
```

在浏览器打开 `http://127.0.0.1:8080/guide/web-demo` 查看入口，或打开 `http://127.0.0.1:8080/demo/` 直接测试应用。
