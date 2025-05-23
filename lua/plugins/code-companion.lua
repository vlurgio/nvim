return {
  "olimorris/codecompanion.nvim",
  config = true,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    strategies = {
      -- Change the default chat adapter
      chat = {
        adapter = "copilot",
      },
      inline = {
        adapater = "copilot",
      },
      cmd = {
        adapater = "copilot",
      },
      display = {
        diff = {
          provider = "mini_diff",
        },
      },
    },
  },
}
