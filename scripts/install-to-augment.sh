#!/bin/bash

set -e

echo "Install to Augment..."
echo ""

# Check auggie CLI installed
if ! command -v auggie &> /dev/null; then
    echo "ERROR: auggie CLI not found. Install first."
    echo "Visit: https://www.augmentcode.com"
    exit 1
fi

# Check rsync installed
if ! command -v rsync &> /dev/null; then
    echo "ERROR: rsync not found. Install: brew install rsync (macOS) or apt install rsync (Linux)"
    exit 1
fi

echo "Auggie CLI found."

# Get Augment config dir
AUGMENT_DIR="$HOME/.augment"

# Check if we're in repo root
if [ ! -f "scripts/setup-symlinks.sh" ]; then
    echo "ERROR: Run from repo root (where scripts/setup-symlinks.sh exists)"
    exit 1
fi

# Confirm overwrite
echo ""
echo "This will copy repo contents to: $AUGMENT_DIR"
echo "Existing files will be overwritten."
read -p "Continue? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Cancelled."
    exit 0
fi

echo ""
echo "Copy to $AUGMENT_DIR..."

# Create Augment dir if not exists
mkdir -p "$AUGMENT_DIR"

# Copy using rsync, include .git for submodule support
rsync -av \
    --exclude='binaries' \
    --exclude='sessions' \
    --exclude='task-storage' \
    --exclude='session.json' \
    --exclude='settings.json' \
    --exclude='.auggie.json' \
    --exclude='prompt-history.jsonl' \
    --exclude='checkpoint-documents' \
    --exclude='untruncated' \
    --exclude='.codegraph' \
    ./ "$AUGMENT_DIR/"

echo "Copy complete."
echo ""

# Setup settings.json from template (ARM64 uses arm-template, else normal template)
echo "Setup settings.json from template..."
cd "$AUGMENT_DIR"
ARCH="$(uname -m)"
if [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "arm64" ]; then
    if [ -f "settings.json.arm-template" ]; then
        cp settings.json.arm-template settings.json
        # Replace <USER> placeholder with current user's home
        sed -i "s|/home/<USER>/|$HOME/|g" settings.json
        echo "settings.json created from ARM template (arch=$ARCH)."
        echo "NOTE: chromium version dir (e.g. chromium-1228) is pinned to Playwright 1.61."
        echo "      If Playwright upgraded, run 'npx playwright install chromium' and update"
        echo "      --executable-path in settings.json to match the new version dir."
    elif [ -f "settings.json.template" ]; then
        echo "WARN: settings.json.arm-template not found. Falling back to normal template (may not work on ARM64)."
        cp settings.json.template settings.json
    else
        echo "WARN: no settings.json template found."
    fi
else
    if [ -f "settings.json.template" ]; then
        cp settings.json.template settings.json
        echo "settings.json created from normal template (arch=$ARCH)."
    else
        echo "WARN: settings.json.template not found."
    fi
fi
echo ""

# Run setup-symlinks.sh from Augment dir
echo "Run setup-symlinks.sh..."
bash scripts/setup-symlinks.sh

echo ""
echo "Install complete!"
echo "Augment config at: $AUGMENT_DIR"
echo ""
