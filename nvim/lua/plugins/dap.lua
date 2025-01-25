return {
  "mfussenegger/nvim-dap",
  config = function()
    local dap = require("dap")

    dap.defaults.fallback.focus_terminal = true

    dap.adapters.debugpy = {
      type = "executable", -- See docs and language specific installation for servers and stuff
      command = "python",
      args = {"-m", "debugpy.adapter"},
      options = {
        source_filetype = "python",
      },
    }
    dap.configurations.python = {
      {
        type = "debugpy"; -- adapter index
        request = "launch";
        name = "Launch Debugpy";
        -- For debugpy:
        program = "${file}";
        pythonPath = function() return (os.getenv("VIRTUAL_ENV") or "/usr").."/bin/python" end;
      },
    }
  end,
}
