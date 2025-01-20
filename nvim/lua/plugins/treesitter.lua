return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = "VeryLazy",
    opts = {
      auto_install = true,
      highlight = {
        enable = true,
      },
      incremental_selection = {
        enable = true,
      },
      indent = {
        enable = true,
        -- disable = { "c", "cpp" },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
      vim.treesitter.language.register("bash", "zsh")
    end,
  },
  -- {
  --   "nvim-treesitter/nvim-treesitter-textobjects",
  --   dependencies = {"nvim-treesitter/nvim-treesitter"},
  -- },
  -- There is also nvim-treesitter-subjects
}
