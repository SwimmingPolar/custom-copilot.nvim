local M = require("custom-copilot")
local assert = require("luassert")
local spy = require("luassert.spy")

describe("load module\t", function()
    it("require custom-copilots", function()
        assert.Not.is_nil(require("custom-copilot"))
    end)
end)

describe("reload\t\t", function()
    it("successful", function()
        -- plugin is already loaded
        assert.is.Not.Nil(package.loaded["custom-copilot"])

        -- schedule async reloading
        M.reload()

        -- plugin is blown
        assert.is.Nil(package.loaded["custom-copilot"])

        -- blocking wait
        vim.wait(0, function()
            -- util event loop is empty
            return vim.uv.run("nowait") ~= true
        end)

        -- should be not nil by this time
        assert.is.Not.Nil(package.loaded["custom-copilot"])
    end)
end)
