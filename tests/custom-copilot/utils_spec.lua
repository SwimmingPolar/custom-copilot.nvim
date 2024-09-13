local utils = require("custom-copilot.utils")

local assert = require("luassert")
local spy = require("luassert.spy")

describe("module loading\t", function()
    it("require custom-copilot.utils", function()
        assert.Not.is_nil(require("custom-copilot.utils"))
    end)
end)

describe("debounce\t", function()
    -- when using async feature, must use `a.it` or else,
    -- face a buffer overflow, says the doc.
    it("debounced func called", function()
        local cb = spy.new(function() end)
        local done = false

        local debounced = utils.debounce(function()
            cb()
            done = true
        end)
        debounced()
        debounced()
        debounced()

        -- make the test synchronously
        vim.uv.run("once")

        -- debounce wraps callback with vim scheduler
        -- so, need to wait for some time
        vim.wait(5000, function()
            return done == true
        end, 100)

        assert.spy(cb).was_called(1)
    end)
end)

describe("throttle\t", function()
    it("throttled func called", function()
        local cb = spy.new(function() end)
        local done = false

        --- assume throttled callback takes roughly 250ms
        local throttled = utils.throttle(function()
            cb()
            -- some process
            vim.wait(1000)
            -- is done
            done = true
            -- get back to main thread/event loop
            vim.uv.stop()
        end)
        --probably ignored
        throttled()
        throttled()
        throttled()
        throttled()
        throttled()
        vim.uv.run("once")
        -- debounce wraps callback with vim scheduler
        -- so, need to wait for some time
        vim.wait(5000, function()
            return done == true
        end, 100)

        done = false
        -- probably will run
        throttled()
        vim.uv.run("once")
        vim.wait(5000, function()
            return done == true
        end, 100)

        assert.spy(cb).was_called(2)
    end)
end)

describe("set_timeout\t", function()
    it("set timeout call back called", function()
        local cb = spy.new(function() end)
        local done = false

        utils.set_timeout(function()
            cb()
            done = true
        end)
        vim.uv.run("once")

        vim.wait(5000, function()
            return done == true
        end, 100)

        assert.spy(cb).was_called(1)
    end)
end)

describe("set_interval\t", function()
    it("set interval call back called more than twice", function()
        local cb = spy.new(function() end)

        local clear_interval = utils.set_interval(function()
            if #cb.calls < 3 then
                cb()
            elseif #cb.calls == 3 then
                vim.uv.stop()
            end
        end, 100)

        vim.uv.run("default")

        clear_interval()

        -- I know it's been called only 3 times
        assert.spy(cb).was.called(3)
    end)
end)

describe("on_autocmd\t", function()
    it("autocmd registered successfully", function()
        local cb = spy.new(function() end)

        utils.on_autocmd("BufEnter", {
            pattern = { "*" },
            callback = function()
                cb()
            end,
        })

        assert.spy(cb).was.called(0)
        local bufnr = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_set_current_buf(bufnr)
        assert.spy(cb).was.called(1)
    end)

    it("autocmd is called only once", function()
        local cb = spy.new(function() end)

        utils.on_autocmd("BufEnter", {
            pattern = { "*" },
            callback = function()
                cb()
            end,
        })

        assert.spy(cb).was.called(0)
        local bufnr1 = vim.api.nvim_create_buf(false, true)
        local bufnr2 = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_set_current_buf(bufnr1)
        vim.api.nvim_set_current_buf(1)
        assert.spy(cb).was.called(1)

        vim.api.nvim_set_current_buf(bufnr2)
        vim.api.nvim_set_current_buf(bufnr1)
        assert.spy(cb).was.called(1)
    end)

    it("autocmd is called multiple times", function()
        local cb = spy.new(function() end)

        utils.on_autocmd("BufEnter", {
            pattern = { "*" },
            callback = function()
                cb()
            end,
            once = false,
        })

        assert.spy(cb).was.called(0)
        local bufnr1 = vim.api.nvim_create_buf(false, true)
        local bufnr2 = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_set_current_buf(bufnr1)
        assert.spy(cb).was.called(1)

        vim.api.nvim_set_current_buf(bufnr2)
        vim.api.nvim_set_current_buf(bufnr1)
        assert.spy(cb).was.called(3)
    end)
end)
