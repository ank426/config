return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "nvim-neotest/nvim-nio",
    {
      "rcarriga/nvim-dap-ui",
      keys = {
        { "<leader>d?", function() require("dapui").eval(nil, { enter = true }) end }, ---@diagnostic disable-line
      },
      opts = {},
    },
    {
      "mfussenegger/nvim-dap-python",
      config = function()
        require("dap-python").setup()
      end,
    },
  },
  keys = {
    { "<leader>d",  "",                               desc = "+debug",                 mode = { "n", "v" } },
    { "<leader>db", require("dap").toggle_breakpoint, desc = "Toggle Breakpoint" },
    { "<leader>dc", require("dap").continue,          desc = "Continue" },
    { "<leader>dC", require("dap").run_to_cursor,     desc = "Run to Cursor" },
    { "<leader>dg", require("dap").goto_,             desc = "Go to Line (No Execute)" },
    { "<leader>di", require("dap").step_into,         desc = "Step Into" },
    { "<leader>dj", require("dap").down,              desc = "Down" },
    { "<leader>dk", require("dap").up,                desc = "Up" },
    { "<leader>dl", require("dap").run_last,          desc = "Run Last" },
    { "<leader>do", require("dap").step_out,          desc = "Step Out" },
    { "<leader>dO", require("dap").step_over,         desc = "Step Over" },
    { "<leader>dp", require("dap").pause,             desc = "Pause" },
    { "<leader>dr", require("dap").repl.toggle,       desc = "Toggle REPL" },
    { "<leader>ds", require("dap").session,           desc = "Session" },
    { "<leader>dt", require("dap").terminate,         desc = "Terminate" },
    { "<leader>dw", require("dap.ui.widgets").hover,  desc = "Widgets" },
    {
      "<leader>dB",
      function()
        require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end,
      desc = "Breakpoint Condition",
    },
    -- { "<leader>da", function() require("dap").continue({ before = get_args }) end, desc = "Run with Args" },
  },
  config = function()
    local dap, dapui = require("dap"), require("dapui")
    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      dapui.close()
    end
  end,
}
