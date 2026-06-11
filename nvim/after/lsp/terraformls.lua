return {
  on_attach = function(client, bufnr)
    client.server_capabilities.semanticTokensProvider = nil -- there's a bug with this that causes freezes
  end,
}
