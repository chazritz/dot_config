return {
  "nvim-treesitter/nvim-treesitter", 
  enabled = false,
  build = ":TSUpdate",
  config = function()
    local tconfig = require("nvim-treesitter.configs")
    tconfig.setup({
      ensure_installed = { "c", "lua", "query", "elixir", "heex", "javascript", "html", "python", "go", "zig", "rust", "typescript", "bash" },
      highlight = { enable = true },
      indent = { enable = true },
    })
  end
}
