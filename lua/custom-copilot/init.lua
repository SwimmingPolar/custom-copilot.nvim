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

M.init = function()
    -- ts support requires at least nvim-0.7.0
    if vim.fn.has("nvim-0.7.0") ~= 1 then
        vim.api.nvim_err_writeln("Example.nvim requires at least nvim-0.7.0.")
    end
end

--- @param opts? CustomCopilotOpts | fun(): CustomCopilotOpts
M.setup = function(opts)
    opts = vim.tbl_deep_extend("force", M.opts, type(opts) == "function" and opts() or opts)
end

M.reload = function()
    -- unload the plugin
    for k in pairs(package.loaded) do
        if k:match("^custom-copilot") then
            -- package.loaded[k] = nil
            vim.print("@@@@@@@@@@@@@@@")
            vim.print(k)
            vim.print("@@@@@@@@@@@@@@@")
        else
            vim.print(k)
        end
    end

    -- reload the plugin
    -- local ok, err = pcall(function()
    --     require("")
    -- end)
end

return M
