local M = {}

---@generic T
---@param fn fun(...:T)
---@param timeout integer?
---@return fun(...:T):uv_timer_t
M.debounce = function(fn, timeout)
    timeout = timeout or 150
    local timer
    return function(...)
        local args = ...
        if timer then
            timer:stop()
            timer:close()
        end
        timer = vim.uv.new_timer()
        timer:start(timeout, 0, function()
            vim.schedule(function()
                fn(args)
                timer:close()
                timer = nil
            end)
        end)
        return timer
    end
end
_G.debounce = M.debounce

---@generic T
---@param fn fun(...:T)
---@param delay number?
---@return fun(...:T):uv_timer_t
M.throttle = function(fn, delay)
    delay = delay or 0
    local running = false
    local timer
    return function(...)
        local args = ...
        if not running then
            running = true
            timer = vim.uv.new_timer()
            timer:start(delay, 0, function()
                vim.schedule(function()
                    fn(args)
                    running = false
                    timer:close()
                    timer = nil
                end)
            end)
        end
        return timer
    end
end
_G.throttle = M.throttle

---@param fn fun()
---@param timeout integer?
---@return uv_timer_t
M.set_timeout = function(fn, timeout)
    timeout = timeout or 0
    local timer = vim.uv.new_timer()
    timer:start(timeout, 0, function()
        timer:close()
        fn()
    end)
    return timer
end
_G.set_timeout = M.set_timeout

---@param fn fun()
---@param interval integer?
---@return fun()
M.set_interval = function(fn, interval)
    interval = interval or 1000
    local timer = vim.uv.new_timer()
    timer:start(0, interval, function()
        fn()
    end)
    local clear_timer = function()
        timer:close()
    end
    return clear_timer
end
_G.set_timeout = M.set_timeout

---@param autocmds string|table<string>
---@param opts on_autocmd_opts
M.on_autocmd = function(autocmds, opts)
    local merged_opts = vim.tbl_deep_extend("force", {
        once = true,
        pattern = opts.pattern or "*",
    }, opts)

    autocmds = type(autocmds) == "string" and { autocmds } or autocmds
    vim.api.nvim_create_autocmd(autocmds, merged_opts)
end
_G.on_autocmd = M.on_autocmd

---pretty lua data: string, table, etc
---@generic T
---@param t T
---@param ident number?
M.tprint = function(t, ident)
    if t == nil or t == "" then
        return
    end

    ident = ident == nil and 0 or ident

    t = type(t) == "table" and t or { t }

    for k, v in pairs(t) do
        if type(v) == "table" then
            print(string.rep(" ", ident--[[@as number]]) .. k)
            M.tprint(v, ident + 2)
        else
            print(string.rep(" ", ident--[[@as number]]) .. k .. ": " .. tostring(v))
        end
    end
end

M.keys = vim.fn.keys
M.values = vim.fn.values

---return k,v table in a row
---
---local t ={}
---local k,v = get_k_v(t)
---@param t table
---@return table<string>,table<string>
M.get_k_v = function(t)
    return M.keys(t), M.values(t)
end

---@generic T
---@param t table<string>
---@return table<string>
M.Set = function(t)
    local set = {}
    local new_t = {}
    for _, i in ipairs(t) do
        if not set[i] then
            set[i] = true
            table.insert(new_t, i)
        end
    end
    return new_t
end

return M
