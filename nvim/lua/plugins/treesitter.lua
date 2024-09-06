---@diagnostic disable: missing-fields
return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			-- ruby and other stuff may be weird. check kickstart
			require("nvim-treesitter.configs").setup({
				-- ensure_installed = {
				-- 	"bash",
				-- 	"c",
				-- 	"cpp",
				-- 	"css",
				-- 	"csv",
				-- 	"diff",
				-- 	"go",
				-- 	"javascript",
				-- 	"json",
				-- 	"json5",
				-- 	"lua",
				-- 	"luadoc",
				-- 	"markdown",
				-- 	"markdown_inline",
				-- 	"python",
				-- 	"query",
				-- 	"regex",
				-- 	"typescript",
				-- 	"vim",
				-- 	"vimdoc",
				-- 	"yaml",
				-- },
				auto_install = true,
				highlight = { enable = true },
				indent = { enable = true },
			})

			vim.treesitter.language.register("bash", "zsh")
		end,
	},
}
