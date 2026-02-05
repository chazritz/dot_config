return {
    "neovim/nvim-lspconfig",
    lazy = false,
    dpendencies = {
        'saghen/blink.cmp'
    },
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "LspInfo", "LspInstall", "LspUninstall" },
    config = function()
        vim.lsp.config('lua_ls', {
            settings = {
                Lua = {
                    diagnostics = {
                        globals = { 'vim' }
                    }
                }
            },
            workspace = {
                -- Make the server aware of Neovim runtime files for better completion
                library = vim.api.nvim_get_runtime_file("", true),
            },
        })
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
