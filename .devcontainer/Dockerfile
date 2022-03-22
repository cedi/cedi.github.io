# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.137.0/containers/go/.devcontainer/base.Dockerfile
ARG VARIANT="1"
ARG HUGO_VERSION="0.69.1"
FROM mcr.microsoft.com/vscode/devcontainers/go:0-${VARIANT}

ENV H_VERSION ${HUGO_VERSION}

RUN mkdir -p /usr/local/src \
    && cd /usr/local/src \
    && curl -L https://github.com/gohugoio/hugo/releases/download/v${H_VERSION}/hugo_${H_VERSION}_linux-64bit.tar.gz | tar -xz \
    && mv hugo /usr/local/bin/hugo

EXPOSE 1313
