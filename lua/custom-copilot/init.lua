local M = {}

--- @class CustomCopilotOpts
--- @field model string
--- @field filetype string[]
--- @field ignore_filetype string[]

-- opts should be a table (will be merged with parent
-- specs), return a table (replaces parent specs) or should
-- change a table. The table will be passed to the
-- Plugin.config() function
--- @type CustomCopilotOpts
M.opts = {
    model = "gpt-3.5-turbo",
    filetype = { "*" },
    ignore_filetype = {},
}

M.reload = function()
    vim.notify("reloading plugin")
    local package_found = false
    -- unload the plugin
    for k in pairs(package.loaded) do
        if string.match(k, "^custom%-copilot$") then
            package.loaded[k] = nil
            package_found = true
        end
    end

    -- if no package was found, do nothing
    if not package_found then
        return
    end

    -- update remote plugin manifest
    vim.cmd("UpdateRemotePlugins")

    -- load the plugin
    vim.defer_fn(function()
        -- only if it's found and unloaded
        -- reload the plugin
        local ok, err = pcall(function()
            require("custom-copilot")
        end)

        if ok and not err then
            vim.notify("custom-copilot reloaded")
        elseif err then
            vim.notify("failed to reload plugin" .. vim.log.levels.ERROR)
        end
    end, 0)
end

M.init = function()
    -- if dev mode, add refreshing logic
    local group = vim.api.nvim_create_augroup("custom-copilot-augroup", { clear = true })
    vim.api.nvim_create_autocmd("BufWritePost", {
        group = group,
        pattern = { "*.py", "*.lua" },
        callback = function()
            vim.print("autocmd!")
        end,
    })
end

--- @param opts? CustomCopilotOpts | fun(): CustomCopilotOpts
M.setup = function(opts)
    M.init()
    opts = vim.tbl_deep_extend("force", M.opts, type(opts) == "function" and opts() or (opts or {}))
end

return M
