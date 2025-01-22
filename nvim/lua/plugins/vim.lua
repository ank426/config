return {
  {
    "tommcdo/vim-lion",
    keys = {"gl", "gL"},
    init = function()
      vim.g.lion_squeeze_spaces = 1
      vim.g.lion_map_left = "gl"
      vim.g.lion_map_right = "gL"
    end
  },
  { "tpope/vim-sleuth", event = "VeryLazy" },
  -- { "tpope/vim-repeat",     keys = { "." } },
  -- { "tpope/vim-surround",   keys = { "ys", "ds", "cs" } },
  -- { "wellle/targets.vim",   event = "VeryLazy" },
  -- { "tpope/vim-unimpaired", keys = { "[", "]" } }, -- Most of it comes with neovim by default
}
