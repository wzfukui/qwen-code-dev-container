# 现场使用文件

本文档面向一线使用者，重点说明如何拿到交付包后，在现场机器上完成解压、导入、启动和使用。

## 1. 你会拿到什么

现场建议交付以下文件：

- `qwen-code-dev-0.13.0.tar.gz`
- `FIELD_USAGE.md`
- `PYTHON_COMPONENTS.md`

如果做成 GitHub Release，还可以附带：

- `qwen-settings.template.json`
- 启动脚本

## 2. 导入镜像

假设你已经拿到了镜像包：

```bash
ls -lh qwen-code-dev-0.13.0.tar.gz
```

导入 Docker：

```bash
docker load -i qwen-code-dev-0.13.0.tar.gz
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

最常用方式：

```bash
docker run -it --rm \
  -e DASHSCOPE_API_KEY=你的百炼Key \
  -v /data/project:/workspace \
  -v /data/qwen-home:/root/.qwen \
  qwen-code-dev:0.13.0
```

进入后默认目录是：

```bash
/workspace
```

如果 `/root/.qwen/settings.json` 不存在，容器会自动生成默认模板。

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

默认已内置以下模型配置：

- `qwen3-30b-a3b-instruct-2507`
- `deepseek-v3`
- `qwen3.5-35b-a3b`

## 7. 常见排查

查看版本：

```bash
python --version
node --version
qwen --version
```

如果模型调用失败，优先检查：

- `DASHSCOPE_API_KEY` 是否正确
- 现场机器是否能访问 `https://dashscope.aliyuncs.com/compatible-mode/v1`
- `/root/.qwen/settings.json` 是否存在且模型名正确

## 8. 一线最短路径

如果你只关心“怎么用”，最短步骤就是：

1. `docker load -i qwen-code-dev-0.13.0.tar.gz`
2. `mkdir -p /data/project /data/qwen-home`
3. `docker run -it --rm -e DASHSCOPE_API_KEY=你的Key -v /data/project:/workspace -v /data/qwen-home:/root/.qwen qwen-code-dev:0.13.0`
4. 容器内执行 `qwen`
