# Qwen Code 开发容器

这是一个面向内网研发和现场交付场景的 `qwen-code` 容器项目。它将官方 `qwen-code` CLI 与高版本 Python 开发环境整合到同一个镜像中，同时把“构建”和“现场使用”分开说明，避免一线使用者被构建步骤干扰。

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
docker load -i qwen-code-dev-0.13.0.tar.gz
docker run -it --rm \
  -e DASHSCOPE_API_KEY=你的百炼Key \
  -v /data/project:/workspace \
  -v /data/qwen-home:/root/.qwen \
  qwen-code-dev:0.13.0
```

容器内执行：

```bash
qwen
```

## 开发者入口

如果你是开发者或交付打包人员，请看 [BUILD.md](./BUILD.md)。

## Release 建议

镜像包不应进入 Git 仓库，建议作为 GitHub Release 附件发布。具体做法见 [RELEASE.md](./RELEASE.md)。
