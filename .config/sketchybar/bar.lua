local colors = require("colors").sections.bar

-- Equivalent to the --bar domain
sbar.bar {
  topmost = "window",
  height = 30,
  color = colors.bg,
  y_offset = 0,
  padding_right = 4,
  padding_left = 4,
  border_color = colors.border,
  border_width = 0,
  blur_radius = 0,
  margin = 0,
  corner_radius = 0,
}
