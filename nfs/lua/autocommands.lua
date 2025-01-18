vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight on yank",
  callback = function() vim.highlight.on_yank() end, -- Needs function wrapping cuz callback passes arguments
})

vim.api.nvim_create_autocmd({ "VimLeave", "VimSuspend" }, {
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


vim.api.nvim_create_autocmd("LspAttach", {
  desc = "Autoformat on save",
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then return end

    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = args.buf,
        callback = function()
          vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
        end,
      })
    end
  end,
})
