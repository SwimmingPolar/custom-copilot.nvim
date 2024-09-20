import re
from typing import Callable, Dict, Literal
from pynvim import Nvim

LOGLEVELS = Literal["INFO", "ERROR", "WARN", "DEBUG"]
LogLevel = Literal["info", "err", "warn", "debug"]


def logger(nvim: Nvim) -> Dict[LogLevel, Callable[[str], None]]:
    log_levels_str = nvim.command_output(":=vim.log.levels")
    notify = nvim.api.notify

    # parse and get log levels
    log_levels = {}
    pattern = r"(\w+)\s*=\s*(\d+)"
    matches = re.findall(pattern, log_levels_str)
    log_levels = {level: int(level_id) for level, level_id in matches}

    def log_factory(level: LOGLEVELS) -> Callable[[str], None]:
        return lambda msg: notify(msg, log_levels[level], {})

    return {
        "info": log_factory("INFO"),
        "err": log_factory("ERROR"),
        "warn": log_factory("WARN"),
        "debug": log_factory("DEBUG"),
    }
