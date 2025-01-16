return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "BufEnter",
  opts = {},
  config = function(_, opts)
    local alpha = {
      filetypes = {"alpha"},
      sections = {
        lualine_a = {"mode"},
        lualine_b = {"branch", "diff"},
        lualine_c = { function() return vim.fn.fnamemodify(vim.fn.getcwd(), ":~") end },
        lualine_x = {"filetype"},
        lualine_y = {"progress"},
        lualine_z = {"location"},
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {"filename"},
        lualine_x = {"location"},
        lualine_y = {},
        lualine_z = {},
      },
    }

    -- check official plugin
    local oil = {
      filetypes = {"oil"},
      sections = {
        lualine_a = {"mode"},
        lualine_b = {"branch", "diff"},
        lualine_c = { function() return vim.fn.fnamemodify(require("oil").get_current_dir(), ":~") end },
        lualine_x = {"filetype"},
        lualine_y = {"progress"},
        lualine_z = {"location"},
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {"filename"},
        lualine_x = {"location"},
        lualine_y = {},
        lualine_z = {},
      },
    }

    opts.extensions = {
      alpha,
      "lazy",
      "man",
      oil,
      "toggleterm",
    }
    require("lualine").setup(opts)
  end,
}
