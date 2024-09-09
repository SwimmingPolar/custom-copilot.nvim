-- For built-in tree-sitter
if vim.fn.has("nvim-0.7.0") ~= 1 then
    vim.api.nvim_err_writeln("custom-copilot.nvim requires at least nvim-0.7.0.")
end

if vim.g.loaded_custom_copilot == 1 then
    return
end
vim.g.loaded_custom_copilot = 1

require("custom-copilot").setup()
