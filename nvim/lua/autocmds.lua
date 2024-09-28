vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

local cursor_group = vim.api.nvim_create_augroup("CursorShapeFix", { clear = true })

vim.api.nvim_create_autocmd({ "VimEnter", "VimResume" }, {
	group = cursor_group,
	callback = function()
		vim.opt.guicursor = {
			"n-v-c:block",
			"i-ci-ve:ver25",
			"r-cr:hor20",
			"o:hor50",
			"a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor",
			"sm:block-blinkwait175-blinkoff150-blinkon175",
		}
	end,
})

vim.api.nvim_create_autocmd({ "VimLeave", "VimSuspend" }, {
	group = cursor_group,
	callback = function()
		vim.opt.guicursor = "a:ver25-blinkon0"
	end,
})

-- Display diagnostics as virtual text only if not in insert mode
vim.api.nvim_create_autocmd("InsertEnter", {
  pattern = "*",
  callback = function()
    vim.diagnostic.config({
      virtual_text = false,
    })
  end
})
vim.api.nvim_create_autocmd("InsertLeave", {
  pattern = "*",
  callback = function()
    vim.diagnostic.config({
      virtual_text = true,
    })
  end
})
