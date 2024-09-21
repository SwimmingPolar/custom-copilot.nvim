-- For built-in tree-sitter
if vim.fn.has("nvim-0.7.0") ~= 1 then
    vim.api.nvim_err_writeln("custom-copilot.nvim requires at least nvim-0.7.0.")
end

if vim.g.loaded_custom_copilot == 1 then
    return
end
vim.g.loaded_custom_copilot = 1

local plugin_ok, plugin_load_err = pcall(function()
    require("custom-copilot").setup()
end)

-- Check if running on dev mode
if vim.g.is_dev == 1 then
    -- error while loading lua plugin
    if not plugin_ok then
        vim.print(plugin_load_err)
    end
end
