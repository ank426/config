-- vim.fn.stdpath("data").."/lazy/kanagawa.nvim/lua/lualine/themes/kanagawa.lua"
-- https://github.com/rebelot/kanagawa.nvim/blob/master/lua/lualine/themes/kanagawa.lua
local function custom_kanagawa()
  local theme = require("kanagawa.colors").setup({theme = "wave"}).theme
  return {
    normal = {
      a = { fg = theme.syn.fun, gui = "bold" },
      b = { fg = theme.syn.fun },
      c = { fg = theme.ui.fg },
    },
    insert = {
      a = { fg = theme.diag.ok, gui = "bold" },
      b = { fg = theme.diag.ok },
    },
    command = {
      a = { fg = theme.syn.operator, gui = "bold" },
      b = { fg = theme.syn.operator },
    },
    visual = {
      a = { fg = theme.syn.keyword, gui = "bold" },
      b = { fg = theme.syn.keyword },
    },
    replace = {
      a = { fg = theme.syn.constant, gui = "bold" },
      b = { fg = theme.syn.constant },
    },
    inactive = {
      b = { fg = theme.ui.fg_dim, gui = "bold" },
      c = { fg = theme.ui.fg_dim },
    },
  }
end

local alpha = {
  filetypes = {"alpha"},
  sections = {
    lualine_a = {"mode"},
    lualine_b = {"branch", "diff"},
    lualine_c = {function() return vim.fn.fnamemodify(vim.fn.getcwd(), ":~") end},
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
    lualine_c = {function() return vim.fn.fnamemodify(require("oil").get_current_dir() or "", ":~") end},
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

return {
  "nvim-lualine/lualine.nvim",
  dependencies = {"nvim-tree/nvim-web-devicons"},
  event = "VeryLazy",
  opts = {
    options = {
      theme = custom_kanagawa,
    },
    extensions = {
      alpha,
      "lazy",
      "man",
      oil,
      "toggleterm",
      -- "trouble", -- I cannot get trouble to work. Extension is outdated see statusline component in trouble help
    },
  },
}
