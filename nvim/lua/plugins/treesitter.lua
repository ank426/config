return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    local ts = require("nvim-treesitter")
    ts.install({"stable", "unstable"})
    ts.uninstall({"unmaintained", "unsupported"})
  end,
}

-- check out nvim-treesitter-textobjects and nvim-treesitter-subjects
