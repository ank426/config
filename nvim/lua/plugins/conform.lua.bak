return {
	{
		"stevearc/conform.nvim",
		config = function()
			require("conform").setup({
				formatters = {
					clang_format = {
						command = "clang-format",
						args = {
							"-style={IndentWidth: 4}",
						},
					},
				},
				formatters_by_ft = {
					c = { "clang_format" },
					javascript = { "prettier" },
					lua = { "stylua" },
					python = { "isort", "black" },
					typescript = { "prettier" },
				},
				format_on_save = {
					timeout_ms = 500,
					lsp_fallback = true,
				},
			})
			vim.keymap.set("", "<leader>f", function()
				require("conform").format({ async = true, lsp_fallback = true })
			end, { desc = "[F]ormat buffer" })
		end,
	},
}
