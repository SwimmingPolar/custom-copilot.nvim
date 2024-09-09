from pathlib import Path
from .utils import repomap


import pynvim
import pprint


# Plugin that assists easier developing the plugin
@pynvim.plugin
class FileTreeExample(object):
    def __init__(self, nvim):
        self.nvim = nvim

    @pynvim.function("GetFiles")
    def GetFiles(self, nargs):
        files = repomap.find_src_files(".") or []
        pp = pprint.PrettyPrinter(indent=4)
        self.nvim.out_write(pp.pformat(files))
