-- https://wiki.hypr.land/Configuring/Basics/Variables/
-- https://github.com/hyprwm/Hyprland/blob/24c5c13c2cef2b4324478f2fb8c2ecc386dd42d3/example/hyprland.lua#L82

hl.config({
  general = {
    gaps_in = 5,
    gaps_out = 5,

    border_size = 1,

    -- col is completely offloaded to matugen

    -- set to true if i ever want to use a mouse
    resize_on_border = false,

    -- we game. this should only affect windows that request tearing.
    -- if this is false, tearing won't happen at all.
    -- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/
    allow_tearing = false,

    -- binary tree layout
    layout = "dwindle",
  },

  decoration = {
    -- i bet you i came up with these numbers at 5am
    rounding = 13,
    rounding_power = 2,

    active_opacity = 1.0,
    inactive_opacity = 0.92,

    shadow = {
      enabled = true,
      range = 4,
      render_power = 3,
      color = 0xee1a1a1a, -- default
    },

    blur = {
      enabled = true,
      size = 1,
      passes = 2,
      vibrancy = 0.1696,
    },
  },

  animations = {
    enabled = true, -- o7 farewell "yes, please :)", you will be missed
  },

  -- we have wallpapers at home
  misc = {
    force_default_wallpaper = 1,
    disable_hyprland_logo = true,
  },
})

-- workspace and window cosmetic tweaks --

-- remove gaps where only one window is visible
hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 }) -- one window
hl.workspace_rule({ workspace = "f[1]", gaps_out = 0, gaps_in = 0 }) -- fullscreen

-- remove borders and rounding where only one window is visible
hl.window_rule({ match = { float = false, workspace = "w[tv1]" }, border_size = 0 })
hl.window_rule({ match = { float = false, workspace = "w[tv1]" }, rounding = 0 })
hl.window_rule({ match = { float = false, workspace = "f[1]" }, border_size = 0 })
hl.window_rule({ match = { float = false, workspace = "f[1]" }, rounding = 0 })
