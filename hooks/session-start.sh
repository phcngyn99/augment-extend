#!/usr/bin/env bash
# Wrapper for superpowers session-start hook (Unix)
exec bash "$(dirname "$0")/session-start" "$@"
