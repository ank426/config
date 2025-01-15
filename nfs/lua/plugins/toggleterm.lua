return {
  "akinsho/toggleterm.nvim",
  keys = { "<C-/>" },
  opts = {
    open_mapping = "<C-/>",
    direction = "float",
    float_opts = { border = "rounded" },
  },
  config = function(_, opts)
    require("toggleterm").setup(opts)
    vim.keymap.set("n", "<leader>st", "<cmd>TermSelect<cr>", { desc = "[S]earch [T]erminals" })
  end,
}
