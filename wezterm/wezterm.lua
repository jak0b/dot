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

config.font_size = 15.5
config.font = wezterm.font({family = "Iosevka Nerd Font", weight=490})

config.tab_and_split_indices_are_zero_based = true
config.adjust_window_size_when_changing_font_size = false
config.quit_when_all_windows_are_closed = false
config.hide_tab_bar_if_only_one_tab = true

config.window_decorations = "RESIZE|MACOS_FORCE_DISABLE_SHADOW"
config.window_close_confirmation = "NeverPrompt"
config.audible_bell = "Disabled"
config.cursor_blink_rate = 0
config.pane_focus_follows_mouse = false
config.prefer_to_spawn_tabs = true
config.show_close_tab_button_in_tabs = false
config.tab_bar_at_bottom = false
config.use_fancy_tab_bar = false
config.show_tab_index_in_tab_bar = true
config.tab_max_width = 64
config.show_new_tab_button_in_tab_bar = true

config.native_macos_fullscreen_mode = false
config.macos_fullscreen_extend_behind_notch = true

config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }

config.max_fps = 240

config.window_padding = { left = 7, right = 7, top = 7, bottom = 7 }
config.inactive_pane_hsb = { saturation = 1, brightness = 1 }

config.tab_bar_style = {
  new_tab = wezterm.format {{ Text = ' ○  ' }},
  new_tab_hover = wezterm.format {{ Text = ' ●  ' }},
}

config.leader = { key = 'f', mods = 'CTRL', timeout_milliseconds = 2000 }

config.keys = {
  { key = "raw:47",   mods = "CTRL",    action = wezterm.action.ShowTabNavigator },
  { key = "raw:51",   mods = "CMD",    action = wezterm.action.ActivateCommandPalette },
  { key = "raw:51",   mods = "CTRL",    action = wezterm.action.ShowLauncher },

  { key = "d",   mods = "LEADER", action = wezterm.action.QuickSelectArgs { patterns = {'[a-zA-Z0-9_.-]+'} } },

  { key = "a",   mods = "LEADER", action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain'}},
  { key = "s",   mods = "LEADER", action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain'}},
  { key = "f",   mods = "CTRL", action = wezterm.action.TogglePaneZoomState },

  { key = "w",   mods = "CMD", action = wezterm.action.CloseCurrentPane {confirm = true}},
  { key = "w",   mods = "LEADER", action = wezterm.action.CloseCurrentTab {confirm = true}},

  { key = "Tab",   mods = "LEADER", action = wezterm.action.ActivatePaneDirection 'Next'},

  { key = "h",   mods = "LEADER", action = wezterm.action.ActivatePaneDirection 'Left'},
  { key = "l",   mods = "LEADER", action = wezterm.action.ActivatePaneDirection 'Right'},
  { key = "j",   mods = "LEADER", action = wezterm.action.ActivatePaneDirection 'Down'},
  { key = "k",   mods = "LEADER", action = wezterm.action.ActivatePaneDirection 'Up'},

  { key = "h",   mods = "LEADER|ALT", action = wezterm.action.AdjustPaneSize { 'Left', 1 }},
  { key = "l",   mods = "LEADER|ALT", action = wezterm.action.AdjustPaneSize { 'Right', 1 }},
  { key = "j",   mods = "LEADER|ALT", action = wezterm.action.AdjustPaneSize { 'Down', 1 }},
  { key = "k",   mods = "LEADER|ALT", action = wezterm.action.AdjustPaneSize { 'Up', 1 }},

  { key = "h",   mods = "LEADER|SHIFT", action = wezterm.action.AdjustPaneSize { 'Left', 5 }},
  { key = "l",   mods = "LEADER|SHIFT", action = wezterm.action.AdjustPaneSize { 'Right', 5 }},
  { key = "j",   mods = "LEADER|SHIFT", action = wezterm.action.AdjustPaneSize { 'Down', 5 }},
  { key = "k",   mods = "LEADER|SHIFT", action = wezterm.action.AdjustPaneSize { 'Up', 5 }},

  { key = "t",   mods = "LEADER", action = wezterm.action_callback(function(win, pane)
        wezterm.background_child_process { '/Users/j0b/.local/bin/theme' } end), },

  { key = "c",   mods = "LEADER", action = wezterm.action.ActivateCopyMode },

}

return config
