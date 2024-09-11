---a bunch of micro miscellaneous methods
local M = {}

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
        local line = string.rep(" ", ident--[[@as number]])
        if type(v) == "table" then
            line = string.rep(" ", ident--[[@as number]])
                .. k
                .. "(table): "
            print(line)
            M.tprint(v, ident + 2)
        else
            line = line .. ", " .. print(string.rep(" ", ident--[[@as number]]) .. k .. ": " .. tostring(v))
        end
    end
end

---return k,v table in a row
---
---local t ={}
---local k,v = get_k_v(t)
---@param t table
---@return table<string>,table<string>
M.get_k_v = function(t)
    local k, v = {}, {}

    for key, value in pairs(t) do
        table.insert(k, key)
        table.insert(v, value)
    end

    return k, v
end

---@generic T
---@param t table<string>
---@return table<string>
M.Set = function(t)
    local set = {}
    local new_t = {}
    for _, k in ipairs(t) do
        if not set[k] then
            set[k] = true
            table.insert(new_t, k)
        end
    end
    return new_t
end

return M
