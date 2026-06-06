#!/usr/bin/env python3
"""
Caveman Compress CLI — preflight check only.

Actual compression is done inline by Augment Agent.
This CLI runs pre-flight checks and reports readiness.

Usage:
    python3 -m scripts preflight <filepath>
    python3 -m scripts validate <original> <compressed>
"""

import sys
from pathlib import Path

from .compress import preflight_check
from .detect import detect_file_type


def main():
    if len(sys.argv) < 2:
        print("Usage:")
        print("  python3 -m scripts preflight <filepath>")
        print("  python3 -m scripts validate <original> <compressed>")
        sys.exit(1)

    cmd = sys.argv[1]

    if cmd == "preflight":
        if len(sys.argv) != 3:
            print("Usage: python3 -m scripts preflight <filepath>")
            sys.exit(1)
        filepath = Path(sys.argv[2]).resolve()
        file_type = detect_file_type(filepath)
        print(f"type: {file_type}")
        ok, msg = preflight_check(filepath)
        print(f"ready: {ok}")
        print(f"message: {msg}")
        sys.exit(0 if ok else 1)

    elif cmd == "validate":
        if len(sys.argv) != 4:
            print("Usage: python3 -m scripts validate <original> <compressed>")
            sys.exit(1)
        from .validate import validate
        orig = Path(sys.argv[2]).resolve()
        comp = Path(sys.argv[3]).resolve()
        result = validate(orig, comp)
        print(f"valid: {result.is_valid}")
        for e in result.errors:
            print(f"  error: {e}")
        for w in result.warnings:
            print(f"  warning: {w}")
        sys.exit(0 if result.is_valid else 1)

    else:
        print(f"Unknown command: {cmd}")
        sys.exit(1)


if __name__ == "__main__":
    main()
