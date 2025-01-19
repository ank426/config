return {
  "saghen/blink.cmp",
  version = "*",
  dependencies = {
    "rafamadriz/friendly-snippets",
    -- !Important! Make sure you're using the latest release of LuaSnip
    -- `main` does not work at the moment
    { "L3MON4D3/LuaSnip", version = "v2.*" }, -- Is really powerful
  },
  opts = {
    keymap = {
      ["<C-.>"] = { function(cmp) return cmp.snippet_active() and cmp.accept() or cmp.select_and_accept() end, "snippet_forward", "fallback" },
      ["<C-,>"] = { "snippet_backward", "fallback" },
    },
    snippets = { preset = "luasnip" },
    completion = {
      list = {
        selection = {
          preselect = false,
        },
      },
      menu = {
        draw = {
          treesitter = { "lsp" },
        },
      },
      documentation = {
        auto_show = true,
      },
    },
    signature = {
      enabled = true,
    },
    sources = {
      default = { "lazydev", "lsp", "path", "snippets", "buffer" },
      providers = {
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          score_offset = 100, -- make lazydev completions top priority (see `:h blink.cmp`)
        },
      },
    },
  },
  opts_extend = { "sources.default" }, -- No idea what this is
}
