return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  build = ":TSUpdate",
  config = function()
    local ts = require("nvim-treesitter")
    local include = {}
    local exclude = {"mermaid"}
    ts.install(
      vim.iter({ts.get_available(1), ts.get_available(2), include})
        :flatten()
        :filter(function(p) return not vim.list_contains(exclude, p) end)
        :totable()
    )
    ts.uninstall(
      vim.iter({ts.get_available(3), ts.get_available(4), exclude})
        :flatten()
        :filter(function(p) return not vim.list_contains(include, p) end)
        :totable()
    )
  end,
}

-- check out nvim-treesitter-textobjects and nvim-treesitter-subjects
