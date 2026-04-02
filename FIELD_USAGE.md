# 现场使用文件

本文档面向一线使用者，重点说明如何拿到交付包后，在现场机器上完成解压、导入、启动和使用。

## 0. 默认场景

现场默认按离线交付处理，不假设客户环境可以联网下载任何文件。

标准方式就是：

```bash
docker load -i qwen-code-dev-0.13.2.tar.gz
```

## 1. 你会拿到什么

现场建议交付以下文件：

- `qwen-code-dev-0.13.2.tar.gz`
- `FIELD_USAGE.md`
- `PYTHON_COMPONENTS.md`

如果交付方在有网环境预先准备好了 GitHub Release，也可以额外附带：

- `qwen-settings.template.json`
- 启动脚本

## 2. 导入镜像

假设你已经拿到了镜像包：

```bash
ls -lh qwen-code-dev-0.13.2.tar.gz
```

导入 Docker：

```bash
docker load -i qwen-code-dev-0.13.2.tar.gz
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

推荐直接启动一个开发容器，不在 `docker run` 阶段传模型参数：

```bash
docker run -it --rm \
  -v /data/project:/workspace \
  -v /data/qwen-home:/root/.qwen \
  qwen-code-dev:0.13.2
```

进入后默认目录是：

```bash
/workspace
```

容器启动后不会自动改写 `/root/.qwen/settings.json`。

## 5. 容器内配置和启动 Qwen Code

第一次进入容器时，先复制模板：

```bash
cp /opt/qwen-dev/qwen-settings.template.json /root/.qwen/settings.json
```

然后编辑 `/root/.qwen/settings.json`。

推荐直接把地址、模型和密钥都写进文件。一个最小示例：

```json
{
  "modelProviders": {
    "openai": [
      {
        "id": "your-model-name",
        "name": "现场模型",
        "baseUrl": "https://your-openai-compatible-endpoint/v1",
        "description": "OpenAI-compatible endpoint",
        "envKey": "LLM_API_KEY"
      }
    ]
  },
  "env": {
    "LLM_API_KEY": "你的Key"
  },
  "security": {
    "auth": {
      "selectedType": "openai"
    }
  },
  "model": {
    "name": "your-model-name"
  }
}
```

保存后再启动：

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

默认模型来自 `/root/.qwen/settings.json`。

## 7. 常见排查

查看版本：

```bash
python --version
node --version
qwen --version
```

如果模型调用失败，优先检查：

- `/root/.qwen/settings.json` 是否存在且内容正确
- `settings.json` 里的 `env.LLM_API_KEY` 是否正确
- `settings.json` 里的 `baseUrl` 是否可达
- `settings.json` 里的模型名是否被目标网关支持

## 8. 一线最短路径

如果你只关心“怎么用”，最短步骤就是：

1. 将 `qwen-code-dev-0.13.2.tar.gz` 拷贝到现场机器
2. `mkdir -p /data/project /data/qwen-home`
3. `docker load -i qwen-code-dev-0.13.2.tar.gz`
4. `docker run -it --rm -v /data/project:/workspace -v /data/qwen-home:/root/.qwen qwen-code-dev:0.13.2`
5. 容器里执行 `cp /opt/qwen-dev/qwen-settings.template.json /root/.qwen/settings.json`
6. 编辑 `/root/.qwen/settings.json`
7. 执行 `qwen`
