local wezterm = require 'wezterm'

local config = {}

local colorscheme = "dark"

function uname()
  local proc = io.popen("uname 2>&1", "r")
  local result = proc:read("*line")
  if proc:close() == nil then return "not UNIX" end
  return result
end

if wezterm.config_builder then
  config = wezterm.config_builder()
end

if colorscheme == "dark" then
  config.color_scheme = "Ayu Dark (Gogh)"
elseif colorscheme == "light" then
  config.color_scheme = "Ayu Light (Gogh)"
end

local function iosevka_style(style)
  -- soruce: https://github.com/be5invis/Iosevka/blob/main/doc/stylistic-sets.md
   local styles = {
    ["Default"]               = "ss00",
    ["Andale Mono Style"]     = "ss01",
    ["Anonymous Pro Style"]   = "ss02",
    ["Consolas Style"]        = "ss03",
    ["Menlo Style"]           = "ss04",
    ["Fira Mono Style"]       = "ss05",
    ["Liberation Mono Style"] = "ss06",
    ["Monaco Style"]          = "ss07",
    ["Pragmata Pro Style"]    = "ss08",
    ["Source Code Pro Style"] = "ss09",
    ["Envy Code R Style"]     = "ss10",
    ["X Window Style"]        = "ss11",
    ["Ubuntu Mono Style"]     = "ss12",
    ["Lucida Style"]          = "ss13",
    ["JetBrains Mono Style"]  = "ss14",
    ["IBM Plex Mono Style"]   = "ss15",
    ["PT Mono Style"]         = "ss16",
    ["Recursive Mono Style"]  = "ss17",
    ["Input Mono Style"]      = "ss18",
    ["Curly Style"]           = "ss20",
  }
  return styles[style]
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

local hyperlink_rules = wezterm.default_hyperlink_rules()
-- remove `mailto` from hyperlink rules
for idx, val in ipairs(hyperlink_rules) do
  if val.format == 'mailto:$0' then
    table.remove(hyperlink_rules, idx)
    break
  end
end
config.hyperlink_rules = hyperlink_rules

return config
