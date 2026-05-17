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
