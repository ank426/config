vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight on yank",
  callback = function() vim.highlight.on_yank() end, -- Needs function wrapping cuz callback passes arguments
})

vim.api.nvim_create_autocmd({"VimLeave", "VimSuspend"}, {
  desc = "Fix cursor on quit/suspend",
  command = "set guicursor=a:ver25",
})

vim.api.nvim_create_autocmd("StdinReadPost", {
  desc = "Mark as unmodified when reading from stdin",
  command = "set nomodified",
})

vim.api.nvim_create_autocmd("InsertEnter", {
  desc = "Turn off opt.list in insert mode",
  command = "set nolist",
})
vim.api.nvim_create_autocmd("InsertLeave", {
  desc = "Turn on opt.list when out of insert mode",
  command = "if &filetype != 'help' | set list | endif" -- Not working in ftplugin/help.lua for some reason
})
