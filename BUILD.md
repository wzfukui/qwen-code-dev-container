# 构建文件

本文档面向维护者、开发者和交付人员，说明如何从源码构建 `qwen-code-dev` 镜像、导出镜像包，以及如何做构建后验证。

## 1. 目录产物

- `Dockerfile`: 容器构建定义
- `docker-compose.yml`: 本地或开发机启动示例
- `requirements.txt`: Python 组件清单
- `qwen-settings.template.json`: 默认 Qwen 配置模板示例
- `scripts/build-image.sh`: 镜像构建脚本
- `scripts/save-image.sh`: 镜像导出脚本
- `scripts/model-smoke-test.sh`: 模型冒烟验证脚本
- `scripts/qwen-init-host.sh`: 宿主机一键启动脚本
- `scripts/qwen-config.sh`: 容器内一键写配置脚本

## 2. 构建前提

- Docker 28+
- 能访问：
  - `pypi.org`
  - `registry.npmjs.org`
  - Debian 软件源
- 如需代理，可设置：

```bash
export HTTP_PROXY=http://your-proxy-host:port
export HTTPS_PROXY=http://your-proxy-host:port
```

## 3. 构建镜像

```bash
cd qwen-code-dev-container
./scripts/build-image.sh
```

默认生成镜像：

```bash
qwen-code-dev:0.17.0
```

## 4. 导出镜像包

```bash
cd qwen-code-dev-container
./scripts/save-image.sh qwen-code-dev:0.17.0 ./image/qwen-code-dev-0.17.0.tar.gz
```

输出文件：

```bash
./image/qwen-code-dev-0.17.0.tar.gz
```

## 5. 构建后验证

基础版本检查：

```bash
docker run --rm qwen-code-dev:0.17.0 python --version
docker run --rm qwen-code-dev:0.17.0 node --version
docker run --rm qwen-code-dev:0.17.0 qwen --version
```

模型冒烟验证：

```bash
export DEEPSEEK_API_KEY=你的DeepSeek Key
./scripts/model-smoke-test.sh qwen-code-dev:0.17.0 /tmp
```

如需验证 Anthropic 兼容入口：

```bash
export DEEPSEEK_API_KEY=你的DeepSeek Key
SMOKE_AUTH_TYPE=anthropic ./scripts/model-smoke-test.sh qwen-code-dev:0.17.0 /tmp
```

已验证模型：

- `deepseek-v4-flash`
- `deepseek-v4-pro`

说明：

- 默认使用 DeepSeek OpenAI 兼容入口做构建后的标准化回归验证
- 设置 `SMOKE_AUTH_TYPE=anthropic` 可验证 DeepSeek Anthropic 兼容入口
- 最终交付给用户时，推荐直接维护 `settings.json`
- 现场使用时不再推荐在 `docker run` 阶段通过环境变量自动写入模型配置
- 现场可直接使用 `qwen-config` 写入配置，减少人工编辑器依赖

## 6. 交付建议

建议将以下内容作为交付产物保留：

- 镜像包 `qwen-code-dev-0.17.0.tar.gz`
- [FIELD_USAGE.md](./FIELD_USAGE.md)
- [PYTHON_COMPONENTS.md](./PYTHON_COMPONENTS.md)
- 可选的样例 `.env` 或现场启动脚本
