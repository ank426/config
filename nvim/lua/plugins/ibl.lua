-- This puts the indent lines and removes whitespace on blanklines
return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  event = "BufEnter",
  opts = {
    indent = {
      char = "│",
      tab_char = "│",
    },
    scope = { enabled = false },
    exclude = {
      filetypes = {
        "lspinfo",
        "lazy",
        "checkhealth",
        "help",
        "man",
        "gitcommit",
        "TelescopePrompt",
        "TelescopeResults",
        "''",
      },
    },
  },
}
