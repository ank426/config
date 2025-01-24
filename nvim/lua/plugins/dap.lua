return {
  "mfussenegger/nvim-dap",
  config = function()
    local dap = require("dap")
    dap.adapters.py = {
      type = "executable",
      command = "/usr/bin/python",
      args = {"-m", "debuygpy.adapter"},
    }
  end,
}
