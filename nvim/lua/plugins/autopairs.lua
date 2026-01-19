-- Pairs and indents with cr when {}
return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  opts = {
    check_ts = true,
  },
}

-- Doesn't work with tpope/endwise
-- Couldn't get this thing's endwise to work (wiki says issues with treesitter which is what it is based on)
