local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.automatically_reload_config = true
config.font = wezterm.font("PlemolJP", { weight = "Medium", style = "Italic" })
config.font_size = 14.0
config.font_rules = {
  {
    italic = true,
    font = wezterm.font("PlemolJP", { weight = "DemiBold", style = "Italic" }),
  },
  {
    intensity = "Bold",
    font = wezterm.font("PlemolJP", { weight = "Bold", style = "Italic" }),
  },
  {
    intensity = "Bold",
    italic = true,
    font = wezterm.font("PlemolJP", { weight = "Bold", style = "Italic" }),
  },
}
config.use_ime = true
config.window_background_opacity = 0.85
config.macos_window_background_blur = 20
config.hide_tab_bar_if_only_one_tab = true
config.window_decorations = "RESIZE"
config.window_frame = {
  inactive_titlebar_bg = "none",
  active_titlebar_bg = "none",
}
config.show_new_tab_button_in_tab_bar = false
config.colors = {
  background = "#001419",
  foreground = "#CBE0F0",
  cursor_bg = "#47FF9C",
  ansi = {
    "#214969",
    "#f16c75",
    "#37f499",
    "#FFE073",
    "#0FC5ED",
    "#a277ff",
    "#24EAF7",
    "#24EAF7",
  },
  brights = {
    "#214969",
    "#f16c75",
    "#37f499",
    "#19dfcf",
    "#987afb",
    "#949ae5",
    "#04d1f9",
    "#ebfafa",
  },
}

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local background = "#5c6d74"
  local foreground = "#FFFFFF"

  if tab.is_active then
    background = "#ae8b2d"
    foreground = "#FFFFFF"
  end

  local title = "   " .. wezterm.truncate_right(tab.active_pane.title, max_width - 1) .. "   "

  return {
    { Background = { Color = background } },
    { Foreground = { Color = foreground } },
    { Text = title },
  }
end)

return config
