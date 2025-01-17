return {
  "folke/lazydev.nvim",
  ft = "lua",
  opts = {
    library = {
      -- See the configuration section for more details
      -- Load luvit types when the `vim.uv` word is found
      { path = "${3rd}/luv/library", words = { "vim%.uv" } },
    },
    enabled = function(root_dir)
      if vim.g.lazydev_enabled == false then
        return false
      end

      for _, rtp_dir in ipairs(vim.opt.runtimepath:get()) do
        if root_dir:sub(1, #rtp_dir) == rtp_dir then
          return true
        end
      end
      return false
    end
  },
}
