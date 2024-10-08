---@meta

---@class autocmd_event
---@field id number Autocommand id.
---@field event string Name of the triggered event.
---@field group number?|nil Autocommand group id, if any.
---@field match string Expanded value of <amatch>.
---@field buf number Expanded value of <abuf>.
---@field file string Expanded value of <afile>.
---@field data any Arbitrary data passed from nvim_exec_autocmds().

---@class on_autocmd_opts
---@field callback fun(event_args: autocmd_event): boolean|string? Lua function or Vimscript function name. Returns truthy value to delete the autocommand.
---@field pattern string|string[] Pattern(s) to match.
---@field group string|integer? Autocommand group name or id.
---@field buffer integer? Buffer number for buffer-local autocommands.
---@field desc string? Description for documentation and troubleshooting.
---@field command string? Vim command to execute on event.
---@field once boolean? Defaults to false. Run the autocommand only once.
---@field nested boolean? Defaults to false. Run nested autocommands.
