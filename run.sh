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
# run neovim in headless mode / with the current path added to runtime path / execute runtime
run_dev() {
    while true; do
        nvim \
            -c ":lua vim.opt.rtp:append(\"$top_dir\")" \
            -c "runtime $PLUGIN_NAME/**/*.{vim,lua}"
        if [ $? -eq 1 ]; then
            break
        fi
    done
}
# test mode
run_test() {
    find . -type f | entr -c nvim --headless \
        -c ":lua vim.opt.rtp:append(\"$top_dir\")" \
        -c "runtime $PLUGIN_NAME/**/*.{vim,lua}" \
        -c "runtime $PLUGIN_NAME/tests/minimal_init.lua" \
        -c "PlenaryBustedDirectory tests"
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
