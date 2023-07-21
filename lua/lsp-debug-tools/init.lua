local async = require("plenary.async")
local Job = require("plenary.job")
local window = require("lsp-debug-tools.window")
local Preview = require("lsp-debug-tools.preview")

local M = {}

local default_config = {
    window = {
        width_ratio = 0.5,
        rows = 5,
    },
    preview = Preview:new(),
    filter = function(x)
        return true
    end,
}
local config = {}

M.setup = function(opts)
    opts = opts or {}
    config = vim.tbl_extend("force", {}, default_config, opts or {})
end

local running = false
M.show = function()
    if not running then
        error("LPS log is not running, run start")
    end

    window.show_window(config.window)
end

M.start = function(opts)
    local run_config =
        vim.tbl_deep_extend("force", {}, default_config, config, opts)

    if running then
        window.show_window(run_config.window)
        return
    end

    async.run(function()
        local bufnr = window.show_window(run_config.window)

        running = true
        Job:new({
            command = "tail",
            args = {
                "-F",
                vim.fn.expand("~") .. "/.local/state/nvim/lsp.log",
            },
            on_exit = function()
                running = false
            end,
            on_stderr = function()
                running = false
            end,
            on_stdout = function(_, b)
                vim.schedule(function()
                    if not run_config.filter(b) then
                        return
                    end

                    local lines = run_config.preview:render(b)
                    if not window.has_valid_window() then
                        return
                    end
                    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
                end)
            end,
        }):start()
    end)
end

return M
