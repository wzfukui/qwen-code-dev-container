# Qwen Code 开发容器部署手册

## 1. 交付物

- `Dockerfile`: 开发容器定义，基于 `python:3.13-slim-bookworm`
- `docker-compose.yml`: 可选的本地/服务器编排示例
- `qwen-settings.template.json`: 默认模型模板
- `requirements.txt`: Python 组件清单
- `scripts/build-image.sh`: 构建镜像
- `scripts/save-image.sh`: 导出镜像包
- `scripts/model-smoke-test.sh`: 三个模型的冒烟验证

## 2. 环境前提

- 已安装 Docker 28+
- 出口可以访问 `registry.npmjs.org`、`deb.nodesource.com`、`pypi.org`
- 如需代理，可使用：
  - `HTTP_PROXY=http://192.168.15.88:8080`
  - `HTTPS_PROXY=http://192.168.15.88:8080`

## 3. 构建镜像

在项目目录执行：

```bash
cd qwen-code-dev-container
export HTTP_PROXY=http://192.168.15.88:8080
export HTTPS_PROXY=http://192.168.15.88:8080
./scripts/build-image.sh
```

不需要代理时，省略 `HTTP_PROXY` 和 `HTTPS_PROXY` 即可。

如果目标机拉取 `docker.io` 基础镜像超时，可以先执行：

```bash
docker pull docker.m.daocloud.io/library/python:3.13-slim-bookworm
docker tag docker.m.daocloud.io/library/python:3.13-slim-bookworm python:3.13-slim-bookworm
docker pull docker.m.daocloud.io/library/node:22-bookworm-slim
```

然后再执行构建脚本。脚本已内置 `--pull=false`，会优先使用本地基础镜像。

构建完成后，镜像标签默认为：

```bash
qwen-code-dev:0.13.0
```

## 4. 导出容器包

```bash
cd qwen-code-dev-container
./scripts/save-image.sh qwen-code-dev:0.13.0 ./image/qwen-code-dev-0.13.0.tar.gz
```

生成文件：

```bash
./image/qwen-code-dev-0.13.0.tar.gz
```

## 5. 在目标服务器导入镜像包

```bash
docker load -i qwen-code-dev-0.13.0.tar.gz
```

## 6. 冒烟验证

```bash
export DASHSCOPE_API_KEY=你的百炼Key
export HTTP_PROXY=http://192.168.15.88:8080
export HTTPS_PROXY=http://192.168.15.88:8080
./scripts/model-smoke-test.sh qwen-code-dev:0.13.0 /tmp
```

脚本会顺序验证：

- `qwen3-30b-a3b-instruct-2507`
- `deepseek-v3`
- `qwen3.5-35b-a3b`

## 7. 推荐挂载目录

- 业务代码目录挂载到 `/workspace`
- Qwen 配置目录单独挂载到 `/root/.qwen`

示例：

```bash
mkdir -p /data/qwen-home
docker run -it --rm \
  -e DASHSCOPE_API_KEY=你的百炼Key \
  -e HTTP_PROXY=http://192.168.15.88:8080 \
  -e HTTPS_PROXY=http://192.168.15.88:8080 \
  -v /data/project:/workspace \
  -v /data/qwen-home:/root/.qwen \
  qwen-code-dev:0.13.0
```
