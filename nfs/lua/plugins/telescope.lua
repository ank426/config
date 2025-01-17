return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  },
  cmd = "Telescope",
  keys = function()
    local builtin = require("telescope.builtin")
    return {
      { "<leader>sg", builtin.live_grep,                 desc = "[S]earch by [G]rep" },
      { "<leader>sw", builtin.grep_string,               desc = "[S]earch current [W]ord" },
      { "<leader>sf", builtin.find_files,                desc = "[S]earch [F]iles" },
      { "<leader>ss", builtin.builtin,                   desc = "[S]earch [S]elect Telescope" },
      { "<leader>sr", builtin.resume,                    desc = "[S]earch [R]esume" },
      { "<leader>sc", builtin.commands,                  desc = "[S]earch [C]ommands" },
      { "<leader>s.", builtin.oldfiles,                  desc = "[S]earch Recent Files ('.' for repeat)" },
      { "<leader>so", builtin.vim_options,               desc = "[S]earch Vim [O]ptions" },
      { "<leader>sh", builtin.help_tags,                 desc = "[S]earch [H]elp" },
      { "<leader>sb", builtin.buffers,                   desc = "[S]earch Existing [B]uffers" },
      { "<leader>sk", builtin.keymaps,                   desc = "[S]earch [K]eymaps" },
      { "<leader>sd", builtin.diagnostics,               desc = "[S]earch [D]iagnostics" },
      { "<leader>/",  builtin.current_buffer_fuzzy_find, desc = "[/] Fuzzily search in current buffer" },
      {
        "<leader>s/",
        function() builtin.live_grep({ grep_open_files = true, prompt_title = "Live Grep in Open Files" }) end,
        desc = "[S]earch [/] in Open Files",
      },
      {
        "<leader>sn",
        function() builtin.find_files({ cwd = vim.fn.stdpath("config"), prompt_title = "Find File in Config" }) end,
        desc = "[S]earch [N]eovim Files",
      },
      {
        "<leader>sp",
        function() builtin.find_files({ cwd = vim.fn.stdpath("config").."/lua/plugins", prompt_title = "Find Plugin File" }) end,
        desc = "[S]earch [P]lugin Files",
      },
      { "gd",         builtin.lsp_definitions,               desc = "LSP: [G]oto [D]efinition" },
      { "gr",         builtin.lsp_references,                desc = "LSP: [G]oto [R]eferences" },
      { "gI",         builtin.lsp_implementations,           desc = "LSP: [G]oto [I]mplementation" },
      { "<leader>D",  builtin.lsp_type_definitions,          desc = "LSP: Type [D]efinition" },
      { "<leader>ds", builtin.lsp_document_symbols,          desc = "LSP: [D]ocument [S]ymbols" },
      { "<leader>ws", builtin.lsp_dynamic_workspace_symbols, desc = "LSP: [W]orkspace [S]ymbols" },
    }
  end,
  opts = {
    defaults = {
      results_title = false,
      prompt_title = false,
      history = false,
      mappings = {
        i = {
          ["<C-u>"] = false,
          ["<C-d>"] = false,
          ["<C-k>"] = "preview_scrolling_up",
          ["<C-j>"] = "preview_scrolling_down",
        },
      },
    },
    pickers = {
      live_grep = { preview_title = false },
      grep_string = { preview_title = false },
      find_files = {
        preview_title = false,
        -- hidden = true,
        no_ignore = true,
        no_ignore_parent = true,
      },
      treesitter = { preview_title = false },
      current_buffer_fuzzy_find = {
        preview_title = false,
        previewer = false,
        theme = "dropdown",
      },
      tags = { preview_title = false },
      current_buffer_tags = { preview_title = false },
      git_files = { preview_title = false },
      git_commits = { preview_title = false },
      git_bcommits = { preview_title = false },
      git_branches = { preview_title = false },
      git_status = { preview_title = false },
      git_stash = { preview_title = false },
      builtin = {
        preview_title = false,
        previewer = false,
        theme = "dropdown",
      },
      resume = { preview_title = false },
      pickers = { preview_title = false },
      planets = { preview_title = false },
      symbols = { preview_title = false },
      commands = { preview_title = false },
      quickfix = { preview_title = false },
      quickfixhistory = { preview_title = false },
      loclist = { preview_title = false },
      oldfiles = { preview_title = false },
      command_history = { preview_title = false },
      search_history = { preview_title = false },
      vim_options = { preview_title = false },
      help_tags = {
        preview_title = false,
        mappings = {
          i = {
            ["<cr>"] = function()
              vim.cmd.H(require("telescope.actions.state").get_selected_entry().value)
              vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
            end,
            ["<C-v>"] = function()
              vim.cmd("topleft vert help "..require("telescope.actions.state").get_selected_entry().value)
              vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
            end,
          },
          n = {
            ["<cr>"] = function()
              vim.cmd.H(require("telescope.actions.state").get_selected_entry().value)
              vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
            end,
            ["<C-v>"] = function()
              vim.cmd("topleft vert help "..require("telescope.actions.state").get_selected_entry().value)
              vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
            end,
          },
        },
      },
      man_pages = { preview_title = false },
      reloader = { preview_title = false },
      buffers = {
        preview_title = false,
        mappings = {
          i = {
            ["<C-d>"] = "delete_buffer",
          },
        },
      },
      colorschemes = { preview_title = false },
      marks = { preview_title = false },
      registers = { preview_title = false },
      keymaps = { preview_title = false },
      filetypes = { preview_title = false },
      highlights = { preview_title = false },
      autocommands = { preview_title = false },
      spell_suggest = { preview_title = false },
      tagstack = { preview_title = false },
      jumplist = { preview_title = false },
      lsp_references = { preview_title = false },
      lsp_incoming_calls = { preview_title = false },
      lsp_outgoing_calls = { preview_title = false },
      lsp_definitions = { preview_title = false },
      lsp_type_defintions = { preview_title = false },
      lsp_implementations = { preview_title = false },
      lsp_document_symbols = { preview_title = false },
      lsp_workspace_symbols = { preview_title = false },
      lsp_dynamic_workspace_symbols = { preview_title = false },
      lsp_diagnostics = { preview_title = false },
    },
    extensions = {
      fzf = {},
    },
  },
  config = function(_, opts)
    require("telescope").setup(opts)
    require("telescope").load_extension("fzf")
  end,
}
