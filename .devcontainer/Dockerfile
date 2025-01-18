FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04
RUN apt update && export DEBIAN_FRONTEND=noninteractive \
    && apt install -y --no-install-recommends \
    jq \
    tree \
    fzf \
    ripgrep \
    htop \
    bat \
    && apt-get autoremove -y && apt-get clean -y

COPY additional-packages/*.sh /tmp/additional-packages/

RUN cd /tmp/additional-packages && \
    /bin/bash helix.sh && \
    /bin/bash broot.sh && \
    /bin/bash zellij.sh && \
    rm -rf /tmp/*
