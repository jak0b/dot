local M = {
  github_dark_gogh = {
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
  },

  github_dark_gogh_tab_bar = {
    active =   { bg = "#81B5F9", fg = "#0A0C10" },
    inactive = { bg = "#222E3E", fg = "#6994CA" },
  },

  github_light_gogh = {
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
  },

  github_light_gogh_tab_bar = {
    active =   { bg = "#1C48AD", fg = "#FFFFFF" },
    inactive = { bg = "#CFDBEE", fg = "#436CBD" },
  },
}

function M.apply_tab_bar_theme(colors, tab_bar_colors)
  local ret = {
    background = colors.background,
  }
  
  for _, prop in ipairs({"active_tab", "inactive_tab", "inactive_tab_hover", "new_tab", "new_tab_hover"}) do
    if prop == "active_tab" then
      ret[prop] = {
        bg_color = tab_bar_colors.active.bg,
        fg_color = tab_bar_colors.active.fg,

        intensity = 'Normal', underline = 'None',
        italic = false, strikethrough = false,
      }
    elseif string.find(prop, "hover") then
      ret[prop] = {
        bg_color = tab_bar_colors.inactive.bg,
        fg_color = tab_bar_colors.inactive.fg,

        intensity = 'Bold', underline = 'Single',
        italic = false, strikethrough = false,
      }
    else
      ret[prop] = {
        bg_color = tab_bar_colors.inactive.bg,
        fg_color = tab_bar_colors.inactive.fg,

        intensity = 'Normal', underline = 'None',
        italic = false, strikethrough = false,
      }
    end
  end
  return ret
end

return M
