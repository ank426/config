return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-path",
    {
      "rafamadriz/friendly-snippets",
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
      end,
    },
    {
      "L3MON4D3/LuaSnip",
      build = "make install_jsregexp",
      opts = {},
    },
    "saadparwaiz1/cmp_luasnip",
  },
  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      -- completion = { completeopt = "menu,menuone,noinsert" }, -- No idea what the defaults are and how this changes them
      mapping = cmp.mapping.preset.insert({
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-y>"] = cmp.mapping.confirm({ select = true }),
        ["<C-Space>"] = cmp.mapping.confirm({}),
        ["<C-k>"] = cmp.mapping(function() if luasnip.expand_or_locally_jumpable() then luasnip.expand_or_jump() end end, { "i", "s" }),
        ["<C-S-k>"] = cmp.mapping(function() if luasnip.locally_jumpable(-1) then luasnip.jump(-1) end end, { "i", "s" }),
      }),
      sources = {
        { name = "luasnip" },
        { name = "nvim_lsp" },
        { name = "path" },
        { name = "lazydev", group_index = 0 },
      },
    })
  end,
}
