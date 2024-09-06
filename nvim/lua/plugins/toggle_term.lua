return {
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		config = function()
			require("toggleterm").setup({
				open_mapping = [[<C-/>]],
				insert_mappings = false,
				direction = "float",
			})
		end,
	},
}
