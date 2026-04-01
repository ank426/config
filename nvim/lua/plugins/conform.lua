return {
  "stevearc/conform.nvim",
  event = "VeryLazy",
  keys = {
    {
      "<leader>fm",
      function()
        require("conform").format({ async = true })
      end,
      desc = "[F]or[m]at buffer",
    },
  },
  opts = {
    formatters_by_ft = {
      javascript = {"biome"},
      python = {"ruff_fix", "ruff_format"},
      rust = {"rustfmt"},
      typescript = {"biome"},
    },
    default_format_opts = {
      timeout_ms = 500,
    },
    format_on_save = function(bufnr)
      if not vim.g.autoformat then
        return
      end
      if vim.g.formatters then
        return { formatters = vim.g.formatters[vim.bo[bufnr].filetype] or {} }
      end
      return {}
    end,
  },
}
