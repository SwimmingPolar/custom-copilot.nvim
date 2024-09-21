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

-- On dev, reload plugin and update remote plugin manifest on file change
M.reload = function()
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

    -- load the plugin
    vim.defer_fn(function()
        -- update remote plugin manifest
        local ok, err = pcall(function()
            vim.cmd("UpdateRemotePlugins")
        end)
        if not ok then
            vim.notify(tostring(err) or "error updating remote plugin", vim.log.levels.ERROR, {})
        end

        -- reload the plugin
        ok, err = pcall(function()
            require("custom-copilot").setup()
        end)
        if not ok then
            vim.notify(tostring(err) or "error calling require and setup on the plugin", vim.log.levels.ERROR, {})
        end
    end, 0)
end

M.init = function()
    -- if dev mode, add refreshing logic
    if vim.g.is_dev == 1 then
        local group = vim.api.nvim_create_augroup("custom-copilot-augroup", { clear = true })
        vim.api.nvim_create_autocmd("BufWritePost", {
            group = group,
            pattern = { "*.py", "*.lua" },
            callback = M.reload,
        })
    end
end

--- @param opts? CustomCopilotOpts | fun(): CustomCopilotOpts
M.setup = function(opts)
    -- call init func for extra works if needed
    M.init()
    vim.print("hello")

    -- logics

    -- merge default opts and user opts
    opts = vim.tbl_deep_extend("force", M.opts, type(opts) == "function" and opts() or (opts or {}))
end

return M
