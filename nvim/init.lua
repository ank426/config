require("options")
require("keymaps")
require("autocommands")
require("help")
require("diagnostics")
require("lazy-nvim")
require("lsp")
require("colors")

vim.filetype.add({
  extension = {
    mokuro = "json",
  },
})
