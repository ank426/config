return {
  "sindrets/diffview.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
    show_help_hints = false,
    file_panel = {
      win_config = function()
        local c = { type = "float" }
        c.width = math.min(vim.o.columns, math.max(80, vim.o.columns - 20))
        c.height = math.min(vim.o.lines, math.max(24, vim.o.lines - 15))
        c.col = math.floor(vim.o.columns * 0.5 - c.width * 0.5)
        c.row = math.floor(vim.o.lines * 0.5 - c.height * 0.5) - 1
        return c
      end
    },
  },
}
