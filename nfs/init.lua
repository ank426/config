-- Variables
vim.g.mapleader = " "
vim.g.maplocalleader = " "

--Options
vim.opt.breakindent = true
vim.opt.clipboard:append("unnamed")
vim.opt.expandtab = true
vim.opt.formatoptions:remove("o")
vim.opt.ignorecase = true
vim.opt.inccommand = "split"
vim.opt.list = true
vim.opt.listchars = { trail = "~" }
vim.opt.matchpairs:append("<:>")
vim.opt.mouse = ""
vim.opt.nrformats:append("unsigned")
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 999
vim.opt.shiftwidth = 2
vim.opt.showbreak = "+++ "
-- vim.opt.showmode = false
vim.opt.sidescrolloff = 5
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.smoothscroll = true
vim.opt.softtabstop = 2
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.tabstop = 4
vim.opt.textwidth = 150

-- Keymaps
vim.keymap.set("n", "<esc>", "<cmd>nohlsearch|diffupdate|normal! <c-l><cr>", { desc = "Nvim's redraw" })
vim.keymap.set("n", "<Leader>=", "mzgg=G`z", { desc = "Reindent file" })
-- Vim's clipboard system is seriously fucked. Just use * for internal and + for external
vim.keymap.set({ "n", "v" }, "<Leader>y", [["+y]])
vim.keymap.set({ "n", "v" }, "<Leader>Y", [["+y$]]) -- Y=yy in maps as per old behavior
vim.keymap.set({ "n", "v" }, "<Leader>p", [["+p]])
vim.keymap.set({ "n", "v" }, "<Leader>P", [["+P]])
vim.keymap.set({ "n", "v" }, "<Leader>d", [["+d]])
vim.keymap.set({ "n", "v" }, "<Leader>D", [["+D]])
-- Window
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move focus to the upper window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move focus to the right window" })
-- vim.keymap.set("n", "<C-Left>", "<C-w><")
-- vim.keymap.set("n", "<C-Down>", "<C-w>+")
-- vim.keymap.set("n", "<C-Up>", "<C-w>-")
-- vim.keymap.set("n", "<C-Right>", "<C-w>>")

vim.api.nvim_create_autocmd("StdinReadPost", {
  callback = function()
    vim.opt.modified = false
  end
})
