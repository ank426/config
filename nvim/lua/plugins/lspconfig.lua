return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "williamboman/mason.nvim", opts = {} },
			{ "williamboman/mason-lspconfig.nvim", opts = {} },
			{
				"WhoIsSethDaniel/mason-tool-installer.nvim",
				config = function()
					require("mason-tool-installer").setup({
						ensure_installed = {
							-- bash
							"bashls",
							-- c
							"clangd",
							"clang-format",
							-- lua
							"lua_ls",
							"stylua",
							-- python
							"pyright",
							"black",
							"isort",
							-- typescript
							"tsserver",
							"prettier",
						},
					})
				end,
			},
			{ "j-hui/fidget.nvim", opts = {} },
			{ "folke/neodev.nvim", opts = {} },
		},
		config = function()
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

			require("lspconfig").bashls.setup({ capabilities = capabilities })
			require("lspconfig").clangd.setup({ capabilities = capabilities })
			require("lspconfig").lua_ls.setup({ capabilities = capabilities })
			require("lspconfig").pyright.setup({
				capabilities = capabilities,
				settings = {
					python = {
						analysis = {
							typeCheckingMode = "off",
							diagnosticSeverityOverrides = {
								reportMissingImports = "none", -- Suppress missing import warnings
							},
						},
					},
				},
			})
			require("lspconfig").tsserver.setup({ capabilities = capabilities })

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc)
						vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					local builtin = require("telescope.builtin")
					map("gd", builtin.lsp_definitions, "[G]oto [D]efinition")
					map("gr", builtin.lsp_references, "[G]oto [R]eferences")
					map("gI", builtin.lsp_implementations, "[G]oto [I]mplementation")
					map("<leader>D", builtin.lsp_type_definitions, "Type [D]efinition")
					map("<leader>ds", builtin.lsp_document_symbols, "[D]ocument [S]ymbols")
					map("<leader>ws", builtin.lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
					map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
					map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
					map("K", vim.lsp.buf.hover, "Hover Documentation")
					map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
				end,
			})
		end,
	},
}
