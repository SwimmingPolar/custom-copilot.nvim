import os
from os.path import isfile
import pynvim
from pynvim import Nvim
from typing import Optional, Any
from .utils.logger import logger


@pynvim.plugin
class CustomCopilot(object):
    def __init__(self, nvim):
        self.nvim: Nvim = nvim
        self.model: Optional[str] = None
        self.filetype: Optional[str] = None
        self.bufnr: Optional[int] = None
        self.debounce_timer: Optional[Any] = None
        self.info, self.err, self.warn, self.debug = logger(self.nvim).values()

    def setup(self):
        self.nvim.out_write("rplugin setup\n")
        pass

    @pynvim.autocmd("VimEnter", pattern="*", sync=False)
    def on_vim_enter(self):
        self.setup()
