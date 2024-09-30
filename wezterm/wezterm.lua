local colorscheme = "dark"

local wezterm = require('wezterm')
local config = wezterm.config_builder()

if colorscheme == "dark" then
  config.color_scheme = "Github Dark (Gogh)"
elseif colorscheme == "light" then
  config.color_scheme = "Github Light (Gogh)"
end

-- soruce: https://github.com/be5invis/Iosevka/blob/main/doc/stylistic-sets.md
local function iosevka_style(style)
   local styles = {
    ["Default"]               = "ss00", ["Andale Mono Style"]     = "ss01", ["Anonymous Pro Style"]   = "ss02", ["Consolas Style"]        = "ss03",
    ["Menlo Style"]           = "ss04", ["Fira Mono Style"]       = "ss05", ["Liberation Mono Style"] = "ss06", ["Monaco Style"]          = "ss07",
    ["Pragmata Pro Style"]    = "ss08", ["Source Code Pro Style"] = "ss09", ["Envy Code R Style"]     = "ss10", ["X Window Style"]        = "ss11",
    ["Ubuntu Mono Style"]     = "ss12", ["Lucida Style"]          = "ss13", ["JetBrains Mono Style"]  = "ss14", ["IBM Plex Mono Style"]   = "ss15",
    ["PT Mono Style"]         = "ss16", ["Recursive Mono Style"]  = "ss17", ["Input Mono Style"]      = "ss18", ["Curly Style"]           = "ss20",
  }

  local possibleStyle = styles[style]

  if possibleStyle ~= nil then return possibleStyle
  else return styles["Default"]
  end
end

config.font_size = 20
config.font = wezterm.font({
  family = "Iosevka Nerd Font",
  stretch = 'Expanded',
  weight = "Regular",
  harfbuzz_features = { iosevka_style('Default'), 'calt=1', 'clig=1', 'liga=1' }
})

config.window_frame = {
  font = wezterm.font {
    family = "Iosevka Nerd Font",
    weight = "Bold",
  },
  font_size = config.font_size * 3/5
}

config.tab_and_split_indices_are_zero_based = true
config.adjust_window_size_when_changing_font_size = false
config.quit_when_all_windows_are_closed = false
config.audible_bell = "Disabled"
config.window_decorations = "RESIZE|MACOS_FORCE_DISABLE_SHADOW"
config.window_close_confirmation = 'NeverPrompt'

local vpadding, hpadding = 4, 2
config.window_padding = { left = vpadding, right = vpadding, top = hpadding, bottom = hpadding }

config.keys = {
  {
    key = 'w',
    mods = 'CMD',
    action = wezterm.action.CloseCurrentTab { confirm = false },
  }
}

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
