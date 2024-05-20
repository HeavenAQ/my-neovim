return {
  "mistricky/codesnap.nvim",
  build = "make",
  opts = function()
    return {
      mac_window_bar = true,
      title = "CodeSnap.nvim",
      code_font_family = "CaskaydiaCove Nerd Font",
      watermark_font_family = "Pacifico",
      watermark = "HeavenChen.nvim",
      bg_theme = "default",
      breadcrumbs_separator = "/",
      has_breadcrumbs = true,
      has_line_number = false,
      min_width = 0,
      save_path = "~/Desktop/vimshot/",
    }
  end,
}
