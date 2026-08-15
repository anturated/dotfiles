Name = "music"
NamePretty = "Music"
Icon = "audio-x-generic"
Action = 'playalbum "%VALUE%"'
Description = "Browse and play music albums"

local AUDIO_EXT = {
  flac = true,
  mp3 = true,
  ogg = true,
  opus = true,
  wav = true,
  m4a = true,
  aac = true,
  wv = true,
  ape = true,
}

local COVER_NAMES = {
  "cover.jpg",
  "cover.jpeg",
  "cover.png",
  "cover.webp",
  "folder.jpg",
  "folder.jpeg",
  "folder.png",
  "folder.webp",
}

local function shell_escape(s)
  return "'" .. s:gsub("'", "'\\''") .. "'"
end

local function file_exists(path)
  local f = io.open(path, "rb")
  if f then
    f:close()
    return true
  end
  return false
end

local function find_cover(dir)
  for _, name in ipairs(COVER_NAMES) do
    local path = dir .. "/" .. name
    if file_exists(path) then
      return path
    end
  end
  return nil
end

local function list_tracks(dir)
  local exts = {}
  for ext in pairs(AUDIO_EXT) do
    table.insert(exts, "-iname '*." .. ext .. "'")
  end
  local cmd = "find "
    .. shell_escape(dir)
    .. " -maxdepth 1 -type f \\( "
    .. table.concat(exts, " -o ")
    .. " \\) 2>/dev/null | sort"

  local tracks = {}
  local handle = io.popen(cmd)
  if handle then
    for line in handle:lines() do
      local name = line:match("([^/]+)$")
      if name then
        table.insert(tracks, name)
      end
    end
    handle:close()
  end
  return tracks
end

function GetEntries()
  local entries = {}

  local home = os.getenv("HOME")
  local music_dir = home .. "/media/music/"
  local thumb_dir = home .. "/.cache/ceirios/musicthumbs/"
  os.execute("mkdir -p " .. shell_escape(thumb_dir))

  local handle =
    io.popen("find " .. shell_escape(music_dir) .. " -mindepth 1 -maxdepth 1 -type d ! -name '.*' 2>/dev/null | sort")
  if not handle then
    return entries
  end

  for line in handle:lines() do
    local album = line:match("([^/]+)$")
    if album then
      local tracks = list_tracks(line)
      if #tracks > 0 then
        local entry = {
          Text = album,
          Subtext = #tracks .. " tracks",
          Value = line,
          Preview = table.concat(tracks, "\n"),
          PreviewType = "text",
        }

        local cover = find_cover(line)
        if cover then
          local rel = line:sub(#music_dir + 1)
          local cache_key = rel:gsub("/", "_")
          local thumb = thumb_dir .. cache_key .. ".png"

          if not file_exists(thumb) then
            local cmd = "magick "
              .. shell_escape(cover)
              .. " -thumbnail 100x100 "
              .. shell_escape(thumb)
              .. " >/dev/null 2>&1 &"
            local ph = io.popen(cmd)
            if ph then
              ph:close()
            end
          end

          entry.Icon = thumb
        end

        table.insert(entries, entry)
      end
    end
  end
  handle:close()

  return entries
end
