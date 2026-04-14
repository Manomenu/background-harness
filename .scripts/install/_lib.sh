#!/usr/bin/env bash
# Shared helpers for install scripts. Source this file, do not execute directly.
# Usage: source "$(dirname "$0")/_lib.sh"

set -euo pipefail

log()  { echo "[${1}] ${2}"; }
ok()   { log "${1}" "already installed, skipping"; }
finish() { log "${1}" "done"; }

# Returns 0 if command exists on PATH
has() { command -v "$1" &>/dev/null; }

# Returns 0 if the user is already in the given group
in_group() { groups "$USER" | grep -qw "$1"; }
