return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  opts = {
    auto_install = true,
    highlight = { enable = true },
    incremental_selection = { enable = false },
    indent = { enable = false },
  },
  config = function(_, opts)
    require("nvim-treesitter.configs").setup(opts)
    vim.treesitter.language.register("bash", "zsh")
  end,
}
