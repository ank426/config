return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = {"nvim-lua/plenary.nvim"},
  init = function()
    -- Can lead to weird errors if harpoon dir missing
    for _, file in ipairs(vim.fn.glob(vim.fn.stdpath("data").."/harpoon/*", false, true)) do
      vim.fn.delete(file)
      -- vim.notify(file)
    end
  end,
  keys = {
    { "<leader>fo",  function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end, desc = "Harpoon Toggle Menu" },
    { "<leader>fa",  function() require("harpoon"):list():add() end,         desc = "Harpoon Add" },
    { "<leader>fc",  function() require("harpoon"):list():clear() end,       desc = "Harpoon Clear" },
    { "<leader>fj",  function() require("harpoon"):list():select(1) end,     desc = "Harpoon Select 1" },
    { "<leader>fk",  function() require("harpoon"):list():select(2) end,     desc = "Harpoon Select 2" },
    { "<leader>fl",  function() require("harpoon"):list():select(3) end,     desc = "Harpoon Select 3" },
    { "<leader>f;",  function() require("harpoon"):list():select(4) end,     desc = "Harpoon Select 4" },
    { "<leader>f'",  function() require("harpoon"):list():select(5) end,     desc = "Harpoon Select 5" },
    { "<leader>fdj", function() require("harpoon"):list():remove_at(1) end,  desc = "Harpoon Delete 1" },
    { "<leader>fdk", function() require("harpoon"):list():remove_at(2) end,  desc = "Harpoon Delete 2" },
    { "<leader>fdl", function() require("harpoon"):list():remove_at(3) end,  desc = "Harpoon Delete 3" },
    { "<leader>fd;", function() require("harpoon"):list():remove_at(4) end,  desc = "Harpoon Delete 4" },
    { "<leader>fd'", function() require("harpoon"):list():remove_at(5) end,  desc = "Harpoon Delete 5" },
    { "<leader>frj", function() require("harpoon"):list():replace_at(1) end, desc = "Harpoon Replace 1" },
    { "<leader>frk", function() require("harpoon"):list():replace_at(2) end, desc = "Harpoon Replace 2" },
    { "<leader>frl", function() require("harpoon"):list():replace_at(3) end, desc = "Harpoon Replace 3" },
    { "<leader>fr;", function() require("harpoon"):list():replace_at(4) end, desc = "Harpoon Replace 4" },
    { "<leader>fr'", function() require("harpoon"):list():replace_at(5) end, desc = "Harpoon Replace 5" },
    { "<leader>fp",  function() require("harpoon"):list():prev() end,        desc = "Harpoon Previous" },
    { "<leader>fn",  function() require("harpoon"):list():next() end,        desc = "Harpoon Next" },
  },
  opts = {
    settings = {
      save_on_toggle = false,
      save_on_change = false,
    },
  },
}
