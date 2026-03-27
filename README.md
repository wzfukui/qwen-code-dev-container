# Qwen Code 开发容器

这是一个面向内网研发和代码助手场景的 `qwen-code` 开发容器项目。它将官方 `qwen-code` CLI 与高版本 Python 开发环境整合到同一个镜像中，适合在服务器、跳板机、内网研发机或日常开发环境中直接挂载代码目录使用。

## 项目目标

- 在容器内直接运行 `qwen`
- 支持挂载外部开发目录到 `/workspace`
- 支持通过 DashScope OpenAI 兼容接口接入模型
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

## 目录说明

- `Dockerfile`: 容器构建定义
- `DEPLOYMENT.md`: 容器构建与部署手册
- `USAGE.md`: 容器使用手册
- `PYTHON_COMPONENTS.md`: Python 组件清单
- `qwen-settings.template.json`: 默认 Qwen 配置模板
- `scripts/build-image.sh`: 镜像构建脚本
- `scripts/save-image.sh`: 镜像导出脚本
- `scripts/model-smoke-test.sh`: 模型冒烟验证脚本

## 快速开始

```bash
export DASHSCOPE_API_KEY=你的百炼Key
docker build -t qwen-code-dev:0.13.0 .
docker run -it --rm \
  -e DASHSCOPE_API_KEY \
  -v /your/project:/workspace \
  -v /your/qwen-home:/root/.qwen \
  qwen-code-dev:0.13.0
```

进入容器后可直接执行：

```bash
qwen
```

## 文档

- 构建与部署说明见 [DEPLOYMENT.md](/Users/donaldford/code/SuperBody/dev/qwen-code-dev-container/DEPLOYMENT.md)
- 日常使用说明见 [USAGE.md](/Users/donaldford/code/SuperBody/dev/qwen-code-dev-container/USAGE.md)
- Python 组件清单见 [PYTHON_COMPONENTS.md](/Users/donaldford/code/SuperBody/dev/qwen-code-dev-container/PYTHON_COMPONENTS.md)
