-- Pairs and indents with cr when {}
return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  opts = {
    check_ts = true,
  },
  config = function(_, opts)
    local npairs = require("nvim-autopairs")
    local Rule = require("nvim-autopairs.rule")
    local cond = require("nvim-autopairs.conds")
    npairs.setup(opts)
    npairs.add_rule(
      Rule("$", "$", "typst")
        :with_move(cond.done())
        :with_cr(cond.done())
        :replace_map_cr(function()
          return "<C-g>u<CR><C-t><CR><C-d><Up><End>"
        end)
    )
  end,
}

-- Doesn't work with tpope/endwise
-- Couldn't get this thing's endwise to work (wiki says issues with treesitter which is what it is based on)
