return {
  cmd = {"lua-language-server"},
  filetypes = {"lua"},
  root_markers = {".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", "selene.toml", "selene.yml", ".git"},
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
      }
    },
    -- format = {
    --   enable = true,
    --   defaultConfig = {
    --     indent_style = "space",
    --     indent_size = "2",
    --     quote_style = "double",
    --     max_line_length = "150",
    --     trailing_table_separator = "smart",
    --     call_arg_parenthesis = "keep",
    --     space_around_concat_operator = "false",
    --     space_before_inline_comment = "keep",
    --     align_continuous_similar_call_args = "keep",
    --     align_continuous_inline_comment = "false",
    --   },
    -- },
  },
}
