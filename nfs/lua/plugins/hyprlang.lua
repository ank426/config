return {
  "luckasRanarison/tree-sitter-hyprlang",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  ft = "hyprlang",
  init = function()
    vim.filetype.add({
      pattern = { [".*/hypr/.*%.conf"] = "hyprlang" },
    })
  end,
}
