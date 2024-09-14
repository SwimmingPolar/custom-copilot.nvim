local M = {}
-- `cmp.view.custom_entries_view` - view for in-editor completion
--  Modify the instance method
local view = require("nvim-cmp").view.custom_entries_view

if not view == nil then
    vim.print(view)
end

return M
