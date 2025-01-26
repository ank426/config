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
      {"<leader>dc", function() require("dap").continue() end},
      {"<leader>d.", function() require("dap").run_last() end},
      {"<leader>dR", function() require("dap").restart() end},
      {"<leader>dt", function() require("dap").terminate() end},
      {"<leader>db", function() require("dap").toggle_breakpoint() end},
      {"<leader>dB", function() require("dap").toggle_breakpoint(vim.input("Enter Breakpoint Condition: ")) end},
      {"<leader>dt", function() require("dap").terminate() end},
      {"<leader>dq", function() require("dap").list_breakpoints() end},
      {"<leader>dX", function() require("dap").clear_breakpoints() end},
      {"<leader>de", function() require("dap").set_exception_breakpoints() end},
      {"<leader>do", function() require("dap").step_over() end},
      {"<leader>di", function() require("dap").step_into() end},
      {"<leader>dO", function() require("dap").step_out() end},
      {"<leader>dz", function() require("dap").step_back() end},
      {"<leader>dp", function() require("dap").pause() end},
      {"<leader>dZ", function() require("dap").reverse_continue() end},
      {"<leader>du", function() require("dap").up() end},
      {"<leader>dd", function() require("dap").down() end},
      {"<leader>dg", function() require("dap").goto_() end},
      {"<leader>df", function() require("dap").focus_frame() end},
      {"<leader>dF", function() require("dap").restart_frame() end},
      {"<leader>dC", function() require("dap").run_to_cursor() end},
      {"<leader>dr", function() require("dap.repl").open({}, "edit") end},
      {"<leader>dw", function() require("dap.ui.widgets").hover() end},
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
