-- TODO: generalize this in ceirios.hardware?
hl.config({
  input = {
    kb_layout = "us,ru,pl,ua",
    kb_options = "grp:alt_shift_toggle",

    follow_mouse = 1,

    -- set flat globally because my mouse just won't
    accel_profile = "flat",

    touchpad = {
      natural_scroll = true,
    },
  }
})

-- workspace gesture
hl.gesture({ fingers = 3, direction = "vertical", action = "workspace" })

-- let touchpad accelerate
hl.device({
  name = "msft0001:00-04f3:3186-touchpad",
  sensitivity = 0,
  accel_profile = "adaptive",
})
