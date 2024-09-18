import pynvim


@pynvim.plugin
class CustomCopilot(object):
    def __init__(self, nvim):
        self.nvim = nvim
        self.model = None
        self.filetype = None
        self.bufnr = None
        self.debounce_timer = None

    @pynvim.function("SomeFunction")
    def somefunc(self, nargs):
        self.nvim.out_write(nargs.join("\n") + "\n")

    def setup(self):
        self.nvim.exec_lua(
            """
                vim.keymap.set('n', '<leader>try', function() print("key set to leader-try") end)
                vim.keymap.set('n', '<leader>tra', "<cmd>echo 'key set to leader-tra'<cr>")
                vim.api.nvim_set_keymap('n', '<leader>trb', ":lua print 'key set to leader-trb'<cr>", {})
                -- <NL> indicates new line = <cr>
                vim.api.nvim_set_keymap('n', '<leader>trc', ":=print 'key set to leader-trc'<NL>", {})
            """
        )
        pass
        # log_level = self.nvim.command_output("=vim.log.levels.INFO")
        # log_level = self.nvim.command_output("lua vim.log.levels.INFO")
        # self.nvim.api.notify("hello", int(log_level), {})

    @pynvim.autocmd("VimEnter", pattern="*", sync=False)
    def on_vim_enter(self):
        self.setup()
