local border_color_1 = "rgba({{colors.primary.default.hex_stripped}}ee)"
local border_color_2 = "rgba({{colors.secondary.default.hex_stripped}}ee)"
local border_inactive = "rgba({{colors.background.default.hex_stripped}}ff)"

hl.config({
  general = {
    col = {
      active_border = { colors = { border_color_1, border_color_2 }, angle = 45 },
      inactive_border = border_inactive,
    },
  },
})
