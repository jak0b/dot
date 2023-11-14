local wezterm = require 'wezterm'

local config = {}

local colorscheme = "dark"

if wezterm.config_builder then
  config = wezterm.config_builder()
end

if colorscheme == "dark" then
  config.color_scheme = "Ayu Dark (Gogh)"
elseif colorscheme == "light" then
  config.color_scheme = "Ayu Light (Gogh)"
end

config.font_size = 20
config.font = wezterm.font({
  family = "Iosevka Nerd Font",
  weight = "Regular",
})

config.hide_tab_bar_if_only_one_tab = true
config.tab_and_split_indices_are_zero_based = true

config.adjust_window_size_when_changing_font_size = false

config.window_decorations = "RESIZE"

config.audible_bell = "Disabled"

config.quit_when_all_windows_are_closed = true

local vpadding = 4
local hpadding = 2
config.window_padding = { left = vpadding, right = vpadding, top = hpadding, bottom = hpadding }

config.use_fancy_tab_bar = false

-- config.keys = {
--   { mods = "CMD", key = "q", action = wezterm.action.QuitApplication }
--   { mods = "", key = "q", action = wezterm.action.QuitApplication }
-- }

if colorscheme == "dark" then
  config.colors = {
    selection_bg = '#1B2733',
    tab_bar = {
      background = '#0A0E14',
      active_tab         = { bg_color = '#0A0E14', fg_color = '#FF8F40' },
      inactive_tab       = { bg_color = '#0A0E14', fg_color = '#808080' },
      inactive_tab_hover = { bg_color = '#0A0E14', fg_color = '#4D5566' },
      new_tab            = { bg_color = '#0A0E14', fg_color = '#4D5566' },
      new_tab_hover      = { bg_color = '#4D5566', fg_color = '#0A0E14' }
    }
  }
elseif colorscheme == "light" then
  config.colors = {
    selection_bg = '#E7E8E9',
    tab_bar = {
      background = '#FAFAFA',
      active_tab         = { bg_color = '#FAFAFA', fg_color = '#FF8F40' },
      inactive_tab       = { bg_color = '#FAFAFA', fg_color = '#808080' },
      inactive_tab_hover = { bg_color = '#FAFAFA', fg_color = '#4D5566' },
      new_tab            = { bg_color = '#FAFAFA', fg_color = '#4D5566' },
      new_tab_hover      = { bg_color = '#FAFAFA', fg_color = '#0A0E14' }
    }
  }
end

return config
