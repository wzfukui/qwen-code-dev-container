# GitHub Release 发布说明

本文档说明如何把本项目做成适合交付的一线综合包，并通过 GitHub Release 发布。

## 0. Release 和 GHCR 的分工

建议同时保留两条分发线：

- GHCR：给能联网的最终用户直接 `docker pull`
- GitHub Release：给离线环境下载镜像包和现场文档

推荐理解方式：

- 在线用户优先走 GHCR
- 现场交付和内网用户走 Release 附件

## 1. 推荐发布内容

建议不要把镜像包放进 Git 仓库，而是作为 Release 附件发布。

推荐一个 Release 包含：

- 源码仓库内容
- Release Notes
- 附件 `qwen-code-dev-0.13.2.tar.gz`
- 附件 `FIELD_USAGE.md`
- 附件 `PYTHON_COMPONENTS.md`
- 可选附件：
  - `qwen-settings.template.json`
  - `start.sh`
  - `checksums.txt`

## 2. 推荐目录结构

发布前可在本地整理一个 `release/` 目录：

```bash
release/
  qwen-code-dev-0.13.2.tar.gz
  FIELD_USAGE.md
  PYTHON_COMPONENTS.md
  qwen-settings.template.json
  checksums.txt
```

## 3. 生成校验文件

```bash
cd release
shasum -a 256 qwen-code-dev-0.13.2.tar.gz > checksums.txt
```

## 4. 打 Git 标签

```bash
git tag -a v0.13.2 -m "Release v0.13.2"
git push origin v0.13.2
```

推送标签后，仓库内的 GitHub Actions 会自动把镜像推送到：

```bash
ghcr.io/wzfukui/qwen-code-dev-container:0.13.2
ghcr.io/wzfukui/qwen-code-dev-container:0.13
ghcr.io/wzfukui/qwen-code-dev-container:latest
```

同时还会自动完成以下动作：

- 从已发布镜像生成离线包 `qwen-code-dev-0.13.2.tar.gz`
- 生成 `checksums.txt`
- 自动创建或更新同名 GitHub Release
- 自动上传以下 Release 附件：
  - `qwen-code-dev-0.13.2.tar.gz`
  - `FIELD_USAGE.md`
  - `PYTHON_COMPONENTS.md`
  - `qwen-settings.template.json`
  - `checksums.txt`

## 5. 用 gh 创建 Release

如果需要手工创建，示例：

```bash
gh release create v0.13.2 \
  --title "v0.13.2" \
  --notes "现场交付版本，包含 qwen-code 开发容器、现场使用文档和 Python 组件清单。" \
  /path/to/release/qwen-code-dev-0.13.2.tar.gz \
  /path/to/release/FIELD_USAGE.md \
  /path/to/release/PYTHON_COMPONENTS.md \
  /path/to/release/qwen-settings.template.json \
  /path/to/release/checksums.txt
```

## 6. 建议的 Release Notes 结构

- 版本号
- 适用场景
- 镜像标签
- Python / Node / qwen-code 版本
- 已验证模型
- 现场使用方式
- 已知限制

## 7. 一线交付建议

如果面对的是现场实施或客户环境，建议直接让使用者下载 Release 附件，而不是让他们自己构建。

推荐口径：

- 开发者看 [BUILD.md](./BUILD.md)
- 现场人员看 [FIELD_USAGE.md](./FIELD_USAGE.md)
- 运维或采购确认组件范围看 [PYTHON_COMPONENTS.md](./PYTHON_COMPONENTS.md)

## 8. 当前建议

现在仓库已经支持自动化发布，推荐流程就是：

1. 更新版本号
2. 提交并推送 `main`
3. 打 `v*` 标签
4. 等待 GitHub Actions 自动完成 GHCR 和 Release 附件发布

## 9. Node 版本准备

为了提前适配 GitHub Actions 对 Node 20 的弃用，本仓库已做两项准备：

- 容器基础 Node 版本升级到 `24`
- GitHub Actions 显式启用 `FORCE_JAVASCRIPT_ACTIONS_TO_NODE24=true`

这样后续继续升级上游 `qwen-code` 时，运行基线会更稳。
