#!/bin/bash
set -e

# Configuration
INSTALL_DIR="/usr/local/bin"
CONFIG_DIR="$HOME/.rustimate"

echo "Uninstalling Rustimate..."

if [ -f "$INSTALL_DIR/rustimate" ]; then
    echo "Removing binary from $INSTALL_DIR..."
    if [ ! -w "$INSTALL_DIR" ]; then
        sudo rm "$INSTALL_DIR/rustimate"
    else
        rm "$INSTALL_DIR/rustimate"
    fi
else
    echo "Binary not found in $INSTALL_DIR"
fi

if [ -d "$CONFIG_DIR" ]; then
    echo "Removing configuration directory: $CONFIG_DIR"
    rm -rf "$CONFIG_DIR"
else
    echo "No configuration directory found at $CONFIG_DIR."
fi

echo "Rustimate has been completely removed from your system."
echo ""
echo "Note: This script did not remove any generated media or source files."
echo "You may manually delete your project files if they are no longer needed:"
echo "  - .rsl files (Source)"
echo "  - .mp4 files (Rendered output)"
echo ""
