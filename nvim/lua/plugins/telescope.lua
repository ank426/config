return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  cmd = "Telescope",
  keys = {
    { "<leader>sg", "<cmd>Telescope live_grep<cr>",                 desc = "[S]earch by [G]rep" },
    { "<leader>sw", "<cmd>Telescope grep_string<cr>",               desc = "[S]earch current [W]ord" },
    { "<leader>sf", "<cmd>Telescope find_files<cr>",                desc = "[S]earch [F]iles" },
    { "<leader>ss", "<cmd>Telescope builtin<cr>",                   desc = "[S]earch [S]elect Telescope" },
    { "<leader>sr", "<cmd>Telescope resume<cr>",                    desc = "[S]earch [R]esume" },
    { "<leader>sc", "<cmd>Telescope commands<cr>",                  desc = "[S]earch [C]ommands" },
    { "<leader>s.", "<cmd>Telescope oldfiles<cr>",                  desc = "[S]earch Recent Files ('.' for repeat)" },
    { "<leader>so", "<cmd>Telescope vim_options<cr>",               desc = "[S]earch Vim [O]ptions" },
    { "<leader>sh", "<cmd>Telescope help_tags<cr>",                 desc = "[S]earch [H]elp" },
    { "<leader>sb", "<cmd>Telescope buffers<cr>",                   desc = "[S]earch Existing [B]uffers" },
    { "<leader>sk", "<cmd>Telescope keymaps<cr>",                   desc = "[S]earch [K]eymaps" },
    { "<leader>sd", "<cmd>Telescope diagnostics<cr>",               desc = "[S]earch [D]iagnostics" },
    { "<leader>/",  "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "[/] Fuzzily search in current buffer" },
    {
      "<leader>s/",
      function()
        require("telescope.builtin").live_grep({
          grep_open_files = true,
          prompt_title = "Live Grep in Open Files",
        })
      end,
      desc = "[S]earch [/] in Open Files",
    },
    {
      "<leader>sn",
      function()
        require("telescope.builtin").find_files({
          cwd = vim.fn.stdpath("config"),
          prompt_title = "Find File in Config",
        })
      end,
      desc = "[S]earch [N]eovim Files",
    },
    {
      "<leader>sp",
      function()
        require("telescope.builtin").find_files({
          cwd = vim.fn.stdpath("config").."/lua/plugins",
          prompt_title = "Find Plugin File",
        })
      end,
      desc = "[S]earch [P]lugin Files",
    },
    { "gd",  "<cmd>Telescope lsp_definitions<cr>",               desc = "LSP: [G]oto [D]efinition (Telescope)" },
    { "grr", "<cmd>Telescope lsp_references<cr>",                desc = "LSP: [G]oto [R]eferences (Telescope)" },
    { "gri", "<cmd>Telescope lsp_implementations<cr>",           desc = "LSP: [G]oto [I]mplementation (Telescope)" },
    { "gO",  "<cmd>Telescope lsp_document_symbols<cr>",          desc = "LSP: Document Symbols (Telescope)" },
    { "grt", "<cmd>Telescope lsp_type_definitions<cr>",          desc = "LSP: [G]oto [T]ype Definition (Telescope)" },
    { "grw", "<cmd>Telescope lsp_workspace_symbols<cr>",         desc = "LSP: [W]orkspace Symbols (Telescope)" },
    { "grW", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "LSP: Dynamic [W]orkspace Symbols (Telescope)" },
  },
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
        -- no_ignore = true,
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
              vim.cmd.stopinsert()
            end,
            ["<C-v>"] = function()
              vim.cmd("topleft vert help "..require("telescope.actions.state").get_selected_entry().value)
              vim.cmd.stopinsert()
            end,
          },
          n = {
            ["<cr>"] = function()
              vim.cmd.H(require("telescope.actions.state").get_selected_entry().value)
              vim.cmd.stopinsert()
            end,
            ["<C-v>"] = function()
              vim.cmd("topleft vert help "..require("telescope.actions.state").get_selected_entry().value)
              vim.cmd.stopinsert()
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

    vim.lsp.buf.references = require("telescope.builtin").lsp_references
  end,
}
