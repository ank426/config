return {
  "3rd/image.nvim",
  build = false, -- so that it doesn't build the rock https://github.com/3rd/image.nvim/issues/91#issuecomment-2453430239
  opts = {
    backend = "sixel",
    processor = "magick_cli",
    integrations = {
      markdown = {
        clear_in_insert_mode = true,
        download_remote_images = false,
      },
      neorg = {
        enabled = false,
      },
      typst = {
        enabled = false,
      },
    },
  },
}
