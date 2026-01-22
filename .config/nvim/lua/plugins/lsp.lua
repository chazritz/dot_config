return {
    "neovim/nvim-lspconfig",
    lazy = false,
    dpendencies = {
        'saghen/blink.cmp'
    },
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "LspInfo", "LspInstall", "LspUninstall" },
    config = function()
        vim.lsp.config('lua_ls', {})
        vim.lsp.config('zls', {})
        vim.lsp.config('ts_ls',{
            --autoformat on save
            --on_attach = function(client, bufnr)
            --    if client.server_capabilities.documentFormattingProvider then
            --        vim.api.nvim_create_autocmd("BufWritePre", {
            --            group = vim.api.nvim_create_augroup("Format", { clear = true }),
            --            buffer = bufnr,
            --            callback = function()
            --                vim.lsp.buf.format()
            --            end,
            --        })
            --    end
            --end
        })

        vim.lsp.enable('lua_ls')
        vim.lsp.enable('zls')
        vim.lsp.enable('ts_ls',{})
    end,
}
