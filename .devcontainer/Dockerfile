# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.137.0/containers/go/.devcontainer/base.Dockerfile
ARG VARIANT="1"
FROM mcr.microsoft.com/vscode/devcontainers/go:0-${VARIANT}

ENV H_VERSION "0.105.0"

RUN mkdir -p /usr/local/src
RUN  \
    arch=$(uname -m); \
    if [[ $arch == aarch64 ]]; then \
    cd /usr/local/src && curl -L https://github.com/gohugoio/hugo/releases/download/v${H_VERSION}/hugo_${H_VERSION}_linux-arm64.tar.gz | tar -xz; \
    else \
    cd /usr/local/src && curl -L https://github.com/gohugoio/hugo/releases/download/v${H_VERSION}/hugo_${H_VERSION}_linux-64bit.tar.gz | tar -xz; \
    fi;
RUN cp /usr/local/src/hugo /usr/local/bin/hugo

EXPOSE 1313
