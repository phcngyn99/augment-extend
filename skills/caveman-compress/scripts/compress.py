#!/usr/bin/env python3
"""
Caveman Compress — utility functions.

The actual compression is done inline by Augment Agent (no external API calls).
This module provides pre-flight checks and the write/backup logic.
"""

import re
from pathlib import Path

SENSITIVE_BASENAME_REGEX = re.compile(
    r"(?ix)^("
    r"\.env(\..+)?"
    r"|\.netrc"
    r"|credentials(\..+)?"
    r"|secrets?(\..+)?"
    r"|passwords?(\..+)?"
    r"|id_(rsa|dsa|ecdsa|ed25519)(\.pub)?"
    r"|authorized_keys"
    r"|known_hosts"
    r"|.*\.(pem|key|p12|pfx|crt|cer|jks|keystore|asc|gpg)"
    r")$"
)

SENSITIVE_PATH_COMPONENTS = frozenset({".ssh", ".aws", ".gnupg", ".kube", ".docker"})

SENSITIVE_NAME_TOKENS = (
    "secret", "credential", "password", "passwd",
    "apikey", "accesskey", "token", "privatekey",
)


def is_sensitive_path(filepath: Path) -> bool:
    """Heuristic denylist for files that must never be compressed."""
    name = filepath.name
    if SENSITIVE_BASENAME_REGEX.match(name):
        return True
    lowered_parts = {p.lower() for p in filepath.parts}
    if lowered_parts & SENSITIVE_PATH_COMPONENTS:
        return True
    lower = re.sub(r"[_\-\s.]", "", name.lower())
    return any(tok in lower for tok in SENSITIVE_NAME_TOKENS)


from .detect import should_compress


def preflight_check(filepath: Path) -> tuple[bool, str]:
    """Run pre-flight checks. Returns (ok, message)."""
    filepath = filepath.resolve()
    MAX_FILE_SIZE = 500_000

    if not filepath.exists():
        return False, f"File not found: {filepath}"
    if filepath.stat().st_size > MAX_FILE_SIZE:
        return False, f"File too large (max 500KB): {filepath}"
    if is_sensitive_path(filepath):
        return False, (
            f"Refusing: {filepath} looks sensitive "
            "(credentials, keys, secrets). Rename if false positive."
        )
    if not should_compress(filepath):
        return False, "Not natural language — skipping"

    backup_path = filepath.with_name(filepath.stem + ".original.md")
    if backup_path.exists():
        return False, f"Backup already exists: {backup_path}. Remove/rename first."

    return True, "Ready to compress"


def backup_and_write(filepath: Path, compressed_text: str) -> Path:
    """Back up original, write compressed. Returns backup path."""
    filepath = filepath.resolve()
    original_text = filepath.read_text(errors="ignore")
    backup_path = filepath.with_name(filepath.stem + ".original.md")
    backup_path.write_text(original_text)
    filepath.write_text(compressed_text)
    return backup_path


def restore_original(filepath: Path, backup_path: Path) -> None:
    """Restore original from backup on failure."""
    if backup_path.exists():
        filepath.write_text(backup_path.read_text(errors="ignore"))
        backup_path.unlink(missing_ok=True)
