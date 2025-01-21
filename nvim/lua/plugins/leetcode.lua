return {
  "kawre/leetcode.nvim",
  cmd = "Leet",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
  },
  opts = {
    lang = "python3",
    injector = {
      python3 = {
        before = true, -- Default imports which only work for python and java
      },
      c = {
        before = {
          "#include <stdio.h>",
          "#include <stdlib.h>",
          "#include <stdbool.h>",
          "#include <math.h>",
          "#include <string.h>",
        },
      },
    },
  },
  config = function(_, opts)
    require("leetcode").setup(opts)

    vim.keymap.set("n", "<leader>c", "<cmd>Leet console<cr>")
    vim.keymap.set("n", "<leader>d", "<cmd>Leet desc<cr>")
    vim.keymap.set("n", "<leader>D", "<cmd>Leet desc stats<cr>")
    vim.keymap.set("n", "<leader>h", "<cmd>Leet hints<cr>")
    vim.keymap.set("n", "<leader>i", "<cmd>Leet info<cr>")
    vim.keymap.set("n", "<leader>l", "<cmd>Leet lang<cr>")
    vim.keymap.set("n", "<leader>L", "<cmd>Leet last_submit<cr>")
    vim.keymap.set("n", "<leader>m", "<cmd>Leet menu<cr>")
    vim.keymap.set("n", "<leader>o", "<cmd>Leet open<cr>")
    vim.keymap.set("n", "<leader>q", "<cmd>Leet exit<cr>")
    vim.keymap.set("n", "<leader>r", "<cmd>Leet restore<cr>")
    vim.keymap.set("n", "<leader>R", "<cmd>Leet reset<cr>")
    vim.keymap.set("n", "<leader>t", "<cmd>Leet test<cr>")
    vim.keymap.set("n", "<leader><cr>", "<cmd>Leet submit<cr>")
    vim.keymap.set("n", "<leader><leader>d", "<cmd>Leet daily<cr>")
    vim.keymap.set("n", "<leader><leader>l", "<cmd>Leet list<cr>") -- optional args: status, difficulty (i think)
    vim.keymap.set("n", "<leader><leader>r", "<cmd>Leet random<cr>") -- optional args: status, difficulty, tags (i think)
    vim.keymap.set("n", "<leader><leader>sn", "<cmd>Leet session create<cr>")
    vim.keymap.set("n", "<leader><leader>sc", "<cmd>Leet session change<cr>")
    vim.keymap.set("n", "<leader><leader>su", "<cmd>Leet session update<r>")
    vim.keymap.set("n", "<leader><leader>t", "<cmd>Leet tabs<cr>")
    vim.keymap.set("n", "<leader><leader>y", "<cmd>Leet yank<cr>")

    vim.diagnostic.enable(false)
    require("lualine").setup({ sections = { lualine_b = {} } })
  end,
}

-- Images not working:
-- image_support option in leetcode.nvim
-- ueberzug works fine. the main problem is magick
-- the cli doesn't seem to work even with build = false
-- so you have to use luarocks
-- luarocks is installed by default
-- you need to install magick (it says dev version) for lua5.1. luajit is lua5.1. you don't need lua5.1 installed
-- you need to configure it to work locally, then modify a bunch of paths (luarocks --lua-version 5.1 path)
-- there might be a way to do the paths in nvim itself (check minimal-setup.lua)
-- test this out with $luajit, then require("magick")
-- then, you also need too do stuff to lazy-nvim.lua to make luarocks work (check leetcode.nvim docs)
-- follow image.nvim docs (use ueberzug and not kitty), then try the minimal setup
-- so far it is working
-- but it isn't integrating with leetcode.nvim. The line wrap is turning off (known bug), so it is doing something,
-- but image not displaying.
-- other options I tried are the html, css integratons in image.nvim, but no effect
