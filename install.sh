#!/usr/bin/env bash
set -e

VERSION_INPUT="${VERSION:-}"

OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
ARCH="$(uname -m)"

case "$ARCH" in
  x86_64) ARCH="x86_64" ;;
  aarch64 | arm64) ARCH="aarch64" ;;
  *) echo "Unsupported architecture: $ARCH" && exit 1 ;;
esac

if [[ -z "$VERSION_INPUT" ]]; then
  VERSION=$(curl -s https://ziglang.org/download/index.json | \
              jq -r 'keys 
                | map(select(.!="master")) 
                | sort_by(. | split(".") 
                | map(tonumber)) 
                | reverse 
                | .[0]
              ')
elif [[ "$VERSION_INPUT" == "dev" || "$VERSION_INPUT" == "master" ]]; then
  VERSION="master"
else
  VERSION="$VERSION_INPUT"
fi

PACKAGES_DIR="$HOME/zig"
sudo mkdir -p "$PACKAGES_DIR"

export PATH="$PACKAGES_DIR:$PATH"

if [[ "$VERSION" == "master" ]]; then
  URL=$(curl -s https://ziglang.org/download/index.json \
    | jq -r ".master.\"${ARCH}-${OS}\".tarball")
else
  URL=$(curl -s https://ziglang.org/download/index.json \
    | jq -r ".\"$VERSION\".\"${ARCH}-${OS}\".tarball")
fi

# echo "Downloading Zig $VERSION for $ARCH-$OS from $URL"
curl -fsSL "$URL" | sudo tar xJC "$PACKAGES_DIR" --strip-components=1

echo "$PACKAGES_DIR" >> $GITHUB_PATH
# echo "Zig $VERSION installed successfully."

# zig version || true

