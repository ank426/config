return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  ---@module 'render-markdown'
  ---@type render.md.UserConfig
  opts = {
    anti_conceal = {
      enabled = false,
    },
    latex = {
      enabled = false,
    },
    completions = {
      lsp = {
        enabled = true,
      },
    },
    heading = {
      position = "inline",
      backgrounds = {
        "bold",
        "bold",
        "bold",
        "bold",
        "bold",
        "bold",
      },
    },
    code = {
      position = "right",
      disable_background = true,
      width = "block",
      left_pad = 4,
      right_pad = 4,
      border = "none",
      highlight_border = "none",
    },
    pipe_table = {
      preset = "round",
      border_virtual = true,
    },
    sign = {
      enabled = false,
    },
    indent = {
      enabled = true,
      icon = "",
    },
    html = {
      enabled = false,
    },
    win_options = {
      showbreak = {
        rendered = "NONE",
      },
    },
    yaml = {
      enabled = false,
    },
  },
}
