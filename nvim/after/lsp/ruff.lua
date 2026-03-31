return {
  -- on_init = function(client)
  --   client.server_capabilities.documentFormattingProvider = false
  --   client.server_capabilities.documentRangeFormattingProvider = false
  -- end,
  init_options = {
    settings = {
      configurationPreference = "filesystemFirst",
    },
  },
}
