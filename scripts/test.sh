top_dir=$1
plugin_name=$2
test_file=$3

if [[ -z $test_file ]]; then
    test_target="PlenaryBustedDirectory tests { 'minimal_init', 'keep_going' }"
else
    test_target="PlenaryBustedFile $test_file"
fi

# run neovim { headless mode / add runtimepath / run plugin / run test }
find . -type f | entr -c nvim --headless \
    -c "set rtp+=$top_dir" \
    -c "runtime $plugin_name/**/*.{vim,lua}" \
    -c "runtime $plugin_name/tests/minimal_init.lua" -c "$test_target"
