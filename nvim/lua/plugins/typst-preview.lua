return {
  "chomosuke/typst-preview.nvim",
  ft = "typst",
  version = "1.*",
  opts = {
    -- open_cmd = "firefox %s --class typst-preview",
    open_cmd = nil,
    port = 50025,
    invert_colors = "auto",
    dependencies_bin = {
      tinymist = "tinymist",
      websocat = "websocat",
    },
  },
}
