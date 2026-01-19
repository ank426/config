return {
  "j-hui/fidget.nvim",
  event = "VeryLazy",
  opts = {
    notification = {
      override_vim_notify = true,
      window = {
        -- normal_hl = "Normal",
        winblend = 0, -- makes it normal
      },
    },
  },
}
