return {
  "folke/lazydev.nvim",
  ft = "lua",
  opts = {
    library = {
      "lazy.nvim",
      { path = "${3rd}/luv/library", words = {"vim%.uv"} },
    },
    -- enabled = function(root_dir)
    --   if vim.g.lazydev_enabled == false then return false end
    --   local paths = {
    --     vim.fn.stdpath("config"), -- Can't do rtp cuz of lazy loading
    --     vim.fn.stdpath("data"),
    --     vim.fn.stdpath("data_dirs")[1],
    --     vim.fn.stdpath("data_dirs")[2],
    --   }
    --   for _, rtp_dir in ipairs(paths) do
    --     if root_dir:sub(1, #rtp_dir) == rtp_dir then return true end
    --   end
    --   return false
    -- end,
  },
}
