require("plenary.busted")
require("plenary.async").tests.add_to_env()
local utils = require("custom-copilot.utils")

-- general purpose for testing
_G.assert = require("luassert")
_G.spy = require("luassert.spy")
_G.stub = require("luassert.stub")
_G.mock = require("luassert.mock")
_G.match = require("luassert.match")

-- async test
_G.async = require("plenary.async")
_G.async_test = require("plenary.async.tests")
_G.async_util = require("plenary.async.util")
_G.async_sleep = _G.async_util.sleep
-- _G.future = require("plenary.async_lib.async").future
_G.a.future = require("plenary.async_lib.async").future
_G.a.await = require("plenary.async_lib.async").await
_G.a.await_all = require("plenary.async_lib.async").await_all

-- misc
_G.tprint = utils.tprint
