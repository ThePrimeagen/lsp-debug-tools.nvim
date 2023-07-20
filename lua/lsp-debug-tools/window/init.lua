local M = {}

local previous_opts = {}
local function create_window_opts(opts)
    local port_width = vim.api.nvim_list_uis()[1].width
    local width = math.floor(port_width * opts.width_ratio)
    return {
        relative = 'editor',
        width = width,
        height = opts.rows,
        row = 1,
        col = port_width - (width + 3),
        style = 'minimal',
        border = 'single',
    }
end


local function create_window(opts)
    local bufnr = vim.api.nvim_create_buf(false, true)

    if bufnr == 0 then
        error("Failed to create buffer")
    end

    local win_id = vim.api.nvim_open_win(bufnr, false, create_window_opts(opts))

    return win_id, bufnr
end

local bufnr = -1
local win_id = -1

local function has_valid_window()
    return vim.api.nvim_win_is_valid(win_id) and
        vim.api.nvim_buf_is_valid(bufnr)
end

local function close()
    if vim.api.nvim_win_is_valid(win_id) then
        vim.api.nvim_win_close(win_id, true)
    end

    if vim.api.nvim_buf_is_valid(bufnr) then
        vim.api.nvim_buf_close(bufnr, true)
    end
end


M.show_window = function(opts)
    opts = vim.tbl_extend("force", {
        rows = 5,
        width_ratio = 1 / 3,
    }, opts or {})
    previous_opts = opts

    if win_id == -1 or bufnr == -1 then
        win_id, bufnr = create_window(opts)
    end

    if not vim.api.nvim_win_is_valid(win_id) or
       not vim.api.nvim_buf_is_valid(bufnr) then
        close()
        win_id, bufnr = create_window(opts)
    end

    return bufnr
end

M.jump_to_window = function()
    if not has_valid_window() then
        return
    end

    vim.api.nvim_set_current_win(win_id)
end

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local window_group = augroup('lsp-debug-tools-window', {})

autocmd({"WinResized"}, {
    group = window_group,
    pattern = "*",
    callback = function()
        if has_valid_window() then
            vim.api.nvim_win_set_config(win_id, create_window_opts(previous_opts))
        end
    end
})

return M


