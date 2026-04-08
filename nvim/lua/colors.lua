vim.cmd.colorscheme("kanagawa")


vim.api.nvim_set_hl(0, "@string.special.url", { underline = true })

vim.api.nvim_set_hl(0, "@comment.error",   { link = "DiagnosticError" })
vim.api.nvim_set_hl(0, "@comment.warning", { link = "DiagnosticWarn"  })
vim.api.nvim_set_hl(0, "@comment.note",    { link = "DiagnosticHint"  })
vim.api.nvim_set_hl(0, "@comment.todo",    { link = "DiagnosticInfo"  })
vim.api.nvim_set_hl(0, "@comment.error",   { bold = true, update = true })
vim.api.nvim_set_hl(0, "@comment.warning", { bold = true, update = true })
vim.api.nvim_set_hl(0, "@comment.note",    { bold = true, update = true })
vim.api.nvim_set_hl(0, "@comment.todo",    { bold = true, update = true })

vim.api.nvim_set_hl(0, "@lsp.type.modifier.java", { link = "@Keyword" })
