local icons = require "icons"
local colors = require("colors").sections.calendar
local settings = require "settings"

local cal = sbar.add("item", {
  -- icon = {
  --   padding_left = 8,
  --   padding_right = 4,
  --   font = {
  --     family = settings.font.numbers,
  --     style = settings.font.style_map["Regular"],
  --     size = 18,
  --   },
  --   color = colors.label,
  -- },
  label = {
    color = colors.label,
    font = {
      family = settings.font.text,
      style = settings.font.style_map["Regular"],
      size = 18,
    },
    align = "left",
    padding_right = 8,
    padding_left = 8,
  },
  padding_left = 10,
  position = "right",
  update_freq = 1,
  -- click_script = "open -a 'Calendar'",
})

-- english date
cal:subscribe({ "forced", "routine", "system_woke" }, function(env)
  cal:set { label = os.date "%A %d %B %m-%Y %I:%M:%S %p" }
end)
