return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  keys = {
    { "<leader>?", function() require("which-key").show({ global = false }) end, desc = "Buffer Local Keymaps (which-key)" },
  },
  opts = {
    spec = {
      { "<leader>e", group = "[E]dit "..vim.fn.fnamemodify(vim.fn.stdpath("config") --[[@as string]], ":~") },
      { "<leader>E", group = "[E]dit "..vim.fn.fnamemodify(vim.fn.stdpath("config") --[[@as string]].."/after", ":~") },
      { "<leader>s", group = "[S]earch (Telescope)" },
      { "<leader>x", group = "Trouble" },
    },
    win = {
      no_overlap = false,
    },
  },
}
