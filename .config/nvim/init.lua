require("vim-options")

vim.pack.add({
    { src = "https://github.com/folke/which-key.nvim" },
    {
        src = "https://github.com/saghen/blink.cmp",
        version = vim.version.range('^1')
    },
    { src = "https://github.com/nvim-lua/plenary.nvim" },
    { src = "https://github.com/nvim-telescope/telescope-fzf-native.nvim" },
    { src = "https://github.com/nvim-telescope/telescope.nvim" },
    { src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
    { src = "https://github.com/nvim-mini/mini.icons" },
    { src = "https://github.com/stevearc/oil.nvim" },
    { src = "https://github.com/nvim-lua/plenary.nvim" },
    { src = "https://github.com/nvim-tree/nvim-web-devicons" },
    { src = "https://github.com/MunifTanjim/nui.nvim" },
    { src = "https://github.com/nvim-neo-tree/neo-tree.nvim"  },
    { src = "https://github.com/christoomey/vim-tmux-navigator" },
    { src = "https://github.com/nvim-lualine/lualine.nvim" },
    { src = "https://github.com/rebelot/kanagawa.nvim" },
    { src = "https://github.com/ThePrimeagen/harpoon" },
    { src = "https://github.com/neovim/nvim-lspconfig" },
    { src = "https://github.com/stevearc/oil.nvim" },
    { src = "https://github.com/rafamadriz/friendly-snippets" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
    -- { src = "https://github.com/" },
    -- { src = "https://github.com/" },
})

-- Lazy load on first insert mode entry (may not necessary)
local group = vim.api.nvim_create_augroup("BlinkCmpLazyLoad", { clear = true })

vim.api.nvim_create_autocmd("InsertEnter", {
    pattern = "*",
    group = group,
    once = true,
    callback = function()
        require("blink.cmp").setup({
            keymap = { preset = "super-tab" },
            appearance = {
                nerd_font_variant = "mono",
                use_nvim_cmp_as_default = true,
            },
            completion = {
                documentation = { auto_show = false },
            },
            sources = {
                default = { "lsp", "path", "snippets", "buffer" },
            },
            fuzzy = { implementation = "prefer_rust_with_warning" },
        })
    end,
})

local treesitter = require('nvim-treesitter')
treesitter.setup({
    ensure_installed = {
        "c",
        "lua",
        "query",
        "elixir",
        "heex",
        "javascript",
        "html",
        "python",
        "go",
        "zig",
        "rust",
        "typescipt",
        "bash",
    },
    highlight = { enable = true },
    indent = { enable = true }
})


-- Telescope
local builtin = require('telescope.builtin');
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

-- NeoTree
vim.keymap.set('n', '<leader>fs', ':Neotree<CR>', {})
vim.keymap.set('n', '<leader>fr', ':Neotree reveal<CR>', {})

-- Tmux  Navigator
vim.keymap.set('n', 'C-h', '<cmd>TmuxNavigateLeft<cr>')
vim.keymap.set('n', 'C-j', '<cmd>TmuxNavigateDown<cr>')
vim.keymap.set('n', 'C-k', '<cmd>TmuxNavigateUp<cr>')
vim.keymap.set('n', 'C-l', '<cmd>TmuxNavigateRight<cr>')

-- LuaLine
require("lualine").setup({ options = { theme = "OceanicNext" } })

-- kanagawa
require('kanagawa').setup({
    compile = false,             -- enable compiling the colorscheme
    undercurl = true,            -- enable undercurls
    commentStyle = { italic = true },
    functionStyle = {},
    keywordStyle = { italic = true},
    statementStyle = { bold = true },
    typeStyle = {},
    transparent = false,         -- do not set background color
    dimInactive = false,         -- dim inactive window `:h hl-NormalNC`
    terminalColors = true,       -- define vim.g.terminal_color_{0,17}
    colors = {                   -- add/modify theme and palette colors
        palette = {},
        theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
    },
    theme = "wave",              -- Load "wave" theme
    background = {               -- map the value of 'background' option to a theme
        dark = "wave",           -- try "dragon" !
        light = "lotus"
    },
})
vim.cmd.colorscheme "kanagawa"

-- LSP
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

vim.lsp.config('zls', {
    default_config = {
        filetypes = {"zig"},
        root_dir = [[root_pattern("build.zig", ".git")]],
    };
    docs = {
        description = [[ ]],
        default_config = {
            root_dir = [[root_pattern("build.zig", ".git")]],
        },
    };
})
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
