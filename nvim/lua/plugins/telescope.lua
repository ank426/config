return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  event = "VeryLazy",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "nvim-telescope/telescope-ui-select.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      cond = function()
        return vim.fn.executable("make") == 1
      end,
    },
  },
  keys = {
    { "<leader>sg", require("telescope.builtin").live_grep,                 desc = "[S]earch by [G]rep" },
    { "<leader>sw", require("telescope.builtin").grep_string,               desc = "[S]earch current [W]ord" },
    { "<leader>sf", require("telescope.builtin").find_files,                desc = "[S]earch [F]iles" },
    { "<leader>ss", require("telescope.builtin").builtin,                   desc = "[S]earch [S]elect Telescope" },
    { "<leader>sr", require("telescope.builtin").resume,                    desc = "[S]earch [R]esume" },
    { "<leader>sc", require("telescope.builtin").commands,                  desc = "[S]earch [C]ommands" },
    { "<leader>s.", require("telescope.builtin").oldfiles,                  desc = "[S]earch Recent Files ('.' for repeat)" },
    { "<leader>so", require("telescope.builtin").vim_options,               desc = "[S]earch Vim [O]ptions" },
    { "<leader>sh", require("telescope.builtin").help_tags,                 desc = "[S]earch [H]elp" },
    { "<leader>sb", require("telescope.builtin").buffers,                   desc = "[S]earch Existing [B]uffers" },
    { "<leader>sk", require("telescope.builtin").keymaps,                   desc = "[S]earch [K]eymaps" },
    { "<leader>sd", require("telescope.builtin").diagnostics,               desc = "[S]earch [D]iagnostics" },
    { "<leader>/",  require("telescope.builtin").current_buffer_fuzzy_find, desc = "[/] Fuzzily search in current buffer" },
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
        require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })
      end,
      desc = "[S]earch [N]eovim files",
    },
    { "gd",         require("telescope.builtin").lsp_definitions,               desc = "LSP: [G]oto [D]efinition" },
    { "gr",         require("telescope.builtin").lsp_references,                desc = "LSP: [G]oto [R]eferences" },
    { "gI",         require("telescope.builtin").lsp_implementations,           desc = "LSP: [G]oto [I]mplementation" },
    { "<leader>D",  require("telescope.builtin").lsp_type_definitions,          desc = "LSP: Type [D]efinition" },
    { "<leader>ds", require("telescope.builtin").lsp_document_symbols,          desc = "LSP: [D]ocument [S]ymbols" },
    { "<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, desc = "LSP: [W]orkspace [S]ymbols" },
  },
  opts = {
    defaults = {
      results_title = false,
      preview_title = "", -- Doesn't work in defaults but works in pickers
      mappings = {
        i = {
          ["<C-u>"] = false,
        },
      },
    },
    pickers = {
      find_files = {
        -- hidden = true,
        no_ignore = true,
      },
      current_buffer_fuzzy_find = {
        theme = "dropdown",
        previewer = false,
      },
      help_tags = {
        mappings = {
          i = {
            ["<CR>"] = "select_vertical",
          },
        },
      },
      buffers = {
        mappings = {
          i = {
            ["<C-d>"] = require("telescope.actions").delete_buffer + require("telescope.actions").move_to_top,
          },
        },
      },
    },
    extensions = {
      ["ui-select"] = {
        require("telescope.themes").get_dropdown(),
      },
    },
  },
  config = function(_, opts)
    require("telescope").setup(opts)
    require("telescope").load_extension("fzf")
    require("telescope").load_extension("ui-select")
  end,
}
