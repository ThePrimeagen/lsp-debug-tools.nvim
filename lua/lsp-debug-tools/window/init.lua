local async = require("plenary.async")
local M = {}
local bufnr = -1
local win_id = -1

local function create_window()
    local new_bufnr = vim.api.nvim_create_buf(false, true)

    if new_bufnr == 0 then
        error("Failed to create buffer")
    end

    vim.cmd("new")
    vim.cmd("setlocal buftype=nofile")

    async.util.scheduler()

    win_id = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(win_id, new_bufnr)

    return win_id, new_bufnr
end

M.has_valid_window = function()
    return vim.api.nvim_win_is_valid(win_id) and
        vim.api.nvim_buf_is_valid(bufnr)
end

local function close()
    if vim.api.nvim_win_is_valid(win_id) then
        vim.api.nvim_win_close(win_id, true)
        async.util.scheduler()
    end

    if vim.api.nvim_buf_is_valid(bufnr) then
        vim.api.nvim_buf_close(bufnr, true)
        async.util.scheduler()
    end
end

M.show_window = function(opts)
    opts = vim.tbl_deep_extend("force", {
        rows = 5,
        width_ratio = 1 / 3,
    }, opts or {})

    local current_window_id = vim.api.nvim_get_current_win()

    if win_id == -1 or bufnr == -1 then
        win_id, bufnr = create_window(opts)
    end

    if not vim.api.nvim_win_is_valid(win_id) or
        not vim.api.nvim_buf_is_valid(bufnr) then
        close()
        win_id, bufnr = create_window(opts)
    end

    vim.api.nvim_set_current_win(current_window_id)

    return bufnr
end

M.jump_to_window = function()
    if not M.has_valid_window() then
        return
    end

    vim.api.nvim_set_current_win(win_id)
end

return M


