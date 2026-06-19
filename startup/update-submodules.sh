#!/usr/bin/env bash

set -e

# Parse arguments
DRY_RUN=false
if [[ "$1" == "--dry-run" ]]; then
    DRY_RUN=true
fi

# Dry run mode - just show instruction
if [[ "$DRY_RUN" == true ]]; then
    echo "To update submodules run: $HOME/.augment/startup/update-submodules.sh"
    exit 0
fi

REPO_DIR="$HOME/.augment"
SUBMODULE_DIR="$REPO_DIR/submodule"

# Check if directory exists
if [[ ! -d "$SUBMODULE_DIR" ]]; then
    echo "Error: Directory $SUBMODULE_DIR does not exist"
    exit 1
fi

cd "$REPO_DIR"

# Arrays to track results
declare -a updated_modules
declare -a already_current_modules
declare -a failed_modules

echo "Updating submodules in $SUBMODULE_DIR..."
echo "----------------------------------------"

# Get list of submodules (only paths, not URLs)
submodules=$(git config --file .gitmodules --get-regexp '^submodule\..*\.path$' | awk '{ print $2 }')

# Process each submodule
for submodule_path in $submodules; do
    # Extract just the name
    submodule_name=$(basename "$submodule_path")

    echo ""
    echo "Processing: $submodule_name"

    # Get current commit
    before_commit=$(cd "$submodule_path" && git rev-parse HEAD 2>/dev/null || echo "unknown")

    # Update submodule to latest remote
    if git submodule update --remote "$submodule_path" > /dev/null 2>&1; then
        # Get new commit
        after_commit=$(cd "$submodule_path" && git rev-parse HEAD 2>/dev/null || echo "unknown")

        # Check if anything changed
        if [[ "$before_commit" == "$after_commit" ]]; then
            already_current_modules+=("$submodule_name")
            echo "✓ Already up to date"
        else
            # Get commit message of new version
            short_before="${before_commit:0:7}"
            short_after="${after_commit:0:7}"
            updated_modules+=("$submodule_name ($short_before → $short_after)")
            echo "✓ Updated: $short_before → $short_after"
        fi
    else
        failed_modules+=("$submodule_name")
        echo "✗ Failed to update"
    fi
done

# Summary
echo ""
echo "========================================"
echo "SUMMARY"
echo "========================================"

if [[ ${#updated_modules[@]} -gt 0 ]]; then
    echo ""
    echo "Updated (${#updated_modules[@]}):"
    for module in "${updated_modules[@]}"; do
        echo "  ✓ $module"
    done
fi

if [[ ${#already_current_modules[@]} -gt 0 ]]; then
    echo ""
    echo "Already up to date (${#already_current_modules[@]}):"
    for module in "${already_current_modules[@]}"; do
        echo "  - $module"
    done
fi

if [[ ${#failed_modules[@]} -gt 0 ]]; then
    echo ""
    echo "Failed (${#failed_modules[@]}):"
    for module in "${failed_modules[@]}"; do
        echo "  ✗ $module"
    done
fi

echo ""
echo "Total: $((${#updated_modules[@]} + ${#already_current_modules[@]} + ${#failed_modules[@]})) submodules processed"
