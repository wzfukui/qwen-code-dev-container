# Python 组件和系统工具清单

## Python 版本

- `Python 3.13`

## Python 包

| 组件 | 用途 |
| --- | --- |
| `requests` | 同步 HTTP 请求 |
| `httpx` | 同步/异步 HTTP 请求 |
| `httpx-sse` | SSE 流式响应支持 |
| `aiohttp` | 异步 HTTP/WebSocket 服务和客户端 |
| `openai` | OpenAI 兼容接口 SDK |
| `anthropic` | Anthropic 兼容接口 SDK |
| `python-dotenv` | `.env` 配置加载 |
| `PyYAML` | YAML 配置读写 |
| `pydantic` | 数据校验与配置建模 |
| `ipython` | 交互式 Python Shell |
| `pytest` | 单元测试 |
| `pytest-asyncio` | 异步测试支持 |
| `pytest-cov` | 测试覆盖率 |
| `rich` | 终端美化输出 |
| `typer` | CLI 快速开发 |
| `sqlalchemy` | ORM 和数据库抽象 |
| `alembic` | 数据库迁移 |
| `psycopg[binary]` | PostgreSQL 同步驱动 |
| `psycopg2-binary` | PostgreSQL 兼容驱动（老项目常用） |
| `asyncpg` | PostgreSQL 异步驱动 |
| `PyMySQL` | MySQL 纯 Python 驱动 |
| `mysql-connector-python` | MySQL 官方驱动 |
| `redis` | Redis 客户端 |
| `faker` | 测试数据生成 |
| `confluent-kafka` | Kafka 高性能客户端 |
| `kafka-python` | Kafka 纯 Python 客户端 |
| `aiokafka` | Kafka 异步客户端 |
| `python-dateutil` | 日期解析、相对时间和时区辅助 |
| `pytz` | 传统时区库，兼容老项目 |
| `pendulum` | 更易用的时区和时间计算库 |
| `tzdata` | Python 时区数据库 |
| `flask` | Flask Web 框架 |
| `flask-cors` | Flask 跨域支持 |
| `flask-sqlalchemy` | Flask + SQLAlchemy 集成 |
| `flask-migrate` | Flask 数据库迁移 |
| `flask-restx` | Flask REST API 组织 |
| `fastapi` | 轻量 API 开发 |
| `gunicorn` | Flask 生产 WSGI Server |
| `uvicorn` | ASGI Server |
| `fastmcp` | 高层 MCP Server / Client 开发 |
| `mcp` | 官方 MCP Python SDK |
| `beautifulsoup4` | HTML/XML 解析 |
| `lxml` | 高性能 XML/HTML 解析 |
| `websockets` | WebSocket 异步客户端/服务端 |
| `websocket-client` | WebSocket 同步客户端 |

## 系统工具

| 组件 | 用途 |
| --- | --- |
| `bash` / `sh` | Shell 环境 |
| `node` / `npm` | 运行和安装 `qwen-code` |
| `qwen` | 上游 Qwen Code 官方 CLI |
| `qwen-config` | 本容器提供的 `settings.json` 快速生成脚本 |
| `git` | 代码仓库操作 |
| `curl` / `wget` | HTTP 下载与调试 |
| `file` | 文件类型识别 |
| `zip` / `unzip` | ZIP 压缩和解压 |
| `xz-utils` | XZ 压缩和解压 |
| `nano` | 终端编辑器，适合现场快速改配置 |
| `vi` / `vim.tiny` | 终端编辑器，Debian `vim-tiny` 提供 |
| `less` | 分页查看文本 |
| `ripgrep` (`rg`) | 快速检索 |
| `tree` | 目录结构查看 |
| `lsof` | 端口/进程排查 |
| `procps` | `ps` 等进程工具 |
| `psmisc` | `killall`、`pstree` 等进程工具 |
| `jq` | JSON 处理 |
| `imagemagick` (`convert` / `identify`) | 图片格式转换和基础处理 |
| `kcat` | Kafka 命令行读写 |
| `postgresql-client` | `psql` 客户端 |
| `default-mysql-client` | `mysql` 客户端 |
| `redis-tools` | `redis-cli` 客户端 |
| `openssh-client` | SSH / Git over SSH |
| `inetutils-telnet` | Telnet 连通性测试 |
| `netcat-openbsd` | TCP/UDP 探测 |
| `dnsutils` | DNS 解析排查 |
| `iputils-ping` | 网络连通性排查 |
| `iproute2` | `ip` / `ss` 网络排查 |
| `traceroute` | 路由追踪 |
| `openssl` | TLS/证书调试 |
| `whois` | 域名/IP 注册信息查询 |
| `rsync` | 目录同步 |
| `tmux` | 会话保持 |
| `tini` | 容器 init 进程 |
| `tzdata` | 系统时区数据库，默认 `TZ=Asia/Shanghai` |
| `ca-certificates` | HTTPS 证书信任链 |
