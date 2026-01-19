return vim.tbl_deep_extend("force", vim.lsp.config["clangd"], {
  filetypes = {"c"},
  init_options = {
    fallbackFlags = {"--std=c23"},
  },
})
