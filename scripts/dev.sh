top_dir=$1
PLUGIN_NAME=$2

# set a path for manifest file
export NVIM_RPLUGIN_MANIFEST="$top_dir/rplugin.vim"

# add the current dir to runtimepath  \
# change rplugin.vim manifest path to ./rplugin.vim \
# load the current plugin dir
nvim \
    -c "set rtp+=$top_dir" \
    -c "let g:is_dev = 1" \
    -c "let g:python3_host_prog = 'venv/bin/python3'" \
    -c "\"runtime $PLUGIN_NAME/**/*.{vim,lua}\"" # add the current dir to runtimepath \
