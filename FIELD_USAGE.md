# 现场使用文件

本文档面向一线使用者，重点说明如何拿到交付包后，在现场机器上完成解压、导入、启动和使用。

## 0. 默认场景

现场默认按离线交付处理，不假设客户环境可以联网下载任何文件。

标准方式就是：

```bash
docker load -i qwen-code-dev-0.17.0.tar.gz
```

## 1. 你会拿到什么

现场建议交付以下文件：

- `qwen-code-dev-0.17.0.tar.gz`
- `FIELD_USAGE.md`
- `PYTHON_COMPONENTS.md`

如果交付方在有网环境预先准备好了 GitHub Release，也可以额外附带：

- `qwen-settings.template.json`
- `docker-compose.yml`
- 启动脚本

## 2. 导入镜像

假设你已经拿到了镜像包：

```bash
ls -lh qwen-code-dev-0.17.0.tar.gz
```

导入 Docker：

```bash
docker load -i qwen-code-dev-0.17.0.tar.gz
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

推荐用 Docker Compose 启动，后续 `start`、`stop`、`logs`、`exec` 管理更清晰：

```bash
IMAGE_TAG=qwen-code-dev:0.17.0 \
WORKSPACE_HOST_DIR=/data/project \
QWEN_HOME_DIR=/data/qwen-home \
docker compose up -d
```

进入容器：

```bash
docker compose exec qwen-code-dev bash
```

常用管理命令：

```bash
docker compose stop
docker compose start
docker compose logs -f
```

如果现场没有 Docker Compose，也可以直接用 `docker run`：

```bash
docker run -it --name qwen-dev \
  --restart unless-stopped \
  -v /data/project:/workspace \
  -v /data/qwen-home:/root/.qwen \
  qwen-code-dev:0.17.0
```

正式现场使用不建议加 `--rm`。`--rm` 会在容器退出后自动删除容器实例，适合临时测试；长期使用时保留容器更方便，后续可执行：

```bash
docker start -ai qwen-dev
```

只要 `/data/project` 和 `/data/qwen-home` 已挂载，业务代码和 Qwen 配置会保存在宿主机目录中，不依赖容器实例本身。

进入后默认目录是：

```bash
/workspace
```

容器启动后不会自动改写 `/root/.qwen/settings.json`。

## 5. 容器内配置和启动 Qwen Code

第一次进入容器时，可直接用命令写配置（不依赖 `vi/nano`）：

```bash
qwen-config https://api.deepseek.com 你的Key deepseek-v4-flash
```

如果现场网关走 Anthropic 兼容入口：

```bash
qwen-config --auth-type anthropic https://api.deepseek.com/anthropic 你的Key deepseek-v4-pro
```

如需手工编辑，再执行：

```bash
nano /root/.qwen/settings.json
```

镜像内也带了 `vi`，可按现场习惯使用：

```bash
vi /root/.qwen/settings.json
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

更稳妥的现场操作是直接在宿主机编辑：

```bash
nano /data/qwen-home/settings.json
```

该文件会自动映射到容器内 `/root/.qwen/settings.json`。

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
nano --version
vi --version
```

如果模型调用失败，优先检查：

- `/root/.qwen/settings.json` 是否存在且内容正确
- `settings.json` 里的 `env.LLM_API_KEY` 是否正确
- `settings.json` 里的 `baseUrl` 是否可达
- `settings.json` 里的模型名是否被目标网关支持

## 8. 一线最短路径

如果你只关心“怎么用”，最短步骤就是：

1. 将 `qwen-code-dev-0.17.0.tar.gz` 拷贝到现场机器
2. `mkdir -p /data/project /data/qwen-home`
3. `docker load -i qwen-code-dev-0.17.0.tar.gz`
4. `IMAGE_TAG=qwen-code-dev:0.17.0 WORKSPACE_HOST_DIR=/data/project QWEN_HOME_DIR=/data/qwen-home docker compose up -d`
5. `docker compose exec qwen-code-dev bash`
6. 容器里执行 `qwen-config https://api.deepseek.com 你的Key deepseek-v4-flash`
7. 执行 `qwen`
