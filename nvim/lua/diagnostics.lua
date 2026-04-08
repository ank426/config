local ns = vim.api.nvim_create_namespace("custom-sign-handler")
local orig_signs_handler = vim.diagnostic.handlers.signs
vim.diagnostic.handlers.signs = {
  show = function(_, bufnr, _, opts)
    local diagnostics = {}
    for _, d in ipairs(vim.diagnostic.get(bufnr)) do
      diagnostics[d.lnum] = diagnostics[d.lnum] or d
    end
    orig_signs_handler.show(ns, bufnr, vim.tbl_values(diagnostics), opts)
  end,
  hide = function(_, bufnr)
    orig_signs_handler.hide(ns, bufnr)
  end,
}

vim.diagnostic.config({
  float = {
    header = "",
    source = true,
  },
  virtual_text = {
    severity = { min = vim.diagnostic.severity.WARN },
  },
  severity_sort = true,
})

vim.keymap.set('n', 'gK', function()
  if vim.diagnostic.config().virtual_lines then
    vim.diagnostic.config({ virtual_lines = false })
  else
    vim.diagnostic.config({ virtual_lines = {
      current_line = true,
    }})
  end
end, { desc = 'Toggle diagnostic virtual_lines' })
