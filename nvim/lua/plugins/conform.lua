return {
  "stevearc/conform.nvim",
  event = "VeryLazy",
  opts = {
    formatters_by_ft = {
      python = { "ruff_fix" },
    },
    default_format_opts = {
      lsp_fallback = true,
    },
    format_on_save = {
      timeout_ms = 500,
      lsp_fallback = true,
    },
  },
  config = function(_, opts)
    require("conform").setup(opts)
    vim.keymap.set("", "<leader>f", require("conform").format, { desc = "[F]ormat buffer" })
  end,
}
