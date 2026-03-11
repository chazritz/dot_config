vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")
vim.cmd("set nu")
vim.g.mapleader = " "
vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    float = {
        source = "always",
        border = "single",
    }
});
-- Set the 'autoread' option to automatically reload the file if changes are detected on disk
vim.o.autoread = true

-- Create an autocommand group for managing auto-refresh events
vim.api.nvim_create_augroup("AutoReadGroup", { clear = true })

-- Define autocommands to check for changes when focus is gained or a buffer is entered
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
  group = "AutoReadGroup",
  command = "checktime",
  pattern = "*"
})

-- Optional: Add a notification when a file has been changed and reloaded
vim.api.nvim_create_autocmd({ "FileChangedShellPost" }, {
  group = "AutoReadGroup",
  command = 'echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None',
  pattern = "*"
})

--vim.opt.clipboard = "unnamedplus"
--vim.keymap.set("n", "<M-j>", "<cmd>cnext<CR>");
--vim.keymap.set("n", "<M-k>", "<cmd>cprev<CR>");
