-- Variables
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

--Options
vim.opt.breakindent = true
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

-- Keymaps
vim.keymap.set("n", "<esc>", "<cmd>nohlsearch|diffupdate|normal! <c-l><cr>", { desc = "Nvim's redraw" })
vim.keymap.set("n", "<leader>=", "mzgg=g`z", { desc = "Reindent file" })
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set({"n", "v"}, "<leader>Y", [["+y$]]) -- Y=yy in maps as per old behavior unless remap=true
vim.keymap.set({"n", "v"}, "<leader>p", [["+p]])
vim.keymap.set({"n", "v"}, "<leader>P", [["+P]])
vim.keymap.set({"n", "v"}, "<leader>d", [["+d]])
vim.keymap.set({"n", "v"}, "<leader>D", [["+D]])
vim.keymap.set("n", "<c-h>", "<c-w>h", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<c-j>", "<c-w>j", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<c-k>", "<c-w>k", { desc = "Move focus to the upper window" })
vim.keymap.set("n", "<c-l>", "<c-w>l", { desc = "Move focus to the right window" })

-- Autocommands
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


-- User defined commands

-- Modified from help-curwin (to not mess up jumplist)
vim.api.nvim_create_user_command("H", function(opts)
  local flag = false
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    local filetype = vim.api.nvim_buf_get_option(buf, 'filetype')
    flag = flag or (filetype == 'help')
  end

  local subject = opts.args
  local mods = "silent noautocmd keepalt "
  if #vim.fn.getcompletion(subject, "help") == 0 then
    success, error_message = pcall(vim.cmd, "help "..subject)
    print(error_message:match("E%d+:.*$"))
  elseif flag then
    vim.cmd(mods.."help "..subject)
    vim.bo.buftype = "help"
    vim.bo.filetype = "help"
  else
    vim.cmd(mods.."help "..subject)
    local path = vim.fn.expand("%:p")
    vim.cmd(mods.."helpclose")
    vim.cmd(mods.."edit "..path)
    vim.bo.buftype = "help"
    vim.bo.filetype = "help"
  end
end, {
  desc = "Help in current window",
  nargs = "?",
  complete = "help",
  bar = true,
})
vim.cmd.cnoreabbrev([[<expr> h getcmdtype() == ":" && getcmdline() == 'h' ? 'H' : 'h']])


-- Lazy.nvim
require("lazy-nvim")
