return {
  "folke/trouble.nvim",
  cmd = "Trouble",
  keys = {
    { "<leader>xx", function() vim.cmd.Trouble("diagnostics toggle") end,                        desc = "Diagnostics (Trouble)" },
    { "<leader>xX", function() vim.cmd.Trouble("diagnostics toggle filter.buf=0") end,           desc = "Buffer Diagnostics (Trouble)" },
    { "<leader>cs", function() vim.cmd.Trouble("symbols toggle focus=false") end,                desc = "Symbols (Trouble)" },
    { "<leader>cl", function() vim.cmd.Trouble("lsp toggle focus=false win.position=right") end, desc = "LSP Definitions/References/... (Trouble)" },
    { "<leader>xL", function() vim.cmd.Trouble("loclist toggle") end,                            desc = "Location List (Trouble)" },
    { "<leader>xQ", function() vim.cmd.Trouble("qflist toggle") end,                             desc = "Quickfix List (Trouble)" },
  },
  opts = {
    win = {
      position = "right",
    },
  },
}
