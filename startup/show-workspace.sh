#!/usr/bin/env bash

# AUGMENT_WORKSPACE_DIR is set by Auggie when startupScript runs
WORKSPACE="${AUGMENT_WORKSPACE_DIR:-$(pwd)}"
#echo "Current workspace: $WORKSPACE"

# Check if CodeGraph index exists
if [ -d "$WORKSPACE/.codegraph" ]; then
  echo "✓ CodeGraph: Ready at $WORKSPACE/.codegraph"
else
  echo "✗ CodeGraph: Not initialized. Run: codegraph init"
fi
