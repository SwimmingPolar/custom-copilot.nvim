# socalled-junior-dev.nvim

![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/ellisonleao/nvim-plugin-template/lint-test.yml?branch=main&style=for-the-badge)
![Lua](https://img.shields.io/badge/Made%20with%20Lua-blueviolet.svg?style=for-the-badge&logo=lua)

Many coding assistants, like Copilot, are often seen as junior developers, assigned repetitive and tedious tasks, thus the name.

### Intention

Just trying to use some tech stacks that is/has

- practical usage
- new language other than `javascript`
- integrate LLM with `DSPy`
- need actual logic

### Auto-complete

- [ ] Configuring system prompt

  1.  Get project repo map (using [aider repo map](https://github.com/paul-gauthier/aider/blob/f3cce95419e88f50351a70c14f6a9a319d92643b/aider/repomap.py#L30-L631))
  2.  Prepend as system prompt for [caching](https://platform.deepseek.com/api-docs/news/news0802/#how-to-use-deepseek-apis-caching-service) (should not change too often)

<br/>

- [ ] Get the current buffer context: **filename** / **content** / **cursor_position**

<br/>

- [ ] Use [DSPy](https://github.com/stanfordnlp/dspy?tab=readme-ov-file) to somehow improve prompting

### Pynvim

how-to-use pynvim

- A python class equivalent to single plugin for neovim (not sure, should check again)
- In a plugin(@pynvim.plugin), there should only be a single method per each decorators
- Method name can be anything

```py
@pynvim.plguin
    class TestPlugin(object):
        def __init__(self, nvim):
            self.nvim = nvim

    @pynvim.function("TestFunction", sync=True)
    def testfunction(self, args):

    @pynvim.command("TestCommand", nargs="*", range="")
    def testcommand(self, args, range):

    @pynvim.autocmd("BufEnter", pattern="*.py", eval='expand("<afile>")')
    def on_bufenter(self, filename):
```

#### Example

```py
import pynvim
import utils.repomap as repomap


@pynvim.plugin
class TestPlugin(object):
    def __init__(self, nvim):
        self.nvim = nvim
        self.nvim.api.set_keymap(
            "n",
            "<F12>",
            ":echo 'hello'<cr>",
            {"noremap": True, "silent": True},
        )

    def hello_world(self):
        self.nvim.out_write("Hello World\n")

    @pynvim.function("TestFunction", sync=True)
    def testfunction(self, args):
        return 3

    @pynvim.command("TestCommand", nargs="*", range="")
    def testcommand(self, args, range):
        file_list = repomap.find_src_files("./")
        files = "\n".join(file_list) if file_list else "no files found"
        self.nvim.out_write(files + "\n")

    @pynvim.autocmd("BufEnter", pattern="*.py", eval='expand("<afile>")')
    def on_bufenter(self, filename):
        pass
```

#### Setting key map

```py
self.nvim.api.set_keymap(
    "n",
    "<F12>",
    ":echo 'hello'<cr>",
    {"noremap": True, "silent": True},
)
```

#### Sending notification

`msg` is buffered until "\n" is sent

```py
self.nvim.out_write(msg + "\n")
```

#### Setting vim function (:lua vim.fn.TestFunction())

```py
    @pynvim.function("TestFunction", sync=True)
    def testfunction(self, args):
        return 3
```

#### Setting vim command (:TestCommand)

```py
    @pynvim.command("TestCommand", nargs="*", range="")
    def testcommand(self, args, range):
        file_list = repomap.find_src_files("./")
        files = "\n".join(file_list) if file_list else "no files found"
        self.nvim.out_write(files + "\n")
```

#### Setting autocmd

```py
    @pynvim.autocmd("BufEnter", pattern="*.py", eval='expand("<afile>")')
    def on_bufenter(self, filename):
        pass
```

#### Declaring method

utility functions and/or any functions, methods, etc.

```py
    def __init__(self, nvim):
    # ...

    """
    Normal method like utility functions, etc.
    """
    def hello_world(self):
        self.nvim.out_write("Hello World\n")

    # ...
    @pynvim.function("TestFunction", sync=True)
    def testfunction(self, args):
```
