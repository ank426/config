-- Modified from help-curwin (to not mess up jumplist)
vim.api.nvim_create_user_command("H", function(opts)
  local no_helps_open = true
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    local filetype = vim.api.nvim_get_option_value("filetype", { buf = buf })
    no_helps_open = no_helps_open and (filetype ~= "help")
  end

  local subject = opts.args
  if #vim.fn.getcompletion(subject, "help") > 0 then
    -- local mods = "silent noautocmd keepalt "
    vim.cmd("help "..subject)
    if no_helps_open then
      local path = vim.fn.expand("%:p")
      local cur_pos = vim.api.nvim_win_get_cursor(0) -- Needed to fix bug where help file is already open to a diff pos
      vim.cmd.helpclose()
      vim.cmd.edit(path)
      vim.api.nvim_win_set_cursor(0, cur_pos)
    end
    vim.opt.buftype = "help"
    -- vim.opt.filetype = "help"
    -- vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false) -- Change to normal mode
  else
    local _, error_message = pcall(vim.cmd.help, subject)
    print(error_message:match("E%d+:.*$"))
  end
end, {
  desc = "Help in current window",
  nargs = "?",
  complete = "help",
  bar = true,
})
vim.cmd.cnoreabbrev([[<expr> h getcmdtype() == ":" && getcmdline() == 'h' ? 'H' : 'h']])
