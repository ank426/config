return {
  "lmburns/lf.nvim",
  dependencies = {
    "akinsho/toggleterm.nvim",
  },
  keys = {
    { "<leader>lf", vim.cmd.Lf, desc = "Lf" },
  },
  opts = {
    winblend = 0,
    border = "single",
  },
}
