vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")
vim.cmd("set nu")
-- this seems to update all change/yank commands which doesn't always work
-- vim.opt.clipboard = "unnamedplus"
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    -- Only sync if the yank was to the default register
    if vim.v.event.operator == "y" and vim.v.event.regname == "" then
      vim.fn.setreg("+", vim.v.event.regcontents)
    end
  end,
})
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

--vim.keymap.set("n", "<M-j>", "<cmd>cnext<CR>");
--vim.keymap.set("n", "<M-k>", "<cmd>cprev<CR>");
