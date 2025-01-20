return {
  "akinsho/toggleterm.nvim",
  keys = {
    "<C-/>",
    { "<leader>st", vim.cmd.TermSelect, desc = "[S]earch [T]erminals" },
  },
  opts = {
    open_mapping = "<C-/>",
    direction = "float",
    float_opts = { border = "rounded" },
  },
}
