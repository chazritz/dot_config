vim.opt.shiftwidth = 4  -- Size of an indent
vim.opt.tabstop = 4     -- Number of spaces tabs count for
vim.opt.softtabstop = 4 -- Spaces inserted/deleted when pressing Tab
vim.opt.expandtab = true -- Convert tabs to spaceo

vim.opt.number = true
vim.opt.relativenumber = true
vim.g.mapleader = " "
vim.o.autoread = true

-- this seems to update all change/yank commands which doesn't always work
-- vim.opt.clipboard = "unnamedplus"
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    -- Only sync if the yank was to the default register
    if vim.v.event.operator == "y" and vim.v.event.regname == "" then
      vim.fn.setreg("+", vim.v.event.regcontents, 'c')
    end
  end,
})

vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    float = {
        source = "always",
        border = "single",
    }
});


-- Create an autocommand group for managing auto-refresh events
--vim.api.nvim_create_augroup("AutoReadGroup", { clear = true })

-- Define autocommands to check for changes when focus is gained or a buffer is entered
-- vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
--   group = "AutoReadGroup",
--   command = "checktime",
--   pattern = "*"
-- })

-- Optional: Add a notification when a file has been changed and reloaded
-- vim.api.nvim_create_autocmd({ "FileChangedShellPost" }, {
--   group = "AutoReadGroup",
--   command = 'echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None',
--   pattern = "*"
-- })

--vim.keymap.set("n", "<M-j>", "<cmd>cnext<CR>");
--vim.keymap.set("n", "<M-k>", "<cmd>cprev<CR>");
