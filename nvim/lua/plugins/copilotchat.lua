return {
  "CopilotC-Nvim/CopilotChat.nvim",
  lazy = false,
  dependencies = {
    { "github/copilot.vim" },
    { "nvim-lua/plenary.nvim" },
  },
  build = "make tiktoken",
  opts = {
  },
  keys = {
    { "<leader>zc", ":CopilotChat<CR>", mode = "n", desc = "Chat with Copilot" },
    { "<leader>zf", ":CopilotChatFix<CR>", mode = "n", desc = "Fix Code Issues" }
  }
}
