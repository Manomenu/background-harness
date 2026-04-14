#!/usr/bin/env bash
set -euo pipefail
INSTALL_DIR="$(cd "$(dirname "$0")" && pwd)"

source "${INSTALL_DIR}/_lib.sh"

bash "${INSTALL_DIR}/setup-brew.sh"
bash "${INSTALL_DIR}/setup-incus.sh"
