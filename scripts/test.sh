top_dir=$1
PLUGIN_NAME=$2

# run neovim { headless mode / add runtimepath / run plugin / run test }
find . -type f | entr -c nvim --headless \
    -c "set rtp+=$top_dir" \
    -c "runtime $PLUGIN_NAME/**/*.{vim,lua}" \
    -c "runtime $PLUGIN_NAME/tests/minimal_init.lua" \
    -c "PlenaryBustedDirectory tests { 'minimal_init' }"
