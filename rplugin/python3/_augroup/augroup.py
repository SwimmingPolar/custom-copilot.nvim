# Adding proper autocmd group
# To add autocmd group to the current version of `pynvim`,
# 1. Modify internal API (there is not much to do anyway)
# 2. Use another wrapper like below

import pynvim


@pynvim.plugin
class PynvimAuGroup(object):
    def __init__(self, nvim):
        self.nvim = nvim
        self.augroup_name = "PynvimAuGroup"
        self.augroup = None

    @pynvim.function("CallLuaFunction", sync=True)
    def setup(self, args):
        # Create the augroup
        self.augroup = self.nvim.api.create_augroup(self.augroup_name, {"clear": True})

        args1 = "args1"
        args2 = "args2"
        data = {"some_key": "some_value"}

        # Is it memory safe?
        # Not sure this kind of function calling by eval is okay.
        self.nvim.exec_lua(
            # This should be called as callback,
            # If args is saved here, whatever is referenced hereafter will be closed over?
            """
                local args = {...}
                vim.print(args)
                function _G.greeting_hello_world()
                end
            """,
            args1,
            args2,
            data,
        )

        # Create the autocmd with the augroup
        self.nvim.api.create_autocmd(
            "BufEnter",
            {
                "group": self.augroup,
                "pattern": "*.py",
                "callback": "v:lua.greeting_hello_world",
            },
        )

    @pynvim.autocmd("VimEnter", pattern="*", eval='expand("<afile>")', sync=True)
    def on_vimenter(self, filename):
        # Call the setup function when Vim starts
        self.setup([])

    # @pynvim.function("CallLuaFunctionFromPython")
    # def hello_world(self, args):
    # self.nvim.out_write("Hello, World!\n")
