vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight on yank",
  callback = function() vim.highlight.on_yank() end, -- Needs function wrapping cuz callback passes arguments
})

vim.api.nvim_create_autocmd("StdinReadPost", {
  desc = "Mark as unmodified when reading from stdin",
  command = "set nomodified",
})

vim.api.nvim_create_autocmd({"VimEnter", "VimResume"}, {
  desc = "Fix cursor on enter/resume",
  callback = function()
    vim.cmd.set("guicursor&")
    vim.opt.guicursor:append("c:ver25")
  end,
})
vim.api.nvim_create_autocmd({"VimLeave", "VimSuspend"}, {
  desc = "Fix cursor on quit/suspend",
  command = "set guicursor=a:ver25", -- Not working on suspend for some reason
})

vim.api.nvim_create_autocmd("InsertEnter", {
  desc = "Turn off opt.list in insert mode",
  command = "set nolist",
})
vim.api.nvim_create_autocmd("InsertLeave", {
  desc = "Turn on opt.list on leaving insert mode",
  command = "if &filetype != 'help' | set list | endif", -- Not working in ftplugin/help.lua for some reason
})

vim.api.nvim_create_autocmd("InsertEnter", {
  desc = "Hide diagnostics in insert mode",
  callback = function() vim.diagnostic.hide() end,
})
vim.api.nvim_create_autocmd("InsertLeave", {
  desc = "Show diagnostics on leaving insert mode",
  callback = function() vim.diagnostic.show() end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  desc = "Remove trailing whitespace on save",
  command = [[%s/\s\+$//e]],
})

vim.api.nvim_create_autocmd("BufWritePre", {
  desc = "Remove trailing blank lines on save",
  command = [[%s/\($\n\)\+\%$//e]],
})

vim.api.nvim_create_autocmd("BufWritePre", {
  desc = "Autoindent on save",
  callback = function(args)
    if vim.tbl_contains({"python", "text", "lex", "yacc", "tex"}, vim.bo[args.buf].filetype) then return end

    local orig_win = vim.api.nvim_get_current_win()
    local orig_cursor = vim.api.nvim_win_get_cursor(orig_win)
    vim.api.nvim_set_current_buf(args.buf)
    vim.cmd("keepjumps normal! gg=G")
    vim.api.nvim_set_current_win(orig_win)
    vim.api.nvim_win_set_cursor(orig_win, orig_cursor)
  end,
})

-- vim.api.nvim_create_autocmd("LspAttach", {
--   desc = "Autoformat on save",
--   callback = function(args)
--     local client = vim.lsp.get_client_by_id(args.data.client_id)
--     if not client then return end
--     if not vim.tbl_contains({ "lua" }, vim.bo[args.buf].filetype) then return end
--     if not client:supports_method("textDocument/formatting") then return end
--
--     local id = vim.api.nvim_create_autocmd("BufWritePre", {
--       buffer = args.buf,
--       callback = function()
--         vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
--         vim.diagnostic.show() -- There is a bug that makes format hide diagnostics, so just show it for now
--       end,
--     })
--     vim.api.nvim_create_autocmd("LspDetach", {
--       buffer = args.buf,
--       once = true,
--       callback = function() vim.api.nvim_del_autocmd(id) end,
--     })
--   end,
-- })
