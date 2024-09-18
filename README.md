# custom-copilot.nvim

![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/ellisonleao/nvim-plugin-template/lint-test.yml?branch=main&style=for-the-badge)
![Lua](https://img.shields.io/badge/Made%20with%20Lua-blueviolet.svg?style=for-the-badge&logo=lua)

### What is this?

In this plugin, I tried to get my hands on recent interests towards `llm`, `Neovim`, `lua`
and/or `python`. I wanted something that is:

- practical usage
- new language other than `javascript`
- integrate LLM with `DSPy`
- need actual logic

### Roadmap

1.  Get project repo map (using [aider repo map](https://github.com/paul-gauthier/aider/blob/f3cce95419e88f50351a70c14f6a9a319d92643b/aider/repomap.py#L30-L631))
2.  Prepend as system prompt for [caching](https://platform.deepseek.com/api-docs/news/news0802/#how-to-use-deepseek-apis-caching-service) (should not change too often)

<br/>

- [ ] Get the current buffer context: **filename** / **content** / **cursor_position**

<br/>

- [ ] Use [DSPy](https://github.com/stanfordnlp/dspy?tab=readme-ov-file) to somehow improve prompting

### References

[Neovim Best Practices](https://github.com/nvim-neorocks/nvim-best-practices?tab=readme-ov-file)

# Guide to building a Neovim plugin

1. [Getting Started](#getting-started)
   - [Introduction](#introduction)
     - [What is this about?](#what-is-this-about%3F)
   - [What is a Neovim plugin, anyway?](#what-is-a-neovim-plugin%2C-anyway%3F)
   - [Neovim Plugin: The Nitty-Gritty](#neovim-plugin%3A-the-nitty-gritty)
   - [The `runtimepath`: Roadmap](#the-runtimepath%3A-roadmap)
   - [Directory Structure: Blueprint](#directory-structure%3A-blueprint)
2. [Step-1) Adding a plugin to `runtimepath`](<#step-1)-adding-a-plugin-to-runtimepath>)
3. [Step-2) Plugin Structure](<#step-2)-plugin-structure>)
4. [Plugin Management](#plugin-management)
   - [Updating and Reloading Plugins](#updating-and-reloading-plugins)
   - [Multiple Plugins in a Single Directory](#multiple-plugins-in-a-single-directory)
5. [Basic Pynvim Usage](#basic-pynvim-usage)
   - [Creating Your First Plugin](#creating-your-first-plugin)
6. [Core Features](#core-features)
   - [Sending `Notifications`](#sending-notifications)
   - [Setting `Key Maps`](#setting-key-maps)
   - [Setting `Functions`](#setting-functions)
   - [Setting `Commands`](#setting-commands)
   - [Setting `Autocmd`](#setting-autocmd)
   - [Declaring `Methods`](#declaring-methods)
7. [Buffer and Window Operations](#buffer-and-window-operations)
   - [Creating and Managing Buffers](#creating-and-managing-buffers)
   - [Window Management](#window-management)
   - [Cursor Operations](#cursor-operations)
   - [Content Manipulation](#content-manipulation)
8. [Data Handling](#data-handling)
   - [Printing Python Data/Objects in Neovim](#printing-python-data%2Fobjects-in-neovim)
   - [Handling Lua Tables in Python](#handling-lua-tables-in-python)
9. [Error Handling and Debugging](#error-handling-and-debugging)
   - [Logging](#logging)
   - [Debugging Techniques](#debugging-techniques)
10. [Advanced Topics](#advanced-topics)
    - [Using tree-sitter](#using-tree-sitter)
    - [Implementing Ghost Text](#implementing-ghost-text)
    - [LocalLLM Provider](#localllm-provider)
11. [Best Practices and Tips](#best-practices-and-tips)
    - [Developing and Testing Strategies](#developing-and-testing-strategies)

## Getting Started

### Introduction

##### What is this about?

This guide offers a somewhat approachable docs for using `pynvim` to build Neovim plugins with python. With very scarce information, the only references I can refer was actually the plugins' repositories I was using. To find the right snippets for my purpose, I had to constantly find, prove, see and/or check whatever it takes to make sure this is it. `:h` helps a lot but with `pynvim`, it's similar but little bit different. I was hoping only if there is working example of each methods...

<small>The guide assumes some familiarity with Neovim and Python.</small>

---

##### What is a Neovim plugin, anyway?

While we're all familiar with using plugins, creating one can be a entirely different. Even if you know the basics, putting it all together can be challenging. Without clarity, they can seem fuzzy. A Neovim plugin is essentially:

- A chunk of Lua script
- A file containing Lua script
- A directory of Lua files

---

##### Neovim Plugin: The Nitty-Gritty

Sounds easy, right?" grasping the full concept isn't always straightforward. How does Neovim recognize this plugin? The answer lies in two key points:

1. Following a specific directory structure that Neovim recognizes
2. Providing the plugin's path to Neovim's environment variable, specifically the `runtimepath`

That's the gist of it.

---

##### The `runtimepath`: Roadmap

To tell Neovim aware of our plugin's location, we use the `runtimepath`. This is Neovim's environment variable that specifies where to look for configuration files, similar to how CLI commands search for executables in `/bin` directories. Plugin managers usually do this for you. This time, we'll be setting the path manually for our work-in-progress plugin.

---

##### Directory Structure: Blueprint

The directory structure may vary depending on different factors, but there's a basic template to follow. Building a Neovim plugin means adhering to their required structure – it's part of the game when you're working within Neovim's ecosystem.

---

### Step-1) Adding a plugin to `runtimepath`

To add a plugin, use your preferred plugin manager and point it to the local plugin path. For example, with `lazy.nvim`:

```lua
return {
    dir = "~/Projects/custom-copilot.nvim",
}
```

For this guide, we'll manually add our plugin path to runtimepath. We could use something like:

```bash
#!/bin/bash

top_dir=$1
PLUGIN_NAME=$2

# run Neovim { add runtimepath / run plugin }

# add the given dir to runtimepath  \
# set dev env (wheter it's dev, test, prod, etc)
# pynvim, obviously uses python, it's a path python binary in venv
# load the current plugin dir
nvim \
    -c "set rtp+=$top_dir" \
    -c "let g:is_dev = 1" \
    -c "let g:python3_host_prog = 'venv/bin/python3'" \
    -c "\"runtime $PLUGIN_NAME/**/*.{vim,lua}\""
```

I made a couple of scripts to make development smoother. What each line does is explained within each comments above the command. What actually sets `runtimepath` is `nvim -c "set rtp+=./"`. Looks pretty similar to `export PATH=/some/path;`.

### Step-2) Plugin Structure

The basic structure of a `pynvim` plugin:

```
custom-copilot.nvim/
├── plugin/
│   └── some_script.lua
├── lua/
│   ├── init.lua
│   └── custom-copilot/
│       ├── init.lua
│       └── util.lua
└── rplugin/
    └── python3/
        ├── __init__.py
        └── plugin.py
```

What makes this directory structure interesting is that the `lua` and `rplugin/python3` directory. As mentioned several times, Neovim recognizes this plugin have python based remote plugin. Deleting `rplugin` directory will simply make this plugin a pure Lua based plugin. It is worth noting that `rplugin/python3` directory is specific to python. Other plugins Neovim supports are also possible. Mainly, `nodejs` which will be put inside `rplugin/node`. Not sure what are possible but if you have provider that can run the script. I guess you can configure your way out!

<small>what is <b>entry point? </b>Function or location where the execution of a program begins.</small>

<small>what is <b>lazy loading? </b>Lua files within our plugin directory are considered lazyloaded.

- They aren't automatically executed when Neovim starts or when the plugin is loaded.
- They only run when explicitly require()d by other Lua code.

---

**plugin/ :**

Files here (both Lua and Vimscript) are automatically executed on Neovim startup.<br/>
This is often used as an entry point for immediate plugin setup.

**lua/** :

Modules here are only loaded when required.<br/>
They're not automatically run.

**init.lua** in the plugin root:

This is sometimes used as an entry point, but it's not automatically loaded by Neovim.

---

<details>
    <summary><b>what is vim functions, cmds and autocmds?</b></summary>
    <p>

- Vim Functions:

  - These are reusable pieces of code that can be called from other parts of your plugin or from Neovim itself.
  - They can take arguments and return values.
  - Typically used for encapsulating logic that you'll use multiple times.
  - Example: A function to format text or perform calculations.

---

- Vim Commands:

  - These are custom operations that users can execute directly in Neovim's command line.
  - They start with a capital letter and can be invoked with :YourCommandName.
  - Often used to expose plugin functionality to users.
  - Can take arguments passed by the user.
  - Example: A command to trigger a specific plugin action like :GenerateDocumentation.

---

- Vim Autocmds (Auto Commands):

  - These are event listeners that automatically execute code in response to specific Neovim events.
  - They allow your plugin to react to things happening in the editor.
  - Common events include opening a file, changing modes, or saving a buffer.
  - Example: Automatically formatting code when saving a file.

</p>
</details>

<details>
<summary><b>other directories</b></summary>
    <p>

- ftplugin/ directory:

  - Lua files here are loaded when a specific filetype is detected.
  - Used for filetype-specific settings and mappings.

---

- after/plugin/ directory:

  - Similar to plugin/, but loaded after all other plugins.
  - Useful for overriding settings from other plugins.

---

- autoload/ directory:
  - While primarily used for Vimscript, Lua files can also be placed here.
  - Functions in these files are loaded only when called.

</p>

</details>

<br/>
If step-2 is done, we can pretty much call it a plugin whether it is a directory or a single file.

## Plugin Management

### Updating and Reloading Plugins

Quoting from `remote-plugin.txt`:

> Just installing remote plugins to "rplugin/{host}" isn't enough for them to be
> automatically loaded when required. You must execute |:UpdateRemotePlugins|
> every time a remote plugin is installed, updated, or deleted.

We can easily infer when we should exactly run `UpdateRemotePlugins` by investigating `rplugin.vim` manifest file. Any code changes to this manifest, should you update the manifest. If python code you changed do not affect manifest, restarting Neovim is enough to see the change.

<small>**manifest** is a list entries or items of certain things. In this case, features we implemented are listed</small>

**So, what changes to manifest?**

- Arguments when calling decorators
- Parameters in methods

It is generated by `Neovim` when you run `:UpdateRemotePlugins`. The location for this manifest is
usually is Neovim's data directory which you can see by `:echo stdpath('data')`

---

### Multiple Plugins in a Single Directory

For multiple plugins, use this recommended structure:

```
custom-copilot.nvim/
└── rplugin/
    └── python3/
        ├── augroup/
        │   ├── __init__.py
        │   └── augroup.py
        ├── dev_mode/
        │   ├── __init__.py
        │   └── dev_mode.py
        ├── file_tree/
        │   ├── __init__.py
        │   └── file_tree.py
        └── print_table/
            ├── __init__.py
            └── print_table.py
```

Note: Empty `__init__.py` files are necessary as Python treats directories with `__init__.py` as packages. If you want deeper understanding for how these structures are interpreted into manifest, checkout `rplugin.vim` manifest somewhere(`~/.local/share/nvim/rplugin.vim`) in your file system.

## Basic Pynvim Usage

### Creating Your First Plugin

The below code block shows pretty much all about pynvim itself. What I needed was examples of code
actually working. And below are those examples I found along the way. If friendly reminders,

- vim functions are programmatically callable from scripts
- vim commands are something we use within Neovim. It is almost like vim functions
- vim autocmds are similar to events. It calls callbacks when the condition is met.

Here's a basic example of a Pynvim plugin:

```python
import pynvim

@pynvim.plugin
class TestPlugin(object):

    def __init__(self, nvim):
        self.nvim = nvim

    @pynvim.function('TestFunction', sync=True)
    def testfunction(self, args):
        return 3

    @pynvim.command('TestCommand', nargs='*', range='')
    def testcommand(self, args, range):
        self.nvim.current.line = ('Command with args: {}, range: {}'
                                  .format(args, range))

    @pynvim.autocmd('BufEnter', pattern='*.py', eval='expand("<afile>")', sync=True)
    def on_bufenter(self, filename):
        self.nvim.out_write('testplugin is in ' + filename + '\n')
```

Note: There can only be a single binding for the same `autocmd`. To be exact, `autocmd` with exactly
same parameters are not possible. But if it's not. It will probably be working. You will see why if
you checkout `rplugin.vim` manifest.

```bash
" python3 plugins
call remote#host#RegisterPlugin('python3', '/Users/swimmingpolar/Projects/custom-copilot.nvim/rplugin/python3/custom_copilot', [
      \ {'sync': v:false, 'name': 'VimEnter', 'type': 'autocmd', 'opts': {'pattern': '*'}},
      \ {'sync': v:true, 'name': 'SomeFunction', 'type': 'function', 'opts': {}},
     \ ])
```

What happens here is that each python function declared are mapped into Neovim that we can use it
and access it via:

- `:lua vim.fn.TestFunction` for `@pynvim.function`
- `:TestCommand` for `@pynvim.function`
- `@pynvim.autocmd` are executed accordingly by given options.

python function names can be any valid identifier. Once you have your lua converted `functions` and
`commands`, the rest are same as normal python script! You might wanna call injected python functions and commands from lua script.

Remember, in vim/Neovim, you can always `:h {anything}` to check out the docs and its faster!

## Core Features

### Sending `Notifications`

```python
# Method #1
self.nvim.out_write(msg + "\n")
```

Note: `msg` is buffered until a newline is appended.

```python
# Method #2
log_level = self.nvim.command_output("=vim.log.levels.INFO")
self.nvim.api.notify("hello", int(log_level), {})
```

```python
# Method #3
self.nvim.exec_lua(
    """
        vim.notify("vim_notify")
        vim.api.nvim_notify("nvim_notify", vim.log.levels.INFO, {})
        -- check out `messages` to see the result
        vim.print("vim_print")
    """
)

```

### Setting `Key Maps`

```python
# method 1
self.nvim.api.set_keymap(
    "n",
    "<F12>",
    ":echo 'hello'<cr>",
    {"noremap": True, "silent": True},
)
```

```python
# method 2
self.nvim.exec_lua(
    """
        vim.keymap.set('n', '<leader>try', function() print("key set to leader-try") end)
        vim.keymap.set('n', '<leader>tra', "<cmd>echo 'key set to leader-tra'<cr>")
        vim.api.nvim_set_keymap('n', '<leader>trb', ":lua print 'key set to leader-trb'<cr>", {})
        -- <NL> indicates new line = <cr>
        vim.api.nvim_set_keymap('n', '<leader>trc', ":=print 'key set to leader-trc'<NL>", {})
    """
)
```

Which one to use is up to you. I'm just showing you what are possible and you can adapt the method
on other things as well. But for keymap, personally I would use `vim.keymap.set` since it can run a
function at the same time.

### Setting `Functions`

Setting up a Vim function from a plugin:

```python
@pynvim.function("TestFunction", sync=True)
def testfunction(self, args):
    return 3
```

How to call from Neovim:

```vim
:lua vim.fn.TestFunction()
```

### Setting `Commands`

```python
@pynvim.command("TestCommand", nargs="*", range="")
def testcommand(self, args, range):
    file_list = repomap.find_src_files("./")
    files = "\n".join(file_list) if file_list else "no files found"
    self.nvim.out_write(files + "\n")
```

How to call from Neovim:

```vim
:TestCommand
```

### Setting `Autocmd`

```python
@pynvim.autocmd("BufEnter", pattern="*.py", eval='expand("<afile>")')
def on_bufenter(self, filename):
    pass
```

### Declaring `Methods`

You can declare utility functions and other methods as normal Python class methods:

```python
def hello_world(self):
    self.nvim.out_write("Hello World\n")
```

## Buffer and Window Operations

### Creating and Managing Buffers

(This section needs to be filled with information about creating, deleting, and splitting buffers)

### Window Management

(This section needs to be filled with information about managing Neovim windows)

### Cursor Operations

(This section needs to be filled with information about getting the current cursor position and content under the cursor)

### Content Manipulation

(This section needs to be filled with information about replacing content in buffers)

## Data Handling

### Printing Python Data/Objects in Neovim

When passing data from Python to Lua, a Python dict is equivalent to a Lua table. Here are some examples of printing Python data in Neovim:

```python
@pynvim.plugin
class Print(object):
    def __init__(self, nvim):
        self.nvim = nvim

    @pynvim.command("PrintDict")
    def print_dict(self, nargs="*"):
        python_data_type = {"a": [1, 2, 3], "b": {"x": 10, "y": 20}}
        pp = pprint.PrettyPrinter(indent=4)
        result = pp.pformat(python_data_type) + "\n"
        self.nvim.out_write(result)

    @pynvim.command("PrintStringList")
    def print_string_list(self, nargs="*"):
        string_list = ["hello", "world", "from", "python"]
        self.nvim.out_write(repr(string_list) + "\n")
        self.nvim.out_write(str(string_list) + "\n")
        self.nvim.out_write(", ".join(string_list) + "\n")
        self.nvim.out_write("\n".join(string_list) + "\n")
```

### Handling Lua Tables in Python

When passing Lua tables to Python, use `vim.print` instead of `print`:

```python
@pynvim.command("PrintLuaTable")
def print_lua_table(self):
    result = self.nvim.command_output(":lua vim.print(vim.api)")
    self.nvim.out_write(result + "\n")
```

## Error Handling and Debugging

### Logging

### Debugging Techniques

## Advanced Topics

### Using tree-sitter

### Implementing Ghost Text

### LocalLLM Provider

## Best Practices and Tips

### Developing and Testing Strategies

I saw many docs and videos implement there own way of speeding up dev cycle. Can't say it's brilliant but is shows what I was trying to achieve. Though, not really using it anymore. But the concept here is obvious.

```python
@pynvim.plugin
class Dev(object):
    def __init__(self, nvim):
        self.nvim = nvim
        self.nvim.api.set_keymap(
            "n", "<F5>", ":UpdateRemotePlugins<cr>", {"noremap": True, "silent": True})
        self.nvim.api.set_keymap(
            "n", "<F10>", ":RunPlugin<cr>", {"noremap": True, "silent": True},
        )

    @pynvim.autocmd("BufWritePost", pattern="*.py")
    def update_plugin_on_buf_write(self):
        self.nvim.command("UpdateRemotePlugins")

    @pynvim.command("RunPlugin", nargs="*")
    def run_plugin(self, args):
        self.nvim.out_write("plugin ran!\n")
```

**dev mode**
What I did instead was to create dedicated scripts that runs `dev` mode and `test` mode. In dev
mode, whenever I exit Neovim, it will bring up a new instance. Instantly, refreshing the editor
without manually opening it again and again.

```bash
top_dir=$1
PLUGIN_NAME=$2

# add the current dir to runtimepath  \
# change rplugin.vim manifest path to ./rplugin.vim \
# load the current plugin dir
nvim \
    -c "set rtp+=$top_dir" \
    -c "let g:is_dev = 1" \
    -c "let g:python3_host_prog = 'venv/bin/python3'" \
    -c "let \$NVIM_RPLUGIN_MANIFEST = '$top_dir/rplugin.vim'" \
    -c "\"runtime $PLUGIN_NAME/**/*.{vim,lua}\"" # add the current dir to runtimepath \
```

**test mode**
In test mode which is a lot similar to `dev` mode, but it runs the test in isolated Neovim instances
and watches out for any changes. If any change happens, it will run the test. Each mode has a global
variable `vim.g.is_dev` or `vim.g.is_test` that you can use to conditionally adjust the flow.

```bash
top_dir=$1
plugin_name=$2
test_file=$3

if [[ -z $test_file ]]; then
    test_target="PlenaryBustedDirectory tests { 'minimal_init', 'keep_going' }"
else
    test_target="PlenaryBustedFile $test_file"
fi

# run Neovim { headless mode / add runtimepath / run plugin / run test }
find . -type f | entr -c nvim --headless \
    -c "set rtp+=$top_dir" \
    -c "let g:is_test = 1" \
    -c "runtime $plugin_name/**/*.{vim,lua}" \
    -c "runtime $plugin_name/tests/minimal_init.lua" -c "$test_target"
```

**how to use scripts**

```bash
./run.sh ./scripts/dev.sh
./run.sh ./scripts/test.sh
```
