local wezterm = require "wezterm"

local colorscheme = require "colorscheme"

local config = wezterm.config_builder()

local github_dark_gogh = {
  background = "#000000", foreground = "#8B949E",
  cursor_bg = "#C9D1D9", cursor_fg = "#101216",
  cursor_border = "#C9D1D9",

  ansi = {
    "#000000", "#F78166",
    "#56D364", "#E3B341",
    "#6CA4F8", "#DB61A2",
    "#2B7489", "#FFFFFF",
  },

  brights = {
    "#4D4D4D", "#F78166",
    "#56D364", "#E3B341",
    "#6CA4F8", "#DB61A2",
    "#2B7489", "#FFFFFF",
  }
}

local github_light_gogh = {
  background = "#F6F8FA", foreground = "#1F2328",
  cursor_bg = "#1F2328", cursor_fg = "#F6F8FA",
  cursor_border = "#1F2328",

  ansi = {
    "#24292F", "#CF222E",
    "#1A7F37", "#9A6700",
    "#0969DA", "#8250DF",
    "#1B7C83", "#6E7781",
  },

  brights = {
    "#57606A", "#A40E26",
    "#2DA44E", "#BF8700",
    "#218BFF", "#A475F9",
    "#3192AA", "#8C959F",
  }
}

if colorscheme == "dark" then
  config.colors = github_dark_gogh
elseif colorscheme == "light" then
  config.colors = github_light_gogh
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
