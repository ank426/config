return {
  "rebelot/kanagawa.nvim",
  priority = 1000,
  opts = {
    transparent = true,
    colors = {
      theme = {
        all = {
          ui = {
            bg = "none",
            bg_gutter = "none",
          },
        },
      },
    },
    overrides = function(_)
      return {
        NormalFloat = { bg = "none" },
        FloatBorder = { bg = "none" },
        FloatTitle = { bg = "none" },
        Pmenu = { bg = "none" },
      }
    end,
    theme="wave",
    background = {
        dark = "wave",
        light = "lotus",
    },
  },
}
