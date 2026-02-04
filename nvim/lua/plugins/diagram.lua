-- Every change to the settings needs require("diagram").get_cache_dir() to be cleared
return {
  "3rd/diagram.nvim",
  dependencies = {"3rd/image.nvim"},
  opts = {
    renderer_options = {
      mermaid = {
        background = "transparent",
        theme = "dark",
        scale = 2,
      },
    },
  },
}
