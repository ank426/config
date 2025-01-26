-- nvim-dap-python internally requires nvim-dap on setup
-- Cyclic dependencies can fuck up lazy loading (becomes non lazy)
return {
  {
    "mfussenegger/nvim-dap",
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "dap-repl",
        callback = function(args)
          require("dap.ext.autocompl").attach(args.buf)
          vim.cmd("startinsert!")
        end,
      })
    end,
    keys = {
      {"<leader>dc", function() require("dap").continue() end,                  desc = "Dap Continue"},
      {"<leader>d.", function() require("dap").run_last() end,                  desc = "Dap Run Last"},
      {"<leader>dR", function() require("dap").restart() end,                   desc = "Dap Restart"},
      {"<leader>dt", function() require("dap").terminate() end,                 desc = "Dap Terminate"},
      {"<leader>db", function() require("dap").toggle_breakpoint() end,         desc = "Dap Toggle Breakpoint"},
      {"<leader>dq", function() require("dap").list_breakpoints() end,          desc = "Dap List Breakpoints"},
      {"<leader>dX", function() require("dap").clear_breakpoints() end,         desc = "Dap Clear Breakpoints"},
      {"<leader>de", function() require("dap").set_exception_breakpoints() end, desc = "Dap Set Expception Breakpoints"},
      {"<leader>do", function() require("dap").step_over() end,                 desc = "Dap Step Over"},
      {"<leader>di", function() require("dap").step_into() end,                 desc = "Dap Step Into"},
      {"<leader>dO", function() require("dap").step_out() end,                  desc = "Dap Step Out"},
      {"<leader>dz", function() require("dap").step_back() end,                 desc = "Dap Step Back"},
      {"<leader>dp", function() require("dap").pause() end,                     desc = "Dap Pause"},
      {"<leader>dZ", function() require("dap").reverse_continue() end,          desc = "Dap Reverse Continue"},
      {"<leader>du", function() require("dap").up() end,                        desc = "Dap Up"},
      {"<leader>dd", function() require("dap").down() end,                      desc = "Dap Down"},
      {"<leader>dg", function() require("dap").goto_() end,                     desc = "Dap Goto"},
      {"<leader>df", function() require("dap").focus_frame() end,               desc = "Dap Focus Frame"},
      {"<leader>dF", function() require("dap").restart_frame() end,             desc = "Dap Restart Frame"},
      {"<leader>dC", function() require("dap").run_to_cursor() end,             desc = "Dap Run to Cursor"},
      {"<leader>dr", function() require("dap.repl").open({},"edit") end,        desc = "Dap Repl Open"},
      {"<leader>dw", function() require("dap.ui.widgets").hover() end,          desc = "Dap Widgets Hover"},
      {
        "<leader>dB",
        function() require("dap").set_breakpoint(vim.input("Enter Breakpoint Condition: ")) end,
        desc = "Dap Set Conditional Breakpoint",
      },
    },
    config = function()
      local dap = require("dap")
      dap.defaults.fallback.terminal_win_cmd = function() return vim.api.nvim_create_buf(true, false) end
      require("dap-python")
    end,
  },
  {
    "mfussenegger/nvim-dap-python",
    lazy = true,
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    opts = {},
    config = function(_, opts)
      require("dap-python").setup(nil, opts)
      for _, configuration in ipairs(require("dap").configurations.python) do
        configuration["stopOnEntry"] = true
      end
    end,
  },
}

-- Also need to see nvim-dap-virtual-text and nvim-dap-ui
-- nvim-dap-repl-highlights probably not worth it
