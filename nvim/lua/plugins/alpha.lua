return {
  "goolord/alpha-nvim",
  config = function()
    local dashboard = require("alpha.themes.dashboard")

    dashboard.section.buttons.val = {
      dashboard.button("n", "  New file", "<cmd>ene<CR>"),
      dashboard.button("f", "  Find file", ":Telescope find_files<CR>"),
      dashboard.button("r", "  Recent files", ":Telescope oldfiles<CR>"),
      dashboard.button("g", "󰊄  Find text", ":Telescope live_grep<CR>"),
      dashboard.button("c", "  Config", ":Telescope find_files cwd=" .. vim.fn.stdpath("config") .. "<CR>"),
      -- dashboard.button("s", "  Restore session"),
      dashboard.button("l", "󰒲  Lazy", ":Lazy<CR>"),
      dashboard.button("q", "  Quit", ":qa<CR>"),
      -- dashboard.button("SPC f r", "  Frecency/MRU"),
      -- dashboard.button("SPC f g", "󰈬  Find word"),
      -- dashboard.button("SPC f m", "  Jump to bookmarks"),
    }

    require("alpha").setup(dashboard.opts)
  end,
}
