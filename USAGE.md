# Qwen Code 开发容器使用手册

本文件偏向开发环境和日常研发使用。如果是现场交付或一线部署，请优先使用 [FIELD_USAGE.md](./FIELD_USAGE.md)。

## 1. 进入开发容器

```bash
docker run -it --rm \
  -e LLM_API_BASE=https://your-openai-compatible-endpoint/v1 \
  -e LLM_API_KEY=你的Key \
  -e LLM_MODEL=你的模型名 \
  -v /your/project:/workspace \
  -v /your/qwen-home:/root/.qwen \
  qwen-code-dev:0.13.2
```

进入后默认位于 `/workspace`。

## 2. 启动 Qwen Code 交互开发

```bash
qwen
```

如果传入了 `LLM_API_BASE`、`LLM_API_KEY`、`LLM_MODEL`，容器会自动生成对应的 `/root/.qwen/settings.json`。

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
export DASHSCOPE_API_KEY=你的百炼Key
export WORKSPACE_HOST_DIR=/your/project
export QWEN_HOME_DIR=/your/qwen-home
export LLM_API_BASE=https://your-openai-compatible-endpoint/v1
export LLM_API_KEY=你的Key
export LLM_MODEL=你的模型名
docker compose up -d
docker exec -it qwen-code-dev bash
```
