# Qwen Code 开发容器使用手册

本文件偏向开发环境和日常研发使用。如果是现场交付或一线部署，请优先使用 [FIELD_USAGE.md](./FIELD_USAGE.md)。

## 1. 进入开发容器

```bash
docker run -it --rm \
  -v /your/project:/workspace \
  -v /your/qwen-home:/root/.qwen \
  qwen-code-dev:0.13.2
```

进入后默认位于 `/workspace`。

## 2. 容器内配置

```bash
cp /opt/qwen-dev/qwen-settings.template.json /root/.qwen/settings.json
vi /root/.qwen/settings.json
```

推荐直接按上游 `settings.json` 方式配置模型。模板里已经保留了 `env.LLM_API_KEY` 示例占位，可直接改成现场值。

然后启动：

```bash
qwen
```

## 3. 无界面模式

适合脚本、批处理、CI：

```bash
qwen -p "Explain this repository structure."
```

## 4. 切换模型

交互模式中使用：

```text
/model
```

默认模型来自 `/root/.qwen/settings.json` 的 `model.name`。

## 5. Python 开发能力

容器内预装了以下常用能力：

- HTTP 请求：`requests`、`httpx`
- PostgreSQL：`psycopg`、`asyncpg`、`psql`
- MySQL：`PyMySQL`、`mysql-connector-python`、`mysql`
- Kafka：`confluent-kafka`、`kafka-python`、`kcat`
- Flask 体系：`flask`、`flask-cors`、`flask-restx`、`flask-sqlalchemy`、`flask-migrate`
- MCP：`fastmcp`

## 6. 常见命令

```bash
python --version
node --version
qwen --version
pip list
uv --version
```

## 7. Compose 方式

```bash
export WORKSPACE_HOST_DIR=/your/project
export QWEN_HOME_DIR=/your/qwen-home
docker compose up -d
docker exec -it qwen-code-dev bash
```
