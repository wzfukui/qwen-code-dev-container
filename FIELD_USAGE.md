# 现场使用文件

本文档面向一线使用者，重点说明如何拿到交付包后，在现场机器上完成解压、导入、启动和使用。

## 0. 两种使用方式

推荐优先级如下：

1. 有外网或可访问 GitHub Container Registry 时，直接 `docker pull`
2. 无法联网或需要离线交付时，再使用 `tar.gz` 离线包

### 在线拉取

```bash
docker pull ghcr.io/wzfukui/qwen-code-dev-container:latest
```

或固定版本：

```bash
docker pull ghcr.io/wzfukui/qwen-code-dev-container:0.13.1
```

### 离线导入

```bash
docker load -i qwen-code-dev-0.13.1.tar.gz
```

## 1. 你会拿到什么

现场建议交付以下文件：

- `qwen-code-dev-0.13.1.tar.gz`
- `FIELD_USAGE.md`
- `PYTHON_COMPONENTS.md`

如果做成 GitHub Release，还可以附带：

- `qwen-settings.template.json`
- 启动脚本

## 2. 导入镜像

假设你已经拿到了镜像包：

```bash
ls -lh qwen-code-dev-0.13.1.tar.gz
```

导入 Docker：

```bash
docker load -i qwen-code-dev-0.13.1.tar.gz
```

确认镜像存在：

```bash
docker images | grep qwen-code-dev
```

## 3. 准备挂载目录

建议现场机器准备两个目录：

- 业务代码目录，例如 `/data/project`
- Qwen 配置目录，例如 `/data/qwen-home`

示例：

```bash
mkdir -p /data/project
mkdir -p /data/qwen-home
```

## 4. 启动容器

最终用户推荐使用通用 OpenAI 兼容参数：

- `LLM_API_BASE`
- `LLM_API_KEY`
- `LLM_MODEL`
- 可选：`LLM_PROVIDER_NAME`

最常用方式：

```bash
docker run -it --rm \
  -e LLM_API_BASE=https://your-openai-compatible-endpoint/v1 \
  -e LLM_API_KEY=你的Key \
  -e LLM_MODEL=你的模型名 \
  -v /data/project:/workspace \
  -v /data/qwen-home:/root/.qwen \
  ghcr.io/wzfukui/qwen-code-dev-container:0.13.1
```

进入后默认目录是：

```bash
/workspace
```

如果传入了 `LLM_API_BASE`、`LLM_API_KEY`、`LLM_MODEL`，容器启动时会自动生成对应的 `/root/.qwen/settings.json`。

如果没有传这些变量，则回退到仓库里的通用模板配置。

## 5. 启动 Qwen Code

交互模式：

```bash
qwen
```

无界面模式：

```bash
qwen -p "Explain this repository structure."
```

## 6. 切换模型

进入交互界面后执行：

```text
/model
```

默认模型来自你传入的 `LLM_MODEL`，或者 `/root/.qwen/settings.json`。

## 7. 常见排查

查看版本：

```bash
python --version
node --version
qwen --version
```

如果模型调用失败，优先检查：

- `LLM_API_KEY` 是否正确
- `LLM_API_BASE` 是否可达
- `LLM_MODEL` 是否是目标网关支持的模型名
- `/root/.qwen/settings.json` 是否存在且内容正确

## 8. 一线最短路径

如果你只关心“怎么用”，最短步骤就是：

1. `docker pull ghcr.io/wzfukui/qwen-code-dev-container:0.13.1`
2. `mkdir -p /data/project /data/qwen-home`
3. `docker run -it --rm -e LLM_API_BASE=你的地址 -e LLM_API_KEY=你的Key -e LLM_MODEL=你的模型 -v /data/project:/workspace -v /data/qwen-home:/root/.qwen ghcr.io/wzfukui/qwen-code-dev-container:0.13.1`
4. 容器内执行 `qwen`
