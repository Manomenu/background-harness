#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/_lib.sh"

STEP="incus"

# --- install ---
if has incus; then
    ok "$STEP/install"
else
    log "$STEP" "installing..."
    sudo add-apt-repository -y universe &>/dev/null
    sudo apt-get update -q &>/dev/null
    sudo apt-get install -y incus &>/dev/null
    log "$STEP" "installed: $(incus --version)"
fi

# --- group membership ---
if in_group incus-admin; then
    ok "$STEP/group"
else
    log "$STEP" "adding '${USER}' to incus-admin group..."
    sudo usermod -aG incus-admin "$USER"
    log "$STEP" "NOTE: log out and back in (or run 'newgrp incus-admin') for group to take effect"
fi

# --- initialise ---
if incus storage list 2>/dev/null | grep -q "default"; then
    ok "$STEP/init"
else
    log "$STEP" "running initial setup..."
    incus admin init --minimal &>/dev/null
fi

finish "$STEP"
