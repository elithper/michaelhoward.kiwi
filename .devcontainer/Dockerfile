FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04
RUN apt update && export DEBIAN_FRONTEND=noninteractive \
    && apt install -y --no-install-recommends \
    jq \
    tree \
    fzf \
    ripgrep \
    htop \
    bat \
    fd-find \
    aspell \
    && apt-get autoremove -y && apt-get clean -y

COPY additional-packages/*.sh /tmp/additional-packages/

RUN cd /tmp/additional-packages && \
    /bin/bash helix.sh && \
    /bin/bash broot.sh && \
    /bin/bash zellij.sh && \
    /bin/bash marksman.sh && \
    /bin/bash lazygit.sh && \
    rm -rf /tmp/*

USER vscode
RUN mkdir -p ~/.local/bin && \
    ln -s $(which fdfind) ~/.local/bin/fd && \
    ln -s $(which batcat) ~/.local/bin/bat

RUN broot --print-shell-function bash >> ~/.bashrc && \
    broot --set-install-state installed
