local M = {}

M.debounce = function(delay, fn)
    local timer = nil
    return function(...)
        if timer and timer.is_active then
            vim.uv.timer_stop(timer)
        end

        local args = { ... }
        timer = vim.uv.new_timer()
        timer:start(
            delay,
            0,
            vim.schedule_wrap(function()
                fn(unpack(args))
            end)
        )
    end
end

return M
