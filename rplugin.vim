" perl plugins


" python3 plugins
call remote#host#RegisterPlugin('python3', '/Users/swimmingpolar/Projects/custom-copilot.nvim/rplugin/python3/_augroup', [
      \ {'sync': v:false, 'name': 'CallLuaFunctionFromPython', 'type': 'function', 'opts': {}},
      \ {'sync': v:true, 'name': 'VimEnter', 'type': 'autocmd', 'opts': {'pattern': '*', 'eval': 'expand("<afile>")'}},
      \ {'sync': v:true, 'name': 'CallLuaFunction', 'type': 'function', 'opts': {}},
     \ ])
call remote#host#RegisterPlugin('python3', '/Users/swimmingpolar/Projects/custom-copilot.nvim/rplugin/python3/_dev_mode', [
      \ {'sync': v:false, 'name': 'RunPlugin', 'type': 'command', 'opts': {'nargs': '*'}},
      \ {'sync': v:false, 'name': 'BufWritePost', 'type': 'autocmd', 'opts': {'pattern': '*.py'}},
      \ {'sync': v:false, 'name': 'ReloadPlugin', 'type': 'command', 'opts': {}},
     \ ])
call remote#host#RegisterPlugin('python3', '/Users/swimmingpolar/Projects/custom-copilot.nvim/rplugin/python3/_file_tree', [
      \ {'sync': v:false, 'name': 'GetFiles', 'type': 'function', 'opts': {}},
     \ ])
call remote#host#RegisterPlugin('python3', '/Users/swimmingpolar/Projects/custom-copilot.nvim/rplugin/python3/_print_data', [
      \ {'sync': v:false, 'name': 'PrintDeepNestedLuaTable', 'type': 'command', 'opts': {}},
      \ {'sync': v:false, 'name': 'PrintDict', 'type': 'command', 'opts': {}},
      \ {'sync': v:false, 'name': 'PrintStringList', 'type': 'command', 'opts': {}},
     \ ])


" ruby plugins


