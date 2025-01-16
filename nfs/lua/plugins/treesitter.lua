return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = "BufEnter",
    opts = {
      auto_install = true,
      highlight = { enable = true },
      incremental_selection = { enable = true },
      -- indent = { enable = true }, -- Can't find a use for it and double indents `from ... import (\n`
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
      vim.treesitter.language.register("bash", "zsh")

      vim.hl = vim.highlight -- Remove when nvim>=10.4
    end,
  },
  -- {
  --   "nvim-treesitter/nvim-treesitter-textobjects",
  --   dependencies = {"nvim-treesitter/nvim-treesitter"},
  -- },
  -- There is also nvim-treesitter-subjects
}
