local mod = "SUPER"

-----------------
-- launch apps --
-----------------

-- terminal
hl.bind(mod .. " + R", hl.dsp.exec_cmd(terminal))
hl.bind(mod .. " + SHIFT + R", hl.dsp.exec_cmd(terminal .. " --class=floating-" .. terminal))

-- files
hl.bind(mod .. " + E", hl.dsp.exec_cmd(terminal .. " yazi"))
hl.bind(mod .. " + SHIFT + E", hl.dsp.exec_cmd("cosmic-files"))

-- dmenu
hl.bind(mod .. " + D", hl.dsp.exec_cmd(menu))
-- TODO: rofi run
-- hl.bind(mod .. " + SHIFT + E", hl.dsp.exec_cmd("cosmic-files"))

-- wallpaper picker
hl.bind(mod .. " + SHIFT + I", hl.dsp.exec_cmd("chwal"))

-- screenshot
hl.bind(mod .. " + SHIFT + S", hl.dsp.exec_cmd(
  "mkdir -p " .. screenshotDir                                       -- generate screenshots dir
  .. ' && grim -g "$(slurp)" -'                                      -- take screenshot
  .. " | tee " .. screenshotDir .. "/$(date +%Y-%m-%d_%H-%M-%S).png" -- save
  .. " | wl-copy"                                                    -- copy
))

-- why does it spell bdsm :cry:
hl.bind(mod .. " + ALT + B", hl.dsp.exec_cmd(browser))
hl.bind(mod .. " + ALT + D", hl.dsp.exec_cmd("vesktop"))
hl.bind(mod .. " + ALT + S", hl.dsp.exec_cmd("steam -steamos"))
hl.bind(mod .. " + ALT + M", hl.dsp.exec_cmd("spotify"))

hl.bind(mod .. " + ALT + A", hl.dsp.exec_cmd("anytype"))
hl.bind(mod .. " + ALT + T", hl.dsp.exec_cmd("Telegram"))

-------------
-- windows --
-------------

hl.bind(mod .. " + Q", hl.dsp.window.close())
hl.bind(mod .. " + F", hl.dsp.window.fullscreen({ mode = "maximized" }))
hl.bind(mod .. " + SHIFT + F", hl.dsp.window.fullscreen())
hl.bind(mod .. " + SHIFT + Space", hl.dsp.window.float({ action = "toggle" }))

-- focus
hl.bind(mod .. " + H", hl.dsp.focus({ direction = "l" }))
hl.bind(mod .. " + J", hl.dsp.focus({ direction = "d" }))
hl.bind(mod .. " + K", hl.dsp.focus({ direction = "u" }))
hl.bind(mod .. " + L", hl.dsp.focus({ direction = "r" }))

hl.bind(mod .. " + Tab", hl.dsp.window.cycle_next())

-- move
hl.bind(mod .. " + SHIFT + left", hl.dsp.window.move({ direction = "l" }))
hl.bind(mod .. " + SHIFT + right", hl.dsp.window.move({ direction = "r" }))
hl.bind(mod .. " + SHIFT + up", hl.dsp.window.move({ direction = "u" }))
hl.bind(mod .. " + SHIFT + down", hl.dsp.window.move({ direction = "d" }))
hl.bind(mod .. " + SHIFT + H", hl.dsp.window.move({ direction = "l" }))
hl.bind(mod .. " + SHIFT + J", hl.dsp.window.move({ direction = "d" }))
hl.bind(mod .. " + SHIFT + K", hl.dsp.window.move({ direction = "u" }))
hl.bind(mod .. " + SHIFT + L", hl.dsp.window.move({ direction = "r" }))

-- resize
hl.bind(mod .. " + left", hl.dsp.window.resize({ x = -100, y = 0, relative = true }), { repeating = true })
hl.bind(mod .. " + right", hl.dsp.window.resize({ x = 100, y = 0, relative = true }), { repeating = true })
hl.bind(mod .. " + up", hl.dsp.window.resize({ x = 0, y = -100, relative = true }), { repeating = true })
hl.bind(mod .. " + down", hl.dsp.window.resize({ x = 0, y = 100, relative = true }), { repeating = true })
hl.bind(mod .. " + ALT_L + H", hl.dsp.window.resize({ x = -100, y = 0, relative = true }), { repeating = true })
hl.bind(mod .. " + ALT_L + J", hl.dsp.window.resize({ x = 0, y = 100, relative = true }), { repeating = true })
hl.bind(mod .. " + ALT_L + K", hl.dsp.window.resize({ x = 0, y = -100, relative = true }), { repeating = true })
hl.bind(mod .. " + ALT_L + L", hl.dsp.window.resize({ x = 100, y = 0, relative = true }), { repeating = true })

-- mouse resize
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

----------------
-- workspaces --
----------------

hl.bind(mod .. " + grave", hl.dsp.workspace.toggle_special())
hl.bind(mod .. " + SHIFT + grave", hl.dsp.window.move({ workspace = "special" }))

for i = 1, 10 do
  local key = i % 10 -- 10 -> 0
  hl.bind(mod .. " + " .. key, hl.dsp.focus({ workspace = i }))
  hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- second monitor workspace
hl.bind(mod .. " + W", hl.dsp.focus({ workspace = 6 }))
hl.bind(mod .. " + SHIFT + W", hl.dsp.window.move({ workspace = 6 }))

-----------
-- media --
-----------

-- MPRIS
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"))
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"))

hl.bind(mod .. " + 0", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind(mod .. " + minus", hl.dsp.exec_cmd("playerctl previous"))
hl.bind(mod .. " + equal", hl.dsp.exec_cmd("playerctl next"))

-- volume
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"), { repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { repeating = true })

-- brightness
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set 5%+ -q"), { repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%- -q"), { repeating = true })

hl.bind(mod .. " + bracketright", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { repeating = true })
hl.bind(mod .. " + bracketleft", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { repeating = true })

-- mute
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"))
