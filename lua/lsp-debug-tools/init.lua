--- @param expected string[]
--- @return function(number): boolean
local function filter_by(expected)
    return function(bufnr)
        if #expected == 0 then
            return true
        end

        local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype");
        local found = false
        for i = 1, #expected do
            if filetype == expected[i] then
                found = true
                break
            end
        end

        return found
    end
end

local id = nil
local filter = filter_by({})
local config = nil

local M = {}

local function attach_lsp(args)
    if id == nil then
        return
    end

    local bufnr = args.buffer or args.buf;
    if not bufnr or not filter(bufnr) then
        return;
    end

    if not vim.lsp.buf_is_attached(args.buffer, id) then
        vim.lsp.buf_attach_client(args.buffer, id);
    end
end

vim.api.nvim_create_autocmd("BufNew", {
    callback = attach_lsp
});

vim.api.nvim_create_autocmd("BufEnter", {
    callback = attach_lsp,
});

function M.restart(updated_config)
    config = vim.tbl_deep_extend("force", {}, config, updated_config or {})
    M.stop()
    M.start(config)
end

function M.stop()
    if id == nil then
        return
    end

    vim.lsp.stop_client(id)
    id = nil
end

function M.htmx_lsp_config()
    return {
        expected = {},
        name = "htmx-lsp",
        cmd = { "htmx-lsp", "--level", "DEBUG" },
        root_dir = vim.loop.cwd()
    }
end

--- The default uses jsperf-lsp and its debug config and looks for package.json
--- @param opts {expected: string[], name: string, cmd: string[], root_dir: string}
function M.start(opts)
    if id ~= nil then
        return
    end

    config = vim.tbl_deep_extend("force", {}, {
        expected = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
        name = "jsperf-lsp",
        cmd = { "jsperf-lsp", "--level", "DEBUG" },
        root_dir = vim.fs.dirname(
            vim.fs.find({ "package.json" }, { upward = true })[1]
        )
    }, opts or {})

    id = vim.lsp.start_client({
        name = config.name,
        cmd = config.cmd,
        root_dir = config.root_dir,
    })

    filter = filter_by(config.expected)

    local bufnr = vim.api.nvim_get_current_buf()

    attach_lsp({ buffer = bufnr })
end

return M
