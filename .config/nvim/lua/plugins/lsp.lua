return {
    "neovim/nvim-lspconfig",
    dpendencies = {
        'saghen/blink.cmp'
    },
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "LspInfo", "LspInstall", "LspUninstall" },
    config = function()
        local capabilities = require("blink.cmp").get_lsp_capabilities()
        local lspconfig = require("lspconfig")

        lspconfig.lua_ls.setup {capabilities = capabilities}
        lspconfig.zls.setup({ capabilities = capabilities })
        lspconfig.ts_ls.setup({ capabilities = capabilities })
    end,
}
