require("vim-options")

-- Which multiplexer are we inside? Only one navigation integration gets
-- loaded, because each maps <C-h/j/k/l> from its own plugin/ directory --
-- and those are sourced *after* init.lua, so a loser here would silently
-- clobber the winner's keymaps.
-- tmux wins a tie: if nvim is in tmux inside a herdr pane, tmux is the
-- immediate parent and owns the pane boundaries nvim can see.
local in_tmux = vim.env.TMUX ~= nil
local in_herdr = not in_tmux and vim.env.HERDR_ENV == "1"

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
    { src = "https://github.com/nvim-lualine/lualine.nvim" },
    { src = "https://github.com/rebelot/kanagawa.nvim" },
    { src = "https://github.com/ThePrimeagen/harpoon" },
    { src = "https://github.com/neovim/nvim-lspconfig" },
    { src = "https://github.com/rafamadriz/friendly-snippets" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
})

-- Split/pane navigation, one integration per multiplexer. See the keymaps
-- at the bottom of this file.
if in_tmux then
    vim.pack.add({ { src = "https://github.com/christoomey/vim-tmux-navigator" } })
elseif in_herdr then
    vim.pack.add({ { src = "https://github.com/lmilojevicc/herdr-splits.nvim" } })
    local herdr_splits = require("herdr-splits")
    herdr_splits.setup({ auto_sync_herdr = true })
    vim.keymap.set('n', '<C-h>', herdr_splits.move_cursor_left, { desc = 'Navigate left' })
    vim.keymap.set('n', '<C-j>', herdr_splits.move_cursor_down, { desc = 'Navigate down' })
    vim.keymap.set('n', '<C-k>', herdr_splits.move_cursor_up, { desc = 'Navigate up' })
    vim.keymap.set('n', '<C-l>', herdr_splits.move_cursor_right, { desc = 'Navigate right' })
else
    -- Bare terminal: plain window navigation, no pane crossing.
    vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Window left' })
    vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Window down' })
    vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Window up' })
    vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Window right' })
end

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
        "python",
        "go",
        "zig",
        "rust",
        "typescipt",
        "bash",
        "yaml",
        "html",
        "latex",
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

vim.keymap.set('n', '<leader>fs', ':Neotree<CR>', {})
vim.keymap.set('n', '<leader>fr', ':Neotree reveal<CR>', {})

-- Tmux  Navigator
-- vim.keymap.set('n', 'C-h', '<cmd>TmuxNavigateLeft<cr>')
-- vim.keymap.set('n', 'C-j', '<cmd>TmuxNavigateDown<cr>')
-- vim.keymap.set('n', 'C-k', '<cmd>TmuxNavigateUp<cr>')
-- vim.keymap.set('n', 'C-l', '<cmd>TmuxNavigateRight<cr>')

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

require("oil").setup({
    -- Oil will take over directory buffers (e.g. `vim .` or `:e src/`)
    -- Set to false if you want some other plugin (e.g. netrw) to open when you edit directories.
    default_file_explorer = true,
    -- Id is automatically added at the beginning, and name at the end
    -- See :help oil-columns
    columns = {
        "icon",
        -- "permissions",
        -- "size",
        -- "mtime",
    },
    -- Buffer-local options to use for oil buffers
    buf_options = {
        buflisted = false,
        bufhidden = "hide",
    },
    -- Window-local options to use for oil buffers
    win_options = {
        wrap = false,
        signcolumn = "no",
        cursorcolumn = false,
        foldcolumn = "0",
        spell = false,
        list = false,
        conceallevel = 3,
        concealcursor = "nvic",
    },
    -- Send deleted files to the trash instead of permanently deleting them (:help oil-trash)
    delete_to_trash = false,
    -- Skip the confirmation popup for simple operations (:help oil.skip_confirm_for_simple_edits)
    skip_confirm_for_simple_edits = false,
    -- Selecting a new/moved/renamed file or directory will prompt you to save changes first
    -- (:help prompt_save_on_select_new_entry)
    prompt_save_on_select_new_entry = true,
    -- Oil will automatically delete hidden buffers after this delay
    -- You can set the delay to false to disable cleanup entirely
    -- Note that the cleanup process only starts when none of the oil buffers are currently displayed
    cleanup_delay_ms = 2000,
    lsp_file_methods = {
        -- Enable or disable LSP file operations
        enabled = true,
        -- Time to wait for LSP file operations to complete before skipping
        timeout_ms = 1000,
        -- Set to true to autosave buffers that are updated with LSP willRenameFiles
        -- Set to "unmodified" to only save unmodified buffers
        autosave_changes = false,
    },
    -- Constrain the cursor to the editable parts of the oil buffer
    -- Set to `false` to disable, or "name" to keep it on the file names
    constrain_cursor = "editable",
    -- Set to true to watch the filesystem for changes and reload oil
    watch_for_changes = false,
    -- Keymaps in oil buffer. Can be any value that `vim.keymap.set` accepts OR a table of keymap
    -- options with a `callback` (e.g. { callback = function() ... end, desc = "", mode = "n" })
    -- Additionally, if it is a string that matches "actions.<name>",
    -- it will use the mapping at require("oil.actions").<name>
    -- Set to `false` to remove a keymap
    -- See :help oil-actions for a list of all available actions
    keymaps = {
        ["g?"] = { "actions.show_help", mode = "n" },
        ["<CR>"] = "actions.select",
        ["<C-s>"] = { "actions.select", opts = { vertical = true } },
        ["<C-h>"] = { "actions.select", opts = { horizontal = true } },
        ["<C-t>"] = { "actions.select", opts = { tab = true } },
        ["<C-p>"] = "actions.preview",
        ["<C-c>"] = { "actions.close", mode = "n" },
        ["<C-r>"] = "actions.refresh",
        ["-"] = { "actions.parent", mode = "n" },
        ["<leader>o"] = { "actions.open_cwd", mode = "n" },
        ["`"] = { "actions.cd", mode = "n" },
        ["g~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
        ["gs"] = { "actions.change_sort", mode = "n" },
        ["gx"] = "actions.open_external",
        ["g."] = { "actions.toggle_hidden", mode = "n" },
        ["g\\"] = { "actions.toggle_trash", mode = "n" },
    },
    -- Set to false to disable all of the above keymaps
    use_default_keymaps = true,
    view_options = {
        -- Show files and directories that start with "."
        show_hidden = false,
        -- This function defines what is considered a "hidden" file
        is_hidden_file = function(name, bufnr)
            local m = name:match("^%.")
            return m ~= nil
        end,
        -- This function defines what will never be shown, even when `show_hidden` is set
        is_always_hidden = function(name, bufnr)
            return false
        end,
        -- Sort file names with numbers in a more intuitive order for humans.
        -- Can be "fast", true, or false. "fast" will turn it off for large directories.
        natural_order = "fast",
        -- Sort file and directory names case insensitive
        case_insensitive = false,
        sort = {
            -- sort order can be "asc" or "desc"
            -- see :help oil-columns to see which columns are sortable
            { "type", "asc" },
            { "name", "asc" },
        },
        -- Customize the highlight group for the file name
        highlight_filename = function(entry, is_hidden, is_link_target, is_link_orphan)
            return nil
        end,
    },
    -- Extra arguments to pass to SCP when moving/copying files over SSH
    extra_scp_args = {},
    -- Extra arguments to pass to aws s3 when creating/deleting/moving/copying files using aws s3
    extra_s3_args = {},
    -- EXPERIMENTAL support for performing file operations with git
    git = {
        -- Return true to automatically git add/mv/rm files
        add = function(path)
            return false
        end,
        mv = function(src_path, dest_path)
            return false
        end,
        rm = function(path)
            return false
        end,
    },
    -- Configuration for the floating window in oil.open_float
    float = {
        -- Padding around the floating window
        padding = 2,
        -- max_width and max_height can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
        max_width = 0,
        max_height = 0,
        border = nil,
        win_options = {
            winblend = 0,
        },
        -- optionally override the oil buffers window title with custom function: fun(winid: integer): string
        get_win_title = nil,
        -- preview_split: Split direction: "auto", "left", "right", "above", "below".
        preview_split = "auto",
        -- This is the config that will be passed to nvim_open_win.
        -- Change values here to customize the layout
        override = function(conf)
            return conf
        end,
    },
    -- Configuration for the file preview window
    preview_win = {
        -- Whether the preview window is automatically updated when the cursor is moved
        update_on_cursor_moved = true,
        -- How to open the preview window "load"|"scratch"|"fast_scratch"
        preview_method = "fast_scratch",
        -- A function that returns true to disable preview on a file e.g. to avoid lag
        disable_preview = function(filename)
            return false
        end,
        -- Window-local options to use for preview window buffers
        win_options = {},
    },
    -- Configuration for the floating action confirmation window
    confirmation = {
        -- Width dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
        -- min_width and max_width can be a single value or a list of mixed integer/float types.
        -- max_width = {100, 0.8} means "the lesser of 100 columns or 80% of total"
        max_width = 0.9,
        -- min_width = {40, 0.4} means "the greater of 40 columns or 40% of total"
        min_width = { 40, 0.4 },
        -- optionally define an integer/float for the exact width of the preview window
        width = nil,
        -- Height dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
        -- min_height and max_height can be a single value or a list of mixed integer/float types.
        -- max_height = {80, 0.9} means "the lesser of 80 columns or 90% of total"
        max_height = 0.9,
        -- min_height = {5, 0.1} means "the greater of 5 columns or 10% of total"
        min_height = { 5, 0.1 },
        -- optionally define an integer/float for the exact height of the preview window
        height = nil,
        border = nil,
        win_options = {
            winblend = 0,
        },
    },
    -- Configuration for the floating progress window
    progress = {
        max_width = 0.9,
        min_width = { 40, 0.4 },
        width = nil,
        max_height = { 10, 0.9 },
        min_height = { 5, 0.1 },
        height = nil,
        border = nil,
        minimized_border = "none",
        win_options = {
            winblend = 0,
        },
    },
    -- Configuration for the floating SSH window
    ssh = {
        border = nil,
    },
    -- Configuration for the floating keymaps help window
    keymaps_help = {
        border = nil,
    },
})

