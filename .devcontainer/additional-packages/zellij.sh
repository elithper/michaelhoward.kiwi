#!/usr/bin/env bash

echo "Installing Zellij"

set -eux;
dpkgArch="$(dpkg --print-architecture)";
case "${dpkgArch##*-}" in
    amd64) target='x86_64-unknown-linux-musl.tar.gz' ;;
    *) echo >&2 "unsupported architecture: ${dpkgArch}"; exit 1 ;;
esac;

url="https://api.github.com/repos/zellij-org/zellij/releases/latest"
curl -L -o zellij.tar.gz `curl -s "$url" | jq -r '.assets[].browser_download_url' | grep "$target"`
tar -xf zellij.tar.gz
chmod +x zellij
mv zellij /usr/local/bin
