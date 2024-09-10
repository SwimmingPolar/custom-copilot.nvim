#!/bin/bash

PLUGIN_NAME="custom-copilot.nvim"

# usage string
Usage() {
    echo "Usage: $0 {mode}; mode=dev/test"
}

# get execution mode
mode=$1
if [[ -z $mode ]]; then
    Usage
    exit 1
fi

# get project root dir
top_dir="$(git rev-parse --show-toplevel 2>/dev/null)"
if [[ -z $top_dir ]]; then
    echo "Git Repo not found"
    exit 1
fi

# dev mode
run_dev() {
    while true; do
        # Why need this? If we run/open Neovim in the script, the same
        # configuration will be ran even after CHANGING the content of this `run.sh`,
        # because the process that is running this infinite loop has already been
        # saved to the memory with the content before the modification.
        bash ./scripts/dev.sh "$top_dir" "$PLUGIN_NAME"

        if [ $? -eq 1 ]; then
            break
        fi
    done
}
# test mode
run_test() {
    # Actually, don't need this as separate file unlike dev.sh.
    # I assume `entr` will load options properly?
    bash ./scripts/test.sh "$top_dir" "$PLUGIN_NAME"
}

# execute appropriate command per mode
case "$mode" in
"dev")
    run_dev
    ;;
"test")
    run_test
    ;;
*)
    echo ""
    Usage
    exit 1
    ;;
esac
