return {
  "tommcdo/vim-lion",
  keys = {
    { "gl", mode = {"n", "x"} },
    { "gL", mode = {"n", "x"} },
  },
  init = function()
    vim.g.lion_squeeze_spaces = 1
    vim.g.lion_map_left = "gl"
    vim.g.lion_map_right = "gL"
  end,
}
