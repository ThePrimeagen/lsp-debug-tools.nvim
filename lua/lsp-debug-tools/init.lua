local Job = require'plenary.job'
local window = require("lsp-debug-tools.window")

local M = {}

M.start = function(opts)
    local bufnr = window.show_window(opts)
    Job:new({
        command = 'tail',
        args = { '-F', vim.fn.expand('~') .. '/.local/state/nvim/lsp.log' },
        on_exit = function(j, return_val)
            print("exit", return_val, j:result())
        end,
        on_stderr = function(a, b, c)
            print("err", a, b, c)
        end,
        on_stdout = function(_, b)
            print("is this going?", b)
            vim.schedule(function()
                vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {b})
            end)
        end,
    }):start()
end


return M
