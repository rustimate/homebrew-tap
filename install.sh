#!/bin/bash
set -e

# --- Configuration ---
VERSION="0.1.0"
REPO_URL="https://github.com/rustimate/rustimate/releases/download/v$VERSION"
INSTALL_DIR="/usr/local/bin"

# --- Colors for the Veteran UI ---
BLUE='\033[0;34m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

printf "${BLUE}🚀 Installing Rustimate v$VERSION...${NC}\n"

# 1. Detect OS and ARCH
OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
ARCH="$(uname -m)"

case "$OS" in
  darwin)
    PLATFORM="macos"
    if [ "$ARCH" = "arm64" ]; then 
        TARGET="aarch64"; EXPECTED_SHA="fdcb1c1be43acc31532f8e6f2fdd5685a281d85ad17abcdd3f1bef8e3d56306a"
    else 
        TARGET="x86_64";  EXPECTED_SHA="3ee68694b62b6a9d076035a45bd0fbf70a57f94c76eee3d07c505a37c469593c"
    fi
    ;;
  linux)
    PLATFORM="linux"
    if [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "arm64" ]; then 
        TARGET="aarch64"; EXPECTED_SHA="8255a7597624b9d46b17ea0befe92eeb1fa037e8e019fbf2bd0b813c63240fe1"
    else 
        TARGET="x86_64";  EXPECTED_SHA="34a0822c99cda51566853183fa27cb049ce8f67cd9a0486ec83ae8725825904d"
    fi
    ;;
  *) printf "${RED}Unsupported OS: $OS${NC}\n"; exit 1 ;;
esac

FILENAME="rustimate-$PLATFORM-$TARGET.tar.gz"
URL="$REPO_URL/$FILENAME"

# 2. Download to Temp
printf "📥 Downloading $FILENAME...\n"
curl -L "$URL" -o "/tmp/$FILENAME"

# 3. Verify Checksum (The Veteran Way)
printf "🔍 Verifying checksum...\n"
if [ "$OS" = "darwin" ]; then
    ACTUAL_SHA=$(shasum -a 256 "/tmp/$FILENAME" | awk '{print $1}')
else
    ACTUAL_SHA=$(sha256sum "/tmp/$FILENAME" | awk '{print $1}')
fi

if [ "$ACTUAL_SHA" != "$EXPECTED_SHA" ]; then
    printf "${RED}❌ Checksum mismatch! Download may be corrupted.${NC}\n"
    exit 1
fi

# 4. Extract and Install
printf "🔧 Installing to $INSTALL_DIR...\n"
tar -xzf "/tmp/$FILENAME" -C /tmp
chmod +x /tmp/rustimate

# Handle permissions gracefully
if [ -w "$INSTALL_DIR" ]; then
    mv /tmp/rustimate "$INSTALL_DIR/rustimate"
else
    printf "${YELLOW}Requires sudo to move binary to $INSTALL_DIR${NC}\n"
    sudo mv /tmp/rustimate "$INSTALL_DIR/rustimate"
fi

printf "${GREEN}✅ Rustimate installed successfully!${NC}\n"
