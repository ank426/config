return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = "BufEnter",
  opts = {
    auto_install = true,
    highlight = { enable = true },
    incremental_selection = { enable = true },
    indent = { enable = true },
  },
  config = function(_, opts)
    require("nvim-treesitter.configs").setup(opts)
    vim.treesitter.language.register("bash", "zsh")

    vim.hl = vim.highlight -- Remove when nvim>=10.4
  end,
}
