import pynvim


@pynvim.plugin
class CustomCopilot:
    def __init__(self, nvim):
        self.nvim = nvim
        self.model = None
        self.filetype = None
        self.bufnr = None
        self.debounce_timer = None
