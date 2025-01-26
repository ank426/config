return {
  "akinsho/toggleterm.nvim",
  keys = {
    "<C-/>",
    "<leader>lg",
    { "<leader>st", vim.cmd.TermSelect, desc = "[S]earch [T]erminals" },
  },
  opts = {
    open_mapping = "<C-/>",
    direction = "float",
    float_opts = { border = "rounded" },
  },
  config = function(_, opts)
    require("toggleterm").setup(opts)

    local lazygit_term = require("toggleterm.terminal").Terminal:new({ cmd = "lazygit", hidden = true })
    vim.keymap.set("n", "<leader>lg", function() lazygit_term:toggle() end)
  end,
}
