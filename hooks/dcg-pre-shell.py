#!/usr/bin/env python3
# dcg-augment-hook: PreToolUse hook for Augment CLI
# Adapted from ~/.cursor/hooks/dcg-pre-shell.py (dcg installer generated)
# Pipes Augment hook stdin to dcg, translates dcg output to Augment's
# hookSpecificOutput protocol. Fail-open on every error path.

import json
import os
import subprocess
import sys

DCG_BIN_FALLBACK = os.path.expanduser('~/.local/bin/dcg')


def emit(payload):
    sys.stdout.write(json.dumps(payload))
    sys.stdout.flush()


def allow():
    # Augment allow = empty stdout, exit 0
    pass


def deny(reason):
    # Augment deny = hookSpecificOutput JSON
    emit({
        "hookSpecificOutput": {
            "hookEventName": "PreToolUse",
            "permissionDecision": "deny",
            "permissionDecisionReason": reason,
        }
    })


def main():
    try:
        payload = json.load(sys.stdin)
    except Exception:
        allow()
        return 0

    # Only process shell-command tools. Augment uses "launch-process";
    # also accept "Bash" and other shell tool names dcg recognizes.
    tool_name = (payload.get("tool_name") or "").lower()
    shell_tools = {"launch-process", "bash", "powershell", "pwsh",
                   "run_shell_command", "run-shell-command",
                   "terminal", "run_terminal_cmd",
                   "runterminalcommand", "run_in_terminal", "runinterminal"}
    if tool_name and tool_name not in shell_tools:
        allow()
        return 0

    # Augment sends: {"tool_name":"launch-process","tool_input":{"command":"..."}}
    tool_input = payload.get("tool_input") or {}
    command = ""
    if isinstance(tool_input, dict):
        cmd_val = tool_input.get("command")
        if isinstance(cmd_val, str):
            command = cmd_val

    # Fallback: some tools put command at top level
    if not command:
        command = payload.get("command") or ""

    if not command:
        allow()
        return 0

    dcg_bin = os.environ.get("DCG_BIN") or DCG_BIN_FALLBACK

    # Pass Augment's format straight to dcg — it recognizes "launch-process"
    # natively (hook.rs detect_protocol). Using "Bash" also works.
    hook_input = {"tool_name": "Bash", "tool_input": {"command": command}}

    try:
        proc = subprocess.run(
            [dcg_bin],
            input=json.dumps(hook_input),
            text=True,
            capture_output=True,
        )
    except Exception:
        allow()
        return 0

    output = (proc.stdout or "").strip()
    if not output:
        allow()
        return 0

    try:
        dcg_out = json.loads(output)
    except Exception:
        allow()
        return 0

    decision = (
        dcg_out.get("hookSpecificOutput", {})
        .get("permissionDecision")
    )
    reason = (
        dcg_out.get("hookSpecificOutput", {})
        .get("permissionDecisionReason", "Blocked by dcg")
    )

    # Treat both "deny" (hard block) and "ask" (warn — recoverable but
    # still destructive) as blocks. Augment only supports "deny" in its
    # protocol; "ask" would silently allow dangerous commands through.
    if decision in ("deny", "ask"):
        sys.stderr.write(f"[dcg] BLOCKED: {reason}\n")
        deny(reason)
        return 0

    allow()
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
