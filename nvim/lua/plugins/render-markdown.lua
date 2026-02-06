return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  ft = "markdown",
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
      -- backgrounds = {
      --   "Function",
      --   "Constant",
      --   "String",
      --   "Type",
      --   "Number",
      --   "Operator",
      -- }
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
      highlight_inline = "none",
    },
    pipe_table = {
      preset = "round",
      -- border_virtual = true, -- enabled by default cuz indent is enabled
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
      list = {
        rendered = false,
      },
      showbreak = {
        rendered = "NONE",
      },
    },
    yaml = {
      enabled = false,
    },
  },
}
