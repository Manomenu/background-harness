#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/_lib.sh"

STEP="incus"

# --- install binary ---
if has incus; then
    ok "$STEP/install"
else
    log "$STEP" "installing..."
    . /etc/os-release
    case "$ID" in
        ubuntu|debian)
            sudo mkdir -p /etc/apt/keyrings
            curl -fsSL https://pkgs.zabbly.com/key.asc \
                | sudo gpg --dearmor -o /etc/apt/keyrings/zabbly.gpg

            ARCH="$(dpkg --print-architecture)"
            REPO="https://pkgs.zabbly.com/incus/stable"
            echo "deb [arch=${ARCH} signed-by=/etc/apt/keyrings/zabbly.gpg] ${REPO} ${VERSION_CODENAME} main" \
                | sudo tee /etc/apt/sources.list.d/zabbly-incus-stable.list

            sudo apt-get update -q
            sudo apt-get install -y incus
            ;;
        fedora|rhel|centos)
            sudo dnf install -y incus
            ;;
        *)
            echo "[${STEP}] unsupported distro: ${ID}" >&2
            exit 1
            ;;
    esac
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
    incus admin init --minimal
fi

done "$STEP"
