#!/usr/bin/env bash

echo "Installing Lazygit"

set -eux;
dpkgArch="$(dpkg --print-architecture)";
case "${dpkgArch##*-}" in
    amd64) target='Linux_x86_64.tar.gz' ;;
    *) echo >&2 "unsupported architecture: ${dpkgArch}"; exit 1 ;;
esac;

url="https://api.github.com/repos/jesseduffield/lazygit/releases/latest"
curl -L -o lazygit.tar.gz `curl -s "$url" | jq -r '.assets[].browser_download_url' | grep "$target"`
tar -xf lazygit.tar.gz
chmod +x lazygit
mv lazygit /usr/local/bin
