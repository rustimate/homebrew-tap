#!/bin/bash
set -e

VERSION="0.1.0"
REPO_URL="https://github.com/rustimate/rustimate/releases/download/v$VERSION"
INSTALL_DIR="/usr/local/bin"

OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
ARCH="$(uname -m)"

case "$OS" in
  darwin)
    PLATFORM="macos"
    if [ "$ARCH" = "arm64" ]; then 
        TARGET="aarch64"; EXPECTED_SHA="4766082da53780ab5cc044b3ef5d6c312363745568d6f5d30602ec22fc8f95fa"
    else 
        TARGET="x86_64";  EXPECTED_SHA="fcb8d4b9b83e83a83096382e4b9d5212e3ff3cd9420aaf7fe3aa1ffb1cad697e"
    fi
    ;;
  linux)
    PLATFORM="linux"
    if [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "arm64" ]; then 
        TARGET="aarch64"; EXPECTED_SHA="49edf839df77237c676fa920ce068ca750547c7f3f9122eccb6f035fdc4018d7 "
    else 
        TARGET="x86_64";  EXPECTED_SHA="38840c27bf04c6411ccfb714fb7965d9a8a7c8c1b91df091f6fd91a210247034"
    fi
    ;;
  *) echo "Error: Unsupported OS: $OS"; exit 1 ;;
esac

FILENAME="rustimate-$PLATFORM-$TARGET.tar.gz"
URL="$REPO_URL/$FILENAME"

if [ ! -w "$INSTALL_DIR" ]; then
    echo "This installation requires administrator privileges."
    if ! sudo -v; then
        echo "Error: Sudo validation failed."
        exit 1
    fi
fi

echo "Downloading Rustimate $VERSION..."
curl -sSL "$URL" -o "/tmp/$FILENAME"

echo "Verifying checksum..."
if [ "$OS" = "darwin" ]; then
    ACTUAL_SHA=$(shasum -a 256 "/tmp/$FILENAME" | awk '{print $1}')
else
    ACTUAL_SHA=$(sha256sum "/tmp/$FILENAME" | awk '{print $1}')
fi

if [ "$ACTUAL_SHA" != "$EXPECTED_SHA" ]; then
    echo "Error: Checksum mismatch!"
    exit 1
fi

tar -xzf "/tmp/$FILENAME" -C /tmp
chmod +x /tmp/rustimate

if [ ! -w "$INSTALL_DIR" ]; then
    sudo mv /tmp/rustimate "$INSTALL_DIR/rustimate"
else
    mv /tmp/rustimate "$INSTALL_DIR/rustimate"
fi

rm "/tmp/$FILENAME"
echo "Rustimate installed successfully."
echo " "
echo "run rustimate --help"
echo " "
