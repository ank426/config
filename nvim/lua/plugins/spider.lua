return {
  "chrisgrieser/nvim-spider",
  keys = {
    {
      "w",
      "<cmd>=require('spider').motion('w')<CR>",
      mode = { "n", "o", "x" },
      desc = "Spider-w",
    },
    {
      "e",
      "<cmd>=require('spider').motion('e')<CR>",
      mode = { "n", "o", "x" },
      desc = "Spider-e",
    },
    {
      "b",
      "<cmd>=require('spider').motion('b')<CR>",
      mode = { "n", "o", "x" },
      desc = "Spider-b",
    },
  },
}
