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

M.init = function() end

M.reload = function()
    -- unload the plugin
    for k in pairs(package.loaded) do
        if string.match(k, "^custom%-copilot$") then
            package.loaded[k] = nil
        end
    end

    vim.defer_fn(function()
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

--- @param opts? CustomCopilotOpts | fun(): CustomCopilotOpts
M.setup = function(opts)
    -- import and export LLM powered completion sort method
    M.llm_sort = require("custom-copilot.sort")

    vim.print("setup")

    opts = vim.tbl_deep_extend("force", M.opts, type(opts) == "function" and opts() or opts)
end

return M
