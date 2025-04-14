return {
  "edolphin-ydf/goimpl.nvim",
  lazy = true,
  event = "VeryLazy",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    "nvim-telescope/telescope-fzf-native.nvim",
    "nvim-telescope/telescope-ui-select.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  config = function() require("telescope").load_extension "goimpl" end,
}
