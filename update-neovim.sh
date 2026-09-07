#!/bin/sh

set -e

INSTALL_DIR="/opt/nvim-linux-x86_64"
NVIM_BIN="${INSTALL_DIR}/bin/nvim"
ARCHIVE="/tmp/nvim-linux-x86_64.tar.gz"

FORCE_UPDATE=0

if [ "$1" = "--force" ]; then
    FORCE_UPDATE=1
elif [ -n "$1" ]; then
    echo "Usage: $0 [--force]"
    exit 1
fi

LATEST_VERSION=$(
  curl -fsSL https://api.github.com/repos/neovim/neovim/releases/latest \
    | grep '"tag_name":' \
    | sed -E 's/.*"([^"]+)".*/\1/'
)

if [ -z "$LATEST_VERSION" ]; then
    echo "ERROR: Failed to get the latest Neovim version."
    exit 1
fi

if [ -x "$NVIM_BIN" ]; then
    CURRENT_VERSION=$(
      "$NVIM_BIN" --version \
        | head -n 1 \
        | awk '{print $2}'
    )
else
    CURRENT_VERSION="not installed"
fi

echo "Current: $CURRENT_VERSION"
echo "Latest : $LATEST_VERSION"

if [ "$CURRENT_VERSION" = "$LATEST_VERSION" ] && [ "$FORCE_UPDATE" -eq 0 ]; then
    echo "Neovim is already up to date."
    exit 0
fi

if [ "$FORCE_UPDATE" -eq 1 ]; then
    echo "Force update enabled."
else
    echo "Update available: $CURRENT_VERSION -> $LATEST_VERSION"
fi

echo "Downloading Neovim..."

curl -fL \
  https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz \
  -o "$ARCHIVE"

echo "Installing Neovim..."

sudo rm -rf "$INSTALL_DIR"
sudo tar -C /opt -xzf "$ARCHIVE"

rm -f "$ARCHIVE"

sudo ln -sf "$NVIM_BIN" /usr/local/bin/nvim

echo ""
echo "Neovim installation completed."
echo ""

"$NVIM_BIN" --version | head -n 1

