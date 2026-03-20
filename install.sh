#!/bin/bash
set -u # Error if a variable is unset
set -e # Exit on error

# --- Configuration ---
NEW_VERSION="0.1.0"
REPO_URL="https://github.com/rustimate/rustimate/releases/download/v$NEW_VERSION"
INSTALL_DIR="/usr/local/bin"

# --- 1. Version Check ---
if command -v rustimate >/dev/null 2>&1; then
    CURRENT_VERSION=$(rustimate --version | awk '{print $2}')
    if [ "$CURRENT_VERSION" == "$NEW_VERSION" ]; then
        echo "Rustimate $CURRENT_VERSION is already installed and up to date."
        exit 0
    else
        echo "Upgrading Rustimate from $CURRENT_VERSION to $NEW_VERSION..."
    fi
else
    echo "Installing Rustimate v$NEW_VERSION..."
fi

# --- 2. Architecture Detection ---
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
  *) echo "Error: Unsupported OS: $OS"; exit 1 ;;
esac

FILENAME="rustimate-$PLATFORM-$TARGET.tar.gz"
URL="$REPO_URL/$FILENAME"

# --- 3. Sudo Validation (Brew Style) ---
# We validate sudo upfront so the user isn't interrupted later.
if [ ! -w "$INSTALL_DIR" ]; then
    echo "Checking for sudo access (which may request your password)..."
    if ! sudo -v; then
        echo "Error: Sudo access denied. Installation aborted."
        exit 1
    fi
    # Keep-alive: update existing sudo time stamp until script has finished
    while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
fi

# --- 4. Clean Download (No progress bars) ---
echo "Downloading $FILENAME..."
if ! curl -sSL "$URL" -o "/tmp/$FILENAME"; then
    echo "Error: Failed to download $FILENAME"
    exit 1
fi

# --- 5. Verify Checksum ---
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

# --- 6. Execution & Cleanup ---
tar -xzf "/tmp/$FILENAME" -C /tmp
chmod +x /tmp/rustimate

if [ ! -w "$INSTALL_DIR" ]; then
    sudo mv /tmp/rustimate "$INSTALL_DIR/rustimate"
else
    mv /tmp/rustimate "$INSTALL_DIR/rustimate"
fi

rm "/tmp/$FILENAME"
echo "Installation successful."
