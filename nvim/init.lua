require("options")
require("keymaps")
require("autocommands")
require("help")
require("diagnostics")
require("lazy-nvim")
require("lsp")
require("colors")

require("vim._core.ui2").enable()

vim.filetype.add({
  extension = {
    mokuro = "json",
  },
})
