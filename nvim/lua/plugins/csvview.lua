return {
  "hat0uma/csvview.nvim",
  -- cmd = {"CsvViewEnable", "CsvViewDisable", "CsvViewToggle"},
  ft = {"csv", "tsv"},
  opts = {
    -- parser = {
    --   comments = {"#", "//"},
    -- },
    view = {
      display_mode = "border",
    },
    keymaps = {
      textobject_field_inner = { "if", mode = {"o", "x"} },
      textobject_field_outer = { "af", mode = {"o", "x"} },
    },
  },
  config = function (_, opts)
    require("csvview").setup(opts)

    vim.api.nvim_create_autocmd("FileType", {
      pattern = {"csv", "tsv"},
      command = "CsvViewToggle",
    })
  end
}
