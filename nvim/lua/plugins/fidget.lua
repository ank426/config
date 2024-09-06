return {
	{
		"j-hui/fidget.nvim",
		config = function()
			local fidget = require("fidget")
			fidget.setup({
				notification = {
					window = {
						-- normal_hl = "Identifier",
						winblend = 0,
					},
				},
			})
			vim.notify = fidget.notify
		end,
	},
}
