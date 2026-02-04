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
        vim.lsp.config('vtsls', {
            experimental = {
                completion = {
                    enableServerSideFuzzyMatch = true,
                    entriesLimit = 50,
                },
            },
        })

        vim.lsp.enable('lua_ls')
        vim.lsp.enable('zls')
        vim.lsp.enable('vtsls')
    end,
}
