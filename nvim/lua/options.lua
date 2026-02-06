vim.opt.breakindent = true
vim.opt.cinkeys:remove(":")
vim.opt.clipboard = "unnamed" -- Vim's clipboard system is seriously fucked. Just use * for internal and + for external
vim.opt.confirm = true
vim.opt.completeopt:append("noselect")
vim.opt.completeopt:append("fuzzy")
vim.opt.expandtab = true
vim.opt.exrc = true
vim.opt.fillchars:append({ eob = " "})
vim.opt.formatoptions:remove("o")
-- vim.opt.guicursor:append("c:ver25") -- Done in autocommands
vim.opt.ignorecase = true
vim.opt.inccommand = "split"
vim.opt.list = true
vim.opt.listchars = { tab = "-->", trail = "~" }
vim.opt.matchpairs:append("<:>")
vim.opt.mouse = ""
vim.opt.nrformats:append("unsigned")
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "auto:2-9" -- One for gitsigns and one for diagnostics
vim.opt.scrolloff = 9999
vim.opt.shada = {}
vim.opt.shiftwidth = 2
vim.opt.showbreak = "+++ "
vim.opt.showmode = false
vim.opt.sidescrolloff = 5
vim.opt.smartcase = true
-- vim.opt.smartindent = true -- Doesn't indent python comments when i use > or <
vim.opt.smoothscroll = true
vim.opt.softtabstop = 2
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.switchbuf = {"useopen", "usetab", "uselast"}
vim.opt.tabstop = 4
vim.opt.textwidth = 0


vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.g.python_recommended_style = false -- Disables nvim setting 4 space. Otherwise random unpredictable things get fucked
