require("globals")
require("options")
require("keymaps")
require("autocommands")
require("user-commands")
vim.hl = vim.highlights -- Remove when nvim>=10.4
require("lazy-nvim")
vim.cmd.colorscheme("tokyonight")
