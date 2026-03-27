# Qwen Code 开发容器

这是一个面向内网研发和现场交付场景的 `qwen-code` 容器项目。它将官方 `qwen-code` CLI 与高版本 Python 开发环境整合到同一个镜像中，同时把“构建”和“现场使用”分开说明，避免一线使用者被构建步骤干扰。

容器的最终用户入口参数是通用 OpenAI 兼容接口变量，而不是固定供应商变量：

- `LLM_API_BASE`
- `LLM_API_KEY`
- `LLM_MODEL`
- 可选：`LLM_PROVIDER_NAME`

## 在线分发

本项目已接入 GHCR 发布流程。版本发布后，最终用户可以直接拉取镜像，而不必先下载离线包。

示例：

```bash
docker pull ghcr.io/wzfukui/qwen-code-dev-container:latest
```

或拉取固定版本：

```bash
docker pull ghcr.io/wzfukui/qwen-code-dev-container:0.13.0
```

## 项目目标

- 在容器内直接运行 `qwen`
- 支持挂载外部开发目录到 `/workspace`
- 支持通过任意 OpenAI 兼容接口接入模型
- 预装常用 Python 研发组件、数据库客户端、Kafka 组件和 `fastmcp`
- 提供可复用的构建脚本、部署手册、使用手册和组件清单

## 当前版本

- `qwen-code`: `0.13.0`
- `Python`: `3.13`
- `Node.js`: `22`

## 已验证模型

以下模型已经通过容器内 `qwen -p` 冒烟验证：

- `qwen3-30b-a3b-instruct-2507`
- `deepseek-v3`
- `qwen3.5-35b-a3b`

## 文档分工

- [FIELD_USAGE.md](./FIELD_USAGE.md)
  现场使用文件，重点讲怎么拿到镜像包后 `load`、启动、运行
- [BUILD.md](./BUILD.md)
  构建文件，面向开发者和交付人员，重点讲怎么从源码构建和导出镜像
- [PYTHON_COMPONENTS.md](./PYTHON_COMPONENTS.md)
  Python 组件清单
- [RELEASE.md](./RELEASE.md)
  GitHub Release 发布方式和综合包建议

## 一线用户入口

如果你是现场使用者，请优先看 [FIELD_USAGE.md](./FIELD_USAGE.md)。

最短路径如下：

```bash
docker pull ghcr.io/wzfukui/qwen-code-dev-container:0.13.0
docker run -it --rm \
  -e LLM_API_BASE=https://your-openai-compatible-endpoint/v1 \
  -e LLM_API_KEY=你的Key \
  -e LLM_MODEL=你的模型名 \
  -v /data/project:/workspace \
  -v /data/qwen-home:/root/.qwen \
  ghcr.io/wzfukui/qwen-code-dev-container:0.13.0
```

容器内执行：

```bash
qwen
```

## 开发者入口

如果你是开发者或交付打包人员，请看 [BUILD.md](./BUILD.md)。

## Release 建议

镜像包不应进入 Git 仓库，建议作为 GitHub Release 附件发布。具体做法见 [RELEASE.md](./RELEASE.md)。

## GHCR 发布说明

仓库已包含 GitHub Actions 工作流：

- 打 `v*` 标签时自动构建并推送到 `ghcr.io/wzfukui/qwen-code-dev-container`
- 默认输出标签：
  - `latest`
  - `0.13.0`
  - `0.13`

如果首次推送后包默认不是公开可见，需要在 GitHub 的 Package 页面手工调整为 `public`。

仓库里的 DashScope 相关配置仅用于构建后的标准化验证，不代表最终用户必须使用 DashScope。
