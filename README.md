# Qwen Code 开发容器

基于 Qwen Code 的离线开发神器。

这个项目最开始不是为了“再造一个 AI 编码工具”，而是为了解决很多技术人员在客户现场、内网环境和交付环境里反复遇到的一类老问题：

- 现场机器网络受限，很多时候既不能顺畅访问公网，也不方便临时安装一堆依赖
- 客户环境常常不能直接 `npm install`、`pip install`，甚至连基础开发环境都不统一
- 真到现场排障或开发时，往往不只是要跑 `qwen`，还需要 Python、数据库客户端、Kafka 工具、HTTP 调试工具一起就位
- 用户真正关心的是“我怎么快速开始干活”，不是先研究一遍构建链路
- 同一个项目在开发环境能跑，不代表在客户现场、跳板机、隔离网段、离线机器上还能顺利跑起来

很多一线工程师都经历过这种场景：到了客户现场，需求很急，问题很具体，但时间都耗在环境准备、依赖安装、镜像搬运、模型配置和网络适配上。工具本身没问题，真正拖慢效率的是“最后一公里”的落地。

这个仓库就是为了解决这件事。它把官方 `qwen-code` CLI 与高版本 Python 开发环境整合进一个可交付、可复用、可现场落地的容器里，并把“构建文件”和“现场使用文件”明确拆开，让开发者、交付人员和现场工程师各看各的，不互相干扰。

它的目标很直接：

- 让技术人员在客户现场尽快进入可工作的开发状态
- 让交付过程从“现场拼环境”变成“直接拉镜像或导入离线包”
- 让 Qwen Code 在内网、离线、受限网络和标准研发环境里都能以更低成本落地

## 上游项目

本项目以上游官方仓库为基准：

- 上游地址：`https://github.com/QwenLM/qwen-code`
- 上游 npm 包：`@qwen-code/qwen-code`

本仓库的定位不是替代上游，而是围绕上游 `qwen-code` 做容器化、交付封装和现场使用优化。

## 致敬与遵从

向 `QwenLM/qwen-code` 官方项目致敬。

本仓库遵循以下原则：

- 尽量跟随上游官方项目的使用方式和行为语义
- 容器内直接安装和运行上游官方 `qwen-code` CLI
- 仅在部署、运行时注入、镜像分发和现场交付层做增强
- 许可证与上游保持一致，采用 Apache-2.0
- 保留对上游项目来源的明确说明

容器的最终用户入口参数是通用 OpenAI 兼容接口变量，而不是固定供应商变量：

- `LLM_API_BASE`
- `LLM_API_KEY`
- `LLM_MODEL`
- 可选：`LLM_PROVIDER_NAME`

## 在线分发

本项目已接入 GHCR 发布流程。版本发布后，最终用户可以直接拉取镜像，而不必先下载离线包。

示例：

```bash
docker pull ghcr.io/wzfukui/qwen-code-dev-container:latest
```

或拉取固定版本：

```bash
docker pull ghcr.io/wzfukui/qwen-code-dev-container:0.13.2
```

## 项目目标

- 在容器内直接运行 `qwen`
- 支持挂载外部开发目录到 `/workspace`
- 支持通过任意 OpenAI 兼容接口接入模型
- 预装常用 Python 研发组件、数据库客户端、Kafka 组件和 `fastmcp`
- 提供可复用的构建脚本、部署手册、使用手册和组件清单

## 一致化原则

这里说的“一致化遵从”，本仓库当前按以下边界处理：

- `qwen` CLI 本体来自上游官方 npm 包
- 运行入口仍然遵循上游的 `settings.json` 模型配置机制
- 本仓库新增的只是容器入口变量到 `settings.json` 的转换层
- 不修改上游协议栈，不替换上游 CLI 的核心行为
- 最终用户如需回到原生上游方式，仍可直接使用标准 `settings.json`

## 当前版本

- 项目交付版本：`0.13.2`
- `qwen-code`: `0.13.0`
- `Python`: `3.13`
- `Node.js`: `24`

## 已验证模型

以下模型已经通过容器内 `qwen -p` 冒烟验证：

- `qwen3-30b-a3b-instruct-2507`
- `deepseek-v3`
- `qwen3.5-35b-a3b`

## 文档分工

- [FIELD_USAGE.md](./FIELD_USAGE.md)
  现场使用文件，重点讲怎么拿到镜像包后 `load`、启动、运行
- [BUILD.md](./BUILD.md)
  构建文件，面向开发者和交付人员，重点讲怎么从源码构建和导出镜像
- [PYTHON_COMPONENTS.md](./PYTHON_COMPONENTS.md)
  Python 组件清单
- [RELEASE.md](./RELEASE.md)
  GitHub Release 发布方式和综合包建议

## 一线用户入口

如果你是现场使用者，请优先看 [FIELD_USAGE.md](./FIELD_USAGE.md)。

最短路径如下：

```bash
docker pull ghcr.io/wzfukui/qwen-code-dev-container:0.13.2
docker run -it --rm \
  -e LLM_API_BASE=https://your-openai-compatible-endpoint/v1 \
  -e LLM_API_KEY=你的Key \
  -e LLM_MODEL=你的模型名 \
  -v /data/project:/workspace \
  -v /data/qwen-home:/root/.qwen \
  ghcr.io/wzfukui/qwen-code-dev-container:0.13.2
```

容器内执行：

```bash
qwen
```

## 开发者入口

如果你是开发者或交付打包人员，请看 [BUILD.md](./BUILD.md)。

## Release 建议

镜像包不应进入 Git 仓库，建议作为 GitHub Release 附件发布。具体做法见 [RELEASE.md](./RELEASE.md)。

## 许可证

本仓库许可证与上游保持一致，使用 Apache-2.0。详见 [LICENSE](./LICENSE) 和 [NOTICE](./NOTICE)。

## GHCR 发布说明

仓库已包含 GitHub Actions 工作流：

- 打 `v*` 标签时自动构建并推送到 `ghcr.io/wzfukui/qwen-code-dev-container`
- 默认输出标签：
  - `latest`
  - `0.13.2`
  - `0.13`
- GitHub Actions 已显式启用 Node 24 运行模式，提前规避 Node 20 弃用影响

如果首次推送后包默认不是公开可见，需要在 GitHub 的 Package 页面手工调整为 `public`。

仓库里的 DashScope 相关配置仅用于构建后的标准化验证，不代表最终用户必须使用 DashScope。
