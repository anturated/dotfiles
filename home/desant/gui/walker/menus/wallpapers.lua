Name = "wallpapers"
NamePretty = "Wallpapers"
Action = "chwal %VALUE%"
Icon = "camera-photo"

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

local function file_size(path)
  local f = io.open(path, "rb")
  if not f then
    return nil
  end
  local size = f:seek("end")
  f:close()
  return size
end

local function human_size(bytes)
  if not bytes then
    return "Size: ???"
  end
  local units = { "B", "K", "M", "G", "T" }
  local size, i = bytes, 1
  while size >= 1024 and i < #units do
    size = size / 1024
    i = i + 1
  end
  if i == 1 then
    return string.format("Size: %d%s", size, units[i])
  end
  return string.format("Size: %.1f%s", size, units[i])
end

function GetEntries()
  local entries = {}

  -- note: doesn't work with XDG_XXX for whatever reason
  local home = os.getenv("HOME")
  local wallpaper_dir = home .. "/media/pictures/wallpapers/"
  local thumb_dir = home .. "/.cache/wallthumbs/"

  os.execute("mkdir -p " .. shell_escape(thumb_dir))

  local find_cmd = "find "
    .. shell_escape(wallpaper_dir)
    .. " -type f \\( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png'"
    .. " -o -iname '*.gif' -o -iname '*.bmp' -o -iname '*.webp' \\) 2>/dev/null"

  local handle = io.popen(find_cmd)
  if not handle then
    return entries
  end

  for line in handle:lines() do
    local filename = line:match("([^/]+)$")
    if filename then
      local rel = line:sub(#wallpaper_dir + 1)
      local cache_key = rel:gsub("/", "_")
      local thumb = thumb_dir .. cache_key

      if not file_exists(thumb) then
        local cmd = "magick "
          .. shell_escape(line)
          .. "[0] -thumbnail 500x500 "
          .. shell_escape(thumb)
          .. " >/dev/null 2>&1 &"
        local ph = io.popen(cmd)
        if ph then
          ph:close()
        end
      end

      table.insert(entries, {
        Text = filename,
        Subtext = human_size(file_size(line)),
        Value = line,
        Preview = thumb,
        PreviewType = "file",
        Icon = thumb,
      })
    end
  end
  handle:close()

  return entries
end
