vim.keymap.set("n", "<esc>", "<cmd>nohlsearch|diffupdate|normal! <C-l><cr>", { desc = "Nvim's redraw" })
vim.keymap.set("t", "<esc><esc>", "<C-\\><C-n>", { desc = "Normal mode in terminal" })
vim.keymap.set("n", "<leader>=", "mzgg=G`z", { desc = "Reindent file" })

vim.keymap.set("n", "<leader><leader>x", "<cmd>.lua<cr>", { desc = "E[x]ecute line (lua)" })
vim.keymap.set("v", "<leader><leader>x", ":lua<cr>", { desc = "E[x]ecute (lua)" })

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "System Yank" })
vim.keymap.set({ "n", "v" }, "<leader>Y", [["+y$]], { desc = "System Yank" }) -- Y=yy in maps as per old behavior unless remap=true
vim.keymap.set({ "n", "v" }, "<leader>p", [["+p]], { desc = "System Paste" })
vim.keymap.set({ "n", "v" }, "<leader>P", [["+P]], { desc = "System Paste" })
-- vim.keymap.set({ "n", "v" }, "<leader>d", [["+d]], { desc = "System Delete" })
-- vim.keymap.set({ "n", "v" }, "<leader>D", [["+D]], { desc = "System Delete" })

vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move focus to the upper window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move focus to the right window" })

local confpath = vim.fn.stdpath("config")
vim.keymap.set("n", "<leader>en", "<cmd>edit "..confpath.."<cr>", { desc = "[E]dit [N]eovim" })
vim.keymap.set("n", "<leader>ei", "<cmd>edit "..confpath.."/init.lua<cr>", { desc = "[E]dit [I]nit" })
vim.keymap.set("n", "<leader>el", "<cmd>edit "..confpath.."/lua<cr>", { desc = "[E]dit [L]ua" })
vim.keymap.set("n", "<leader>ep", "<cmd>edit "..confpath.."/lua/plugins<cr>", { desc = "[E]dit [P]lugins" })
vim.keymap.set("n", "<leader>eg", "<cmd>edit "..confpath.."/lua/globals.lua<cr>", { desc = "[E]dit [G]lobals" })
vim.keymap.set("n", "<leader>eo", "<cmd>edit "..confpath.."/lua/options.lua<cr>", { desc = "[E]dit [O]ptions" })
vim.keymap.set("n", "<leader>ek", "<cmd>edit "..confpath.."/lua/keymaps.lua<cr>", { desc = "[E]dit [K]eymaps" })
vim.keymap.set("n", "<leader>ea", "<cmd>edit "..confpath.."/lua/autocommands.lua<cr>", { desc = "[E]dit [A]utocommands" })
vim.keymap.set("n", "<leader>eu", "<cmd>edit "..confpath.."/lua/user-commands.lua<cr>", { desc = "[E]dit [U]ser-commands" })
vim.keymap.set("n", "<leader>ed", "<cmd>edit "..confpath.."/lua/diagnostics.lua<cr>", { desc = "[E]dit [D]iagnostics" })
vim.keymap.set("n", "<leader>ez", "<cmd>edit "..confpath.."/lua/lazy-nvim.lua<cr>", { desc = "[E]dit La[z]y-nvim" })
vim.keymap.set("n", "<leader>ef", "<cmd>edit "..confpath.."/ftplugin<cr>", { desc = "[E]dit [F]tplugin" })
vim.keymap.set("n", "<leader>Ef", "<cmd>edit "..confpath.."/after/ftplugin<cr>", { desc = "[E]dit After/[F]tplugin" })

-- -- Will soon be added to neovim
-- vim.keymap.set("n", "grn", vim.lsp.buf.rename, { desc = "LSP: Rename" })
-- vim.keymap.set("n", "gra", vim.lsp.buf.code_action, { desc = "LSP: Code Actions" })
-- vim.keymap.set("n", "grr", vim.lsp.buf.references, { desc = "LSP: References" })
-- vim.keymap.set("n", "gri", vim.lsp.buf.implementation, { desc = "LSP: Implementation" })
-- vim.keymap.set("n", "gO", vim.lsp.buf.document_symbol, { desc = "LSP: Document Symbols" })
-- vim.keymap.set("i", "<C-s>", vim.lsp.buf.signature_help, { desc = "LSP: Signature Help" })

-- Mine
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "LSP: [G]oto [D]eclaration" })
vim.keymap.set("n", "grf", vim.lsp.buf.format, { desc = "LSP: [F]ormat" })
vim.keymap.set("n", "grt", vim.lsp.buf.type_definition, { desc = "LSP: Goto [T]ype Definition" })
vim.keymap.set("n", "grT", vim.lsp.buf.typehierarchy, { desc = "LSP: [T]ype Hierarchy" })
vim.keymap.set("n", "grw", vim.lsp.buf.workspace_symbol, { desc = "LSP: [W]orkspace Symbols" })
