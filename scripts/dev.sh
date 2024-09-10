top_dir=$1
PLUGIN_NAME=$2

# run neovim { add runtimepath / run plugin }
nvim \
    -c "set rtp+=$top_dir" \
    -c "\"runtime $PLUGIN_NAME/**/*.{vim,lua}\""
