return {
  "folke/todo-comments.nvim",
  event = "VeryLazy",
  dependencies = {"nvim-lua/plenary.nvim"},
  opts = {
    signs = false,
    gui_style = {
      fg = "BOLD",
    },
    highlight = {
      keyword = "wide_fg",
      after = "",
    },
  },
}
