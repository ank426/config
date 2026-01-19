-- pyright doesn't respect the capabilites you define
-- local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities.textDocument.publishDiagnostics.tagSupport.valueSet = { 2 }
return {
  -- capabilities = capabilities,
  handlers = {
    ["textDocument/publishDiagnostics"] = function() end,
  },
  on_init = function(client)
    client.server_capabilities.inlayHintProvider = false
    -- client.server_capabilities.textDocumentSync = nil -- now disables lsp features also
  end
}
