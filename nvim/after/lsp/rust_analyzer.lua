return {
  -- Started working on getting single file support, but ditched cuz rn rust-analyzer single file support is limited and sucks
  -- before_init = function(init_params, config)
  --   init_params.initializationOptions = init_params.initializationOptions or {}
  --   init_params.initializationOptions.detachedFiles = { vim.fn.expand("%:p") }
  -- end
  settings = {
    ["rust-analyzer"] = {
      check = {
        command = "clippy",
      },
    },
  },
}
