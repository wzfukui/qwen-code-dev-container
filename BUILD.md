# 构建文件

本文档面向维护者、开发者和交付人员，说明如何从源码构建 `qwen-code-dev` 镜像、导出镜像包，以及如何做构建后验证。

## 1. 目录产物

- `Dockerfile`: 容器构建定义
- `docker-compose.yml`: 本地或开发机启动示例
- `requirements.txt`: Python 组件清单
- `qwen-settings.template.json`: 默认 Qwen 模型模板
- `scripts/build-image.sh`: 镜像构建脚本
- `scripts/save-image.sh`: 镜像导出脚本
- `scripts/model-smoke-test.sh`: 模型冒烟验证脚本

## 2. 构建前提

- Docker 28+
- 能访问：
  - `pypi.org`
  - `registry.npmjs.org`
  - Debian 软件源
- 如需代理，可设置：

```bash
export HTTP_PROXY=http://192.168.15.88:8080
export HTTPS_PROXY=http://192.168.15.88:8080
```

## 3. 构建镜像

```bash
cd qwen-code-dev-container
./scripts/build-image.sh
```

默认生成镜像：

```bash
qwen-code-dev:0.13.2
```

## 4. 导出镜像包

```bash
cd qwen-code-dev-container
./scripts/save-image.sh qwen-code-dev:0.13.2 ./image/qwen-code-dev-0.13.2.tar.gz
```

输出文件：

```bash
./image/qwen-code-dev-0.13.2.tar.gz
```

## 5. 构建后验证

基础版本检查：

```bash
docker run --rm qwen-code-dev:0.13.2 python --version
docker run --rm qwen-code-dev:0.13.2 node --version
docker run --rm qwen-code-dev:0.13.2 qwen --version
```

模型冒烟验证：

```bash
export DASHSCOPE_API_KEY=你的百炼Key
./scripts/model-smoke-test.sh qwen-code-dev:0.13.2 /tmp
```

已验证模型：

- `qwen3-30b-a3b-instruct-2507`
- `deepseek-v3`
- `qwen3.5-35b-a3b`

说明：

- 这里使用 DashScope 只是为了做构建后的标准化回归验证
- 最终交付给用户时，推荐使用通用 `LLM_API_BASE`、`LLM_API_KEY`、`LLM_MODEL`

## 6. 交付建议

建议将以下内容作为交付产物保留：

- 镜像包 `qwen-code-dev-0.13.2.tar.gz`
- [FIELD_USAGE.md](./FIELD_USAGE.md)
- [PYTHON_COMPONENTS.md](./PYTHON_COMPONENTS.md)
- 可选的样例 `.env` 或现场启动脚本
