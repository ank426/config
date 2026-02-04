vim.cmd.colorscheme("kanagawa")


local function bold(group)
  return vim.tbl_extend("force", vim.api.nvim_get_hl(0, { name = group, link = false }), { bold = true })
end

vim.api.nvim_set_hl(0, "@comment.error", bold("DiagnosticError"))
vim.api.nvim_set_hl(0, "@comment.warn", bold("DiagnosticWarn"))
vim.api.nvim_set_hl(0, "@comment.note", bold("DiagnosticHint"))
vim.api.nvim_set_hl(0, "@comment.todo", bold("DiagnosticInfo"))


vim.api.nvim_set_hl(0, "@lsp.type.modifier.java", { link = "@Keyword" })
