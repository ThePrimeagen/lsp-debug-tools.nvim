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

--- The default uses jsperf-lsp and its debug config and looks for package.json
--- @param opts {expected: string[], name: string, cmd: string[], root_dir: string}
return function(opts)
    opts = vim.tbl_extend_deep("force", {}, {
        expected = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
        name = "jsperf-lsp",
        cmd = { "jsperf-lsp", "--level", "DEBUG" },
        root_dir = vim.fs.dirname(
            vim.fs.find({ "package.json" }, { upward = true })[1]
        )
    }, opts)

    local filter = filter_by(opts.expected)

    local function attach_lsp(args, id)
        local bufnr = args.buffer or args.buf;
        if not bufnr or not filter(bufnr) then
            return;
        end

        if not vim.lsp.buf_is_attached(args.buffer, id) then
            vim.lsp.buf_attach_client(args.buffer, id);
        end
    end

    local id = vim.lsp.start_client({
        name = opts.name,
        cmd = opts.cmd,
        root_dir = opts.root_dir,
    })

    vim.api.nvim_create_autocmd("BufNew", {
        callback = function(args)
            attach_lsp(args, id)
        end,
    });

    vim.api.nvim_create_autocmd("BufEnter", {
        callback = function(args)
            attach_lsp(args, id)
        end,
    });

end

