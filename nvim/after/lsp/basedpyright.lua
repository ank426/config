return {
  handlers = {
    ["textDocument/publishDiagnostics"] = function() end,
  },
  on_init = function(client)
    client.server_capabilities.inlayHintProvider = false
  end
}
