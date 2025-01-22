-- If you want VeryLazy then you need lazydev as dependency
return {
  "neovim/nvim-lspconfig",
  -- event = "BufReadPre", -- Any form of lazy loading seems to give random problems (ex complaints, client not starting when nvim with arg, etc)
  dependencies = {
    { "williamboman/mason.nvim",           opts = {} },
    { "williamboman/mason-lspconfig.nvim", opts = { automatic_installation = true } }, -- Give it time to install
    -- "folke/lazydev.nvim", -- If you don't do this, sometimes lsp starts screaming and never stops -- I think this is only need if lazy loading
  },
  config = function()
    local lspconfig = require("lspconfig")

    lspconfig.clangd.setup({})

    lspconfig.lua_ls.setup({
      settings = {
        Lua = {
          runtime = {
            version = "LuaJIT",
          },
          format = {
            enable = true,
            defaultConfig = {
              indent_style = "space",
              indent_size = "2",
              quote_style = "double",
              max_line_length = "150",
              trailing_table_separator = "smart",
              call_arg_parenthesis = "keep",
              space_around_concat_operator = "false",
              space_before_inline_comment = "keep",
              align_continuous_similar_call_args = "keep",
              align_continuous_inline_comment = "false",
            },
          },
        },
      },
    })

    lspconfig.basedpyright.setup({
      on_init = function(client)
        client.server_capabilities.inlayHintProvider = false
        client.server_capabilities.textDocumentSync = nil
      end,
    })
    lspconfig.ruff.setup({
      on_init = function(client)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
      end,
      init_options = {
        settings = {
          lineLength = 150,
          configurationPreference = "filesystemFirst",
          lint = {
            select = { -- https://docs.astral.sh/ruff/rules/
              "F",       -- Pyflakes
              "E112",    -- no-indented-block
              "E113",    -- unexpected-indentation
              "E203",    -- whitespace-before-punctuation
              "E272",    -- multiple-spaces-before-keyword
              "E275",    -- missing-whitespace-after-keyword
              "E303",    -- too-many-blank-lines
              "E304",    -- blank-line-after-decorator
              "E501",    -- line-too-long
              "E702",    -- multiple-statements-on-one-line-semicolon
              "E703",    -- useless-semicolon
              "E731",    -- lambda-assignment
              "W191",    -- tab-indentation
              "W291",    -- trailing-whitespace
              "W293",    -- blank-line-with-whitespace
              "UP039",   -- unnecessary-class-parentheses
              "C416",    -- unnecessary-comprehension
              "RET506",  -- superfluous-else-raise
              "RET507",  -- superfluous-else-continue
              "A",       -- builtin-variable-shadowing, builtin-argument-shadowing, builtin-attribute-shadowing
              "SIM105",  -- suppressible-exception
              "FURB110", -- if-exp-instead-of-or-operator
              "RUF018",  -- assignment-in-assert
            },
          },
        },
      },
    })
  end,
}

-- https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/
-- search ServerCapabilites 2nd match
-- I didn't read, just tried out random stuff + common sense
-- Also, no idea why it is server capabilities and not client
