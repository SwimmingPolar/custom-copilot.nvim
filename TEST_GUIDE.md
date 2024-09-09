# Testing Guide

Some testing examples using Plenary.nvim

# A simple test

This tests demonstrates a describe block that contains two tests defined with it blocks, the describe block also contains a before_each call that gets called before each test.

```lua
describe("some basics", function()

local bello = function(boo)
return "bello " .. boo
end

local bounter

before_each(function()
bounter = 0
end)

it("some test", function()
bounter = 100
assert.equals("bello Brian", bello("Brian"))
end)

it("some other test", function()
assert.equals(0, bounter)
end)
end)
```

The test some test checks that a functions output is as expected based on the input. The second test some other test checks that the variable bounter is reset for each test (as defined in the before_each block).

# Running tests

Run the test using :PlenaryBustedFile <file>.

```vim
" Run the test in the current buffer
:PlenaryBustedFile %
" Run all tests in the directory "tests/plenary/"
:PlenaryBustedDirectory tests/plenary/
```

Or you can run tests in headless mode to see output in terminal:

# run all tests in terminal

```bash
cd plenary.nvim
nvim --headless -c 'PlenaryBustedDirectory tests'
```

# mocking with luassert

Plenary.nvim comes bundled with luassert a library that's built to extend the built-int assertions... but it also comes with stubs, mocks and spies!

Sometimes it's useful to test functions that have nvim api function calls within them, take for example the following example of a simple module that creates a new buffer and opens in it in a split.

module.lua

```lua
local M = {}

function M.realistic_func()
local buf = vim.api.nvim_create_buf(false, true)
vim.api.nvim_command("sbuffer " .. buf)
end

return M
```

The following is an example of completely mocking a module, and another of just stubbing a single function within a module. In this case the module is vim.api, with an aim of giving an example of a unit test (fully mocked) and an integration test... details in the comments.

module.lua

```lua
-- import the luassert.mock module
local mock = require('luassert.mock')
local stub = require('luassert.stub')

describe("example", function()
-- instance of module to be tested
local testModule = require('example.module')
-- mocked instance of api to interact with

describe("realistic_func", function()
it("Should make expected calls to api, fully mocked", function()
-- mock the vim.api
local api = mock(vim.api, true)

      -- set expectation when mocked api call made
      api.nvim_create_buf.returns(5)

      testModule.realistic_func()

      -- assert api was called with expcted values
      assert.stub(api.nvim_create_buf).was_called_with(false, true)
      -- assert api was called with set expectation
      assert.stub(api.nvim_command).was_called_with("sbuffer 5")

      -- revert api back to it's former glory
      mock.revert(api)
    end)

    it("Should mock single api call", function()
      -- capture some number of windows and buffers before
      -- running our function
      local buf_count = #vim.api.nvim_list_bufs()
      local win_count = #vim.api.nvim_list_wins()
      -- stub a single function in the api
      stub(vim.api, "nvim_command")

      testModule.realistic_func()

      -- capture some details after running out function
      local after_buf_count = #vim.api.nvim_list_bufs()
      local after_win_count = #vim.api.nvim_list_wins()

      -- why 3 not two? NO IDEA! The point is we mocked
      -- nvim_commad and there is only a single window
      assert.equals(3, buf_count)
      assert.equals(4, after_buf_count)

      -- WOOPIE!
      assert.equals(1, win_count)
      assert.equals(1, after_win_count)
    end)

end)
end)
```

To test this in your ~/.config/nvim configuration, try the suggested file structure:

```lua
lua/example/module.lua
lua/spec/example/module_spec.lua
```

# Asynchronous testing

Tests run in a coroutine, which can be yielded and resumed. This can be used to test code that uses asynchronous Neovim functionalities. For example, this can be done inside a test:

```lua
local co = coroutine.running()
vim.defer_fn(function()
coroutine.resume(co)
end, 1000)
--The test will reach here immediately.
coroutine.yield()
--The test will only reach here after one second, when the deferred function runs.
```

# Asserts

| Assertion Method          | Description                                         | Example                                                 |
| ------------------------- | --------------------------------------------------- | ------------------------------------------------------- |
| `assert.is_true()`        | Checks if a value is boolean true                   | `assert.is_true(true)`                                  |
| `assert.is_false()`       | Checks if a value is boolean false                  | `assert.is_false(false)`                                |
| `assert.is_truthy()`      | Checks if a value is truthy (not false and not nil) | `assert.is_truthy("Yes")`                               |
| `assert.is_falsy()`       | Checks if a value is falsy (false or nil)           | `assert.is_falsy(nil)`                                  |
| `assert.are.equal()`      | Checks if two values are equal                      | `assert.are.equal(1, 1)`                                |
| `assert.are.same()`       | Checks if two values are similar (deep compare)     | `assert.are.same({ name = "Jack" }, { name = "Jack" })` |
| `assert.has_error()`      | Checks if a function throws an error                | `assert.has_error(function() error("Error") end)`       |
| `assert.has_no.errors()`  | Checks if a function doesn't throw an error         | `assert.has_no.errors(function() end)`                  |
| `assert.is_not_true()`    | Checks if a value is not boolean true               | `assert.is_not_true("Yes")`                             |
| `assert.is_not_false()`   | Checks if a value is not boolean false              | `assert.is_not_false(nil)`                              |
| `assert.are_not.equals()` | Checks if two values are not equal                  | `assert.are_not.equals(1, "1")`                         |
| `assert.is_string()`      | Checks if a value is a string                       | `assert.is_string("test")`                              |
| `assert.is_not_string()`  | Checks if a value is not a string                   | `assert.is_not_string(123)`                             |
| `assert.is_number()`      | Checks if a value is a number                       | `assert.is_number(123)`                                 |
| `assert.is_not_number()`  | Checks if a value is not a number                   | `assert.is_not_number("test")`                          |
| `assert.is_table()`       | Checks if a value is a table                        | `assert.is_table({})`                                   |
| `assert.is_not_table()`   | Checks if a value is not a table                    | `assert.is_not_table("test")`                           |
| `assert.is_nil()`         | Checks if a value is nil                            | `assert.is_nil(nil)`                                    |
| `assert.is_not_nil()`     | Checks if a value is not nil                        | `assert.is_not_nil("test")`                             |

## Basics

### Assert methods

```lua
assert = require("luassert")
assert.is_not.equals(1, 2)
assert.are_not.same({ a = 1 }, { b = 2 })
assert.True(true)
assert.is.True(true)
assert.is_true(true)
assert.is_not.True(false)
assert.is.Not.True(false)
assert.is_not_true(false)
assert.are.equal(1, 1)
assert.has.errors(function() error("this should fail") end)
```

### Assert lua table

```lua
local assert = require 'luassert'
local arr = { "one", "two", "three" }
assert.array(arr).has.no.holes() -- checks the array to not contain holes --> passes
assert.array(arr).has.no.holes(4) -- sets explicit length to 4 --> fails
```

### Spying

```lua
local assert = require 'luassert'
local match = require 'luassert.match'
local spy = require 'luassert.spy'

local s = spy.new(function() end)
s('foo')
s(1)
s({}, 'foo')
assert.spy(s).was.called*with(match.*) -- arg1 is anything
assert.spy(s).was.called_with(match.is_string()) -- arg1 is a string
assert.spy(s).was.called_with(match.is_number()) -- arg1 is a number
assert.spy(s).was.called_with(match.is_not_true()) -- arg1 is not true
assert.spy(s).was.called_with(match.is_table(), match.is_string()) -- arg1 is a table, arg2 is a string
assert.spy(s).was.called_with(match.has_match('.oo')) -- arg1 contains pattern ".oo"
assert.spy(s).was.called_with({}, 'foo') -- you can still match without using matchers
```

## Snapshot

```lua
describe("Showing use of snapshots", function()
local snapshot

before_each(function()
snapshot = assert:snapshot()
end)

after_each(function()
snapshot:revert()
end)

it("does some test", function()
-- spies or stubs registered here, parameters changed, or formatters added
-- will be undone in the after_each() handler.
end)

end)
```

```lua
assert:set_parameter("my_param_name", 1)
local s = assert:snapshot()
assert:set_parameter("my_param_name", 2)
s:revert()
assert.are.equal(1, assert:get_parameter("my_param_name"))
```
