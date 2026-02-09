_G.oil_toggle_bak_operator = function()
  local s, e = vim.fn.line("'["), vim.fn.line("']")
  local comment = false
  for _, line in ipairs(vim.api.nvim_buf_get_lines(0, s-1, e, false)) do
    if line and not line:match("%.bak/?$") then
      comment = true
      break
    end
  end
  if comment then
    vim.cmd(s..","..e..[[s#\(/\?\)$#.bak\1#]])
  else
    vim.cmd(s..","..e..[[s#.bak\(/\?\)$#\1#]])
  end
  vim.cmd.nohlsearch()
end

-- Tough (but possible) to lazy-load
return {
  "stevearc/oil.nvim",
  dependencies = {"nvim-tree/nvim-web-devicons"},
  lazy = false,
  keys = {
    { "-", vim.cmd.Oil, desc = "Open parent directory" },
  },
  opts = {
    skip_confirm_for_simple_edits = true,
    keymaps = {
      ["g?"] = "actions.show_help",
      ["<CR>"] = "actions.select",
      -- ["<C-v>"] = { "actions.select", opts = { vertical = true }, desc = "Open the entry in a vertical split" },
      ["<C-s>"] = { "actions.select", opts = { horizontal = true }, desc = "Open the entry in a horizontal split" },
      ["<C-t>"] = { "actions.select", opts = { tab = true }, desc = "Open the entry in new tab" },
      ["<C-p>"] = "actions.preview",
      ["<C-c>"] = "actions.close",
      -- ["<C-l>"] = "actions.refresh",
      ["-"] = "actions.parent",
      ["_"] = "actions.open_cwd",
      ["`"] = "actions.cd",
      ["~"] = { "actions.cd", opts = { scope = "tab" }, desc = ":tcd to the current oil directory" },
      ["gs"] = "actions.change_sort",
      ["gx"] = "actions.open_external",
      ["g."] = "actions.toggle_hidden",
      ["g\\"] = "actions.toggle_trash",
      ["gc"] = {
        callback = function()
          vim.o.operatorfunc = "v:lua.oil_toggle_bak_operator"
          return "g@"
        end,
        expr = true,
        desc = "Toggle .bak extension",
      },
      ["gcc"] = {
        callback = function()
          vim.o.operatorfunc = "v:lua.oil_toggle_bak_operator"
          return "g@_"
        end,
        expr = true,
        desc = "Toggle .bak extension",
      },
    },
    use_default_keymaps = false,
    view_options = {
      show_hidden = true,
      is_always_hidden = function(name, _) return name == ".." end,
    },
  },
}
