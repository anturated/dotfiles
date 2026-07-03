-- https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- games can be native, wayland, and gamescope, thus this many rules

-- steam / xwayland
hl.window_rule({
  name = "games",
  match = {
    class = "^(steam_app_.*)$" -- proton xwayland
      -- linux native steam games
      .. "|^(cs2)$|^(Celeste.bin.x86_64)$|^(Celeste)$|^(valheim.x86_64)$"
      -- Minecraft modpacks (they just have to have a different title all of them)
      .. "|^(Minecraft.*)$|^(DREAD.*)$"
      -- no idea what this is, might be steam's remote play
      .. "|^(Streaming Client)$",
  },

  immediate = true,
  fullscreen = true,
  workspace = "2 silent",
})

-- games on wayland seem to set contentType = "game" pretty consistently
hl.window_rule({
  name = "games-wayland",
  match = { content = "game" },

  immediate = true,
  fullscreen = true,
  workspace = "2 silent",
})

-- gamescope is just gamescope
hl.window_rule({
  name = "gamescope",
  match = { class = "gamescope" },

  fullscreen = true,
  workspace = "2 silent",
})

-- floating stuff --

hl.window_rule({
  match = { class = "floating-" .. terminal },

  float = true,
})

hl.window_rule({
  name = "picture-in-picture",
  match = { title = "^(Picture in picture)$" },

  float = true,
  pin = true,
  size = "480 270",
  move = "1440 810",
})

hl.window_rule({
  name = "discord-popout",
  match = { initial_title = "^Discord Popout$" },

  float = true,
  pin = true,
  size = "480 270",
  move = "1440 810",
})

-- keep apps on their workspaces --

hl.window_rule({
  name = "messagers",
  match = { class = "^(vesktop)$|^(org.telegram.desktop)$" },

  workspace = "3 silent",
})

hl.window_rule({
  name = "music-apps",
  match = { class = "^(spotify)$|^(Spotify)$" },

  workspace = "4 silent",
})

hl.window_rule({
  name = "game-launchers",
  match = { class = "^(steam)$|^(com.usebottles.bottles)$|^(org.prismlauncher.PrismLauncher)$" },

  workspace = "5 silent",
})

hl.window_rule({
  name = "steam-installer",
  match = {
    class = "",
    title = "Steam",
  },

  workspace = "5 silent",
})

-- fixes --

hl.window_rule({
  name = "float-some-apps",
  match = { class = "^(gay.vaskel.soteria)$" },

  float = true,
})

hl.window_rule({
  name = "ignore-maximize",
  match = { class = ".*" },

  suppress_event = "maximize",
})

-- Fix some dragging issues with XWayland
hl.window_rule({
  name = "fix-xwayland-drag",
  match = {
    class = "^$",
    title = "^$",
    xwayland = true,
    float = true,
    fullscreen = false,
    pin = false,
  },

  no_focus = true,
})

-- misc --

hl.window_rule({
  name = "browser-no-borders",
  match = { class = "^(vivaldi-stable)$|^(zen)$" },

  workspace = "1 silent",
  border_size = 0,
})

hl.window_rule({
  name = "nvim-no-blur",
  match = {
    class = "^(" .. terminal .. ")$|^(floating-" .. terminal .. ")$",
    title = ".* - Nvim",
  },

  no_blur = true,
})
