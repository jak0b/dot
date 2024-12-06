local colorscheme = "dark"

local wezterm = require("wezterm")
local config = wezterm.config_builder()

if colorscheme == "dark" then
    config.color_scheme = "Github Dark (Gogh)"
elseif colorscheme == "light" then
    config.color_scheme = "Github Light (Gogh)"
end

config.font_size = 17
config.font = wezterm.font({family = "Iosevka Nerd Font", weight = "Regular"})

config.window_frame = {
    font_size = 12,
    font = wezterm.font({family = "Iosevka Nerd Font", weight = "Bold"}),
    inactive_titlebar_bg = '#000',
    active_titlebar_bg = '#000'
}

config.tab_and_split_indices_are_zero_based = true
config.adjust_window_size_when_changing_font_size = false
config.quit_when_all_windows_are_closed = false
config.audible_bell = "Disabled"
config.window_decorations = "RESIZE|MACOS_FORCE_DISABLE_SHADOW"
config.window_close_confirmation = "NeverPrompt"

config.window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0
}

config.keys = {
    {
        key = "w",
        mods = "CMD",
        action = wezterm.action.CloseCurrentTab {confirm = false}
    }
}

-- remove `mailto` from hyperlink rules
local hyperlink_rules = wezterm.default_hyperlink_rules()
for idx, val in ipairs(hyperlink_rules) do
    if val.format == "mailto:$0" then
        table.remove(hyperlink_rules, idx)
        break
    end
end
config.hyperlink_rules = hyperlink_rules

return config
