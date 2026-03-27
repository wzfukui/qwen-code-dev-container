FROM docker.m.daocloud.io/library/node:24-bookworm-slim AS node_runtime

FROM python:3.13-slim-bookworm

ARG QWEN_CODE_VERSION=0.13.0
ARG HTTP_PROXY
ARG HTTPS_PROXY
ARG NO_PROXY

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    WORKSPACE=/workspace

COPY --from=node_runtime /usr/local/ /usr/local/

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        bash \
        ca-certificates \
        curl \
        default-mysql-client \
        git \
        jq \
        kcat \
        less \
        openssh-client \
        postgresql-client \
        procps \
        psmisc \
        ripgrep \
        rsync \
        tini \
        unzip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt /tmp/requirements.txt

RUN export http_proxy="${HTTP_PROXY}" https_proxy="${HTTPS_PROXY}" no_proxy="${NO_PROXY}" \
    && python -m pip install --upgrade pip setuptools wheel uv \
    && python -m pip install --no-cache-dir -r /tmp/requirements.txt \
    && npm install -g "@qwen-code/qwen-code@${QWEN_CODE_VERSION}" \
    && npm cache clean --force \
    && rm -rf /root/.npm /tmp/requirements.txt

RUN mkdir -p /opt/qwen-dev /root/.qwen "${WORKSPACE}"

COPY qwen-settings.template.json /opt/qwen-dev/qwen-settings.template.json
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
COPY scripts/model-smoke-test.sh /opt/qwen-dev/model-smoke-test.sh

RUN chmod +x /usr/local/bin/entrypoint.sh /opt/qwen-dev/model-smoke-test.sh

WORKDIR /workspace
ENTRYPOINT ["/usr/bin/tini", "--", "/usr/local/bin/entrypoint.sh"]
CMD ["bash", "-l"]
