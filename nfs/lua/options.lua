vim.opt.breakindent = true
vim.opt.cinkeys:remove(":")
vim.opt.clipboard = "unnamed" -- Vim's clipboard system is seriously fucked. Just use * for internal and + for external
vim.opt.expandtab = true
vim.opt.formatoptions:remove("o")
vim.opt.guicursor:append("c:ver25")
vim.opt.ignorecase = true
vim.opt.inccommand = "split"
vim.opt.list = true
vim.opt.listchars = { trail = "~" }
vim.opt.matchpairs:append("<:>")
vim.opt.mouse = ""
vim.opt.nrformats:append("unsigned")
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "auto:2-9" -- One for gitsigns and one for diagnostics
vim.opt.scrolloff = 999
vim.opt.shiftwidth = 2
vim.opt.showbreak = "+++ "
vim.opt.showmode = false
vim.opt.sidescrolloff = 5
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.smoothscroll = true
vim.opt.softtabstop = 2
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.tabstop = 4
vim.opt.textwidth = 150
