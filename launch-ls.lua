vim.lsp.start({
    name = 'waxwing-lsp',
    cmd = { 'waxwing-lsp' },
    root_dir = vim.fs.dirname(vim.fs.find({ 'Cargo.toml' }, { upward = true })[1]),
})

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
        -- print(vim.inspect(args));
    end,
})
