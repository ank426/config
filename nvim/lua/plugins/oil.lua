-- Tough (but possible) to lazy-load
return {
  "stevearc/oil.nvim",
  dependencies = {"nvim-tree/nvim-web-devicons"},
  lazy = false,
  keys = {
    { "-", vim.cmd.Oil, desc = "Open parent directory" },
  },
  init = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "oil",
      command = "set commentstring=%s.bak",
    })
  end,
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
    },
    use_default_keymaps = false,
    view_options = {
      show_hidden = true,
      is_always_hidden = function(name, _) return name == ".." end,
    },
  },
}
