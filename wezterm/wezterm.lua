local wezterm = require "wezterm"

local colorscheme = require "colorscheme"
local colors = require "colors"

local config = wezterm.config_builder()

if colorscheme == "dark" then
  config.colors = colors.github_dark_gogh
  config.colors.tab_bar = colors.apply_tab_bar_theme(config.colors, colors.github_dark_gogh_tab_bar)

elseif colorscheme == "light" then
  config.colors = colors.github_light_gogh
  config.colors.tab_bar = colors.apply_tab_bar_theme(config.colors, colors.github_dark_gogh_tab_bar)
end

config.font_size = 16
config.font = wezterm.font({family = "Iosevka Nerd Font", weight = "Regular"})

config.window_frame = {
  font_size = 11,
  font = wezterm.font({family = "Iosevka Nerd Font", weight = "Bold"}),
  inactive_titlebar_bg = '#000',
  active_titlebar_bg = '#000'
}

config.tab_and_split_indices_are_zero_based = true
config.adjust_window_size_when_changing_font_size = false
config.quit_when_all_windows_are_closed = false
config.hide_tab_bar_if_only_one_tab = true

config.window_decorations = "RESIZE|MACOS_FORCE_DISABLE_SHADOW|MACOS_FORCE_SQUARE_CORNERS"
config.window_close_confirmation = "NeverPrompt"
config.audible_bell = "Disabled"
config.cursor_blink_rate = 0

config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }

config.max_fps = 240

config.keys = {{
  key = "w",
  mods = "CMD",
  action = wezterm.action.CloseCurrentTab {confirm = false}
}}

return config
