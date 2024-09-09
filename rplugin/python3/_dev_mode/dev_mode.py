import pynvim


# There is no actual production or development mode.
# It exists just to aid my development process.
# Plugin that assists easier developing the plugin
@pynvim.plugin
class Dev(object):
    def __init__(self, nvim):
        self.nvim = nvim
        # update remote plugins manifesto
        self.nvim.api.set_keymap(
            "n", "<F5>", ":UpdateRemotePlugins<cr>", {"noremap": True, "silent": True}
        )

        # run the plugin
        self.nvim.api.set_keymap(
            "n",
            "<F10>",
            ":RunPlugin<cr>",
            {"noremap": True, "silent": True},
        )

    # update remote plugins manifesto when saving
    @pynvim.autocmd("BufWritePost", pattern="*.py")
    def update_plugin_on_buf_write(self):
        self.nvim.command("UpdateRemotePlugins")

    @pynvim.command("RunPlugin", nargs="*")
    def run_plugin(self, args):
        # What you wanna run
        self.nvim.out_write("plugin ran!\n")

    @pynvim.command("ReloadPlugin")
    def update_remote_plugins(self):
        self.nvim.exec_lua(
            """
            function reload()
                for k in pairs(package.loaded) do
                    if k:match('^')
                end
            end
        """
        )
