return {
  "goolord/alpha-nvim",
  config = function()
    local dashboard = require("alpha.themes.dashboard")

    dashboard.config.opts.notautocmd = true

    -- vim.cmd works but para is string, so better not to
    dashboard.section.buttons.val = {
      dashboard.button("n", "  New file", "<cmd>ene<cr>"),
      dashboard.button("f", "  Find file", "<cmd>Telescope find_files<cr>"),
      dashboard.button("r", "  Recent files", "<cmd>Telescope oldfiles<cr>"),
      dashboard.button("g", "󰊄  Find text", "<cmd>Telescope live_grep<cr>"),
      dashboard.button("c", "  Config", "<cmd>Telescope find_files cwd="..vim.fn.stdpath("config").."<cr>"),
      -- dashboard.button("s", "  Restore session"),
      dashboard.button("l", "󰒲  Lazy", "<cmd>Lazy<cr>"),
      dashboard.button("q", "  Quit", "<cmd>qa<cr>"),
      -- dashboard.button("SPC f r", "  Frecency/MRU"),
      -- dashboard.button("SPC f g", "󰈬  Find word"),
      -- dashboard.button("SPC f m", "  Jump to bookmarks"),
    }

    require("alpha").setup(dashboard.config)
  end,
}

