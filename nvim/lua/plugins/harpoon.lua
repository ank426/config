return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  init = function()
    -- Can lead to weird errors if harpoon dir missing
    for _, file in ipairs(vim.fn.glob(vim.fn.stdpath("data").."/harpoon/*", false, true)) do
      vim.fn.delete(file)
      -- vim.notify(file)
    end
  end,
  keys = {
    { "<leader>fo",  function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end },
    { "<leader>fa",  function() require("harpoon"):list():add() end },
    { "<leader>fj",  function() require("harpoon"):list():select(1) end },
    { "<leader>fk",  function() require("harpoon"):list():select(2) end },
    { "<leader>fl",  function() require("harpoon"):list():select(3) end },
    { "<leader>f;",  function() require("harpoon"):list():select(4) end },
    { "<leader>fdj", function() require("harpoon"):list():remove_at(1) end },
    { "<leader>fdk", function() require("harpoon"):list():remove_at(2) end },
    { "<leader>fdl", function() require("harpoon"):list():remove_at(3) end },
    { "<leader>fd;", function() require("harpoon"):list():remove_at(4) end },
    { "<leader>frj", function() require("harpoon"):list():replace_at(1) end },
    { "<leader>frk", function() require("harpoon"):list():replace_at(2) end },
    { "<leader>frl", function() require("harpoon"):list():replace_at(3) end },
    { "<leader>fr;", function() require("harpoon"):list():replace_at(4) end },
    { "<leader>fc",  function() require("harpoon"):list():clear() end },
    { "<leader>fp",  function() require("harpoon"):list():prev() end },
    { "<leader>fn",  function() require("harpoon"):list():next() end },
  },
  opts = {
    settings = {
      save_on_toggle = false,
      save_on_change = false,
    },
  },
}
