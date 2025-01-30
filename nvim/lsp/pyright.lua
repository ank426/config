return {
  cmd = {"pyright-langserver", "--stdio"},
  filetypes = {"python"},
  root_markers = {"pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", "pyrightconfig.json", ".git"},
  on_init = function(client)
    client.server_capabilities.inlayHintProvider = false
    client.server_capabilities.textDocumentSync = nil
  end,
  settings = {
    basedpyright = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = "openFilesOnly",
        useLibraryCodeForTypes = true,
      },
    },
  },
}
