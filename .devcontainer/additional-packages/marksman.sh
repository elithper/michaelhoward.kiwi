#!/usr/bin/env bash

echo "Installing Marksman"

set -eux;
dpkgArch="$(dpkg --print-architecture)";
case "${dpkgArch##*-}" in
    amd64) target='linux-x64' ;;
    *) echo >&2 "unsupported architecture: ${dpkgArch}"; exit 1 ;;
esac;

url="https://api.github.com/repos/artempyanykh/marksman/releases/latest"
curl -L -o marksman `curl -s "$url" | jq -r '.assets[].browser_download_url' | grep "$target"`
chmod +x marksman
mv marksman /usr/local/bin
