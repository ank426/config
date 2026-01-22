-- Now that nvim sorts by severity there might be a slightly faster algorithm (also shows higher priority signs earlier)
-- :h diagnostic-handlers-example (second one)
local ns = vim.api.nvim_create_namespace("custom-sign-handler")
local orig_signs_handler = vim.diagnostic.handlers.signs
vim.diagnostic.handlers.signs = {
  show = function(_, bufnr, _, opts)
    local diagnostics = vim.diagnostic.get(bufnr)
    local max_severity_per_line = {}
    for _, d in pairs(diagnostics) do
      local m = max_severity_per_line[d.lnum]
      if not m or d.severity < m.severity then
        max_severity_per_line[d.lnum] = d
      end
    end
    local filtered_diagnostics = vim.tbl_values(max_severity_per_line)
    orig_signs_handler.show(ns, bufnr, filtered_diagnostics, opts)
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
