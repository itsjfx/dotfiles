local M = {}

local with_alpha = function(color, alpha)
  if alpha > 1.0 or alpha < 0.0 then
    return color
  end
  return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
end

local transparent = 0x00000000

local rp_moon = {
  base = 0xff232136,
  surface = 0xff2a273f,
  overlay = 0xff393552,
  muted = 0xff6e6a86,
  subtle = 0xff908caa,
  text = 0xffe0def4,
  love = 0xffeb6f92,
  gold = 0xfff6c177,
  rose = 0xffea9a97,
  iris = 0xffc4a7e7,
  pine = 0xff3e8fb0,
  foam = 0xff9ccfd8,
  highlight_low = 0xff21202e,
  highlight_med = 0xff44415a,
}

local me = {
  background = 0xff282a2e,
}

local dracula = {
  cyan = 0xff8be9fd, -- #8be9fd
  purple = 0xffbd93f9, -- #bd93f9
  red = 0xffff5555, -- #ff5555
  yellow = 0xfff1fa8c, -- #f1fa8c
  green = 0xff50fa7b, -- #50fa7b
  pink = 0xffff79c6, -- #ff79c6
  orange = 0xffffb86c, -- #ffb86c
}

local rp = {
  base = 0xff191724,
  surface = 0xff1f1d2e,
  overlay = 0xff26233a,
  muted = 0xff6e6a86,
  subtle = 0xff908caa,
  text = 0xffe0def4,
  love = 0xffeb6f92,
  gold = 0xfff6c177,
  rose = 0xffebbcba,
  iris = 0xffc4a7e7,
  pine = 0xff31748f,
  foam = 0xff9ccfd8,
  highlight_low = 0xff21202e,
  highlight_med = 0xff403d52,
  highlight_high = 0xff524f67,
}

local theme = rp

M.sections = {
  bar = {
    bg = me.background,
    border = theme.highlight_low,
  },
  item = {
    bg = theme.overlay,
    border = theme.base,
    text = theme.text,
  },
  apple = theme.text,
  spaces = {
    icon = {
      color = theme.subtle,
      highlight = theme.text,
    },
    label = {
      color = theme.subtle,
      highlight = theme.gold,
    },
    indicator = theme.iris,
  },
  media = {
    label = theme.subtle,
  },
  widgets = {
    battery = {
      low = theme.love,
      mid = theme.gold,
      high = theme.pine,
    },
    wifi = { icon = theme.rose },
    volume = {
      icon = theme.foam,
      popup = {
        item = theme.subtle,
        highlight = theme.text,
      },
      slider = {
        highlight = theme.foam,
        bg = theme.highlight_med,
        border = theme.highlight_low,
      },
    },
    messages = { icon = theme.love },
  },
  calendar = {
    label = dracula.cyan,
  },
}

return M
