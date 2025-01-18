return {
  "neovim/nvim-lspconfig",
  event = "BufReadPre",
  config = function()
    local lspconfig = require("lspconfig")

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
              call_arg_parenthesis = "keep",
              max_line_length = "150",
              trailing_table_separator = "smart",
              space_around_concat_operator = "false",
              align_call_args = "true",
            },
          },
        },
      },
    })
  end,
}
