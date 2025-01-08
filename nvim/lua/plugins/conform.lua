return {
  "stevearc/conform.nvim",
  event = "VeryLazy",
  opts = {
    formatters_by_ft = {
      python = { lsp_format = "never" },
      cpp = { lsp_format = "never" },
      -- python = { "ruff_fix" },
    },
    default_format_opts = {
      lsp_format = "fallback",
    },
    format_on_save = function(bufnr)
      if vim.api.nvim_get_option_value("filetype", { buf = bufnr }) == "python" then
        return nil
      else
        return {
          lsp_format = "fallback",
          timeout_ms = 500,
        }
      end
    end,
  },
  config = function(_, opts)
    require("conform").setup(opts)
    vim.keymap.set("", "<leader>fm", require("conform").format, { desc = "[F]or[m]at buffer" })
  end,
}
