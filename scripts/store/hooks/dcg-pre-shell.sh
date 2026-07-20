#!/usr/bin/env bash
# Wrapper: dcg-pre-shell.py for Augment CLI PreToolUse hook
# Reason: Augment hook runner only supports .sh/.cmd/.bat/.ps1 extensions
# (see https://docs.augmentcode.com/cli/hooks). Direct .py command caused
# spawn bash ENOENT. This wrapper dynamically resolves python3 via PATH
# (/usr/bin/env) and execs the real hook, inheriting stdin/stdout/stderr.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PY_HOOK="${SCRIPT_DIR}/dcg-pre-shell.py"

# Dynamic python3 lookup: prefer $DCG_PYTHON, else PATH lookup via env.
# /usr/bin/env is guaranteed-present on macOS; python3 resolved at runtime.
if [ -n "${DCG_PYTHON:-}" ] && command -v "${DCG_PYTHON}" >/dev/null 2>&1; then
  PY_BIN="${DCG_PYTHON}"
else
  PY_BIN="python3"
fi

# Exec replaces this process with python — stdin/stdout/stderr flow through.
exec "${PY_BIN}" "${PY_HOOK}"
