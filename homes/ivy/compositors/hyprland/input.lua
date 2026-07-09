hl.config({
  input = {
    kb_layout = layouts,
    kb_options = layout_kbo,

    follow_mouse = 1,

    -- set flat globally because my mouse just won't
    accel_profile = accel,
    sensitivity = sensitivity,

    touchpad = {
      natural_scroll = true,
    },
  },
})

-- workspace gesture
hl.gesture({ fingers = 3, direction = "vertical", action = "workspace" })

-- let touchpad accelerate
hl.device({
  name = "msft0001:00-04f3:3186-touchpad",
  sensitivity = 0,
  accel_profile = "adaptive",
})
