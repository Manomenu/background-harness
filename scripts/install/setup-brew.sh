#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/_lib.sh"

STEP="brew"

if has brew; then
    ok "$STEP"
    exit 0
fi

log "$STEP" "installing Homebrew for Linux..."
NONINTERACTIVE=1 /bin/bash -c \
    "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
done "$STEP"
