# NixOS dotfiles

![preview](./preview.webp)

<details>
<summary><h2>Install</h2></summary>

Assuming you already have a working nixos install going on:

1. **Fork/clone**

```bash
git clone https://github.com/anturated/dotfiles
cd dotfiles
```

2. **Add your host config** to [machines/](https://github.com/anturated/dotfiles/tree/master/machines).
Whatever you call the directory, that's gonna be your hostname.
You can use [legion](https://github.com/anturated/dotfiles/blob/master/machines/legion/default.nix) as an example.
Also options for
[monitors](https://github.com/anturated/dotfiles/blob/master/modules/nixos/hardware/monitors.nix),
[GPUs](https://github.com/anturated/dotfiles/blob/master/modules/nixos/hardware/gpu/default.nix),
and [profiles](https://github.com/anturated/dotfiles/blob/master/modules/generic/profiles.nix)
might be useful.

3. **Add hardware config**.
It should land on `<dotfiles>/machines/<hostname>/hardware.nix`, and the `default.nix` for that machine must `import` it.
```bash
nixos-generate-config --show-hardware-config > machines/<hostname>/hardware.nix
```

4. **Add your user** to [users/all-users.nix](https://github.com/anturated/dotfiles/blob/master/users/all-users.nix) (you can remove what you don't need).
It MUST have a hashed password. Get yours: `mkpasswd -m yescrypt`

5. **Add your user to host config**

```nix
{ # machines/<hostname>/default.nix
  imports = [ ./hardware.nix ];

  ceirios = {
    # ...
    system.users.yourname = { };
    # ...
  };
}
```

- (Optionally) **move your entire home-manager config** under `homes/<name>` if you have one.
Look at [ivy](https://github.com/anturated/dotfiles/blob/master/homes/ivy/default.nix) as an example.
Then use like this:

```nix
{ # machines/<hostname>/default.nix
  ceirios = {
    # ...
    system.users = {
      yourname = { home = "yourhome"; };
      desant = { home = "ivy"; };
      anturated = { home = "kde"; };
      john = { home = "gnome"; };
    };
    # ...
  };
}
```

6. **Rebuild**.
Replace `<hostname>` with your actual hostname from previous steps like `.#legion`.
```bash
sudo nixos-rebuild boot --flake .#<hostname>
```

7. **Reboot**

And you're done.

</details>

<details>
<summary><h2>Using</h2></summary>

> [!WARN]
> No password prompts on sudo commands.
> Don't do anything stupid.

### Binds
- `super d` - drun
- `super shift d` - run
- `super r` - terminal
- `super shift r` - terminal (float)
- `super e` - yazi (terminal file explorer)
- `super shift e` - nemo (file explorer)

- `super alt b` - browser
- `super alt d` - discord
- `super alt s` - steam
- `super alt m` - spotify

- `super q` - close window
- `super f` - maximize
- `super shift f` - fullscreen
- `super shift space` - float

- `super 0-9` - workspaces
- `super -=` - play next/prev
- `super space` - play/pause
- `super []` - brightness
The rest of them is [here](https://github.com/anturated/dotfiles/blob/master/homes/ivy/compositors/hyprland/keybinds.lua)

### Commands
- `chwal` (`super shift i`) - Wallpaper picker.
Auto-themes and reloads colors on most apps.
Wallpapers are at `~/media/pictures/wallpapers/`.
GIFs take a while to load the first time.
- `animelist` (`super alt w`) - opens everything in `~/media/videos/anime/<name>/` in mpv.

### Zoxide
Present. `z /some/very/deeply/nested/directory` once and `z dir[ectory]` to jump there afterwards. The better `cd`.

### Nvim
Pre-styled. Open in some dir and press `q` to load last session.
There's also a `zn <somewhere>` shortcut to zoxide + open nvim.

Example: `zn dot`: `cd`s into `~/dev/dotfiles` and opens nvim.

### Kale
Add `kale %command%` to your game's launch args for a slight boost (replaces gamemode, offload, gamescope, and mangohud).
By default it will
optimize hyprland,
switch power profile (if on laptop),
use ntsync,
offload (if configured in system),
gamemoderun,
mangohud,
use wayland (if on proton-ge),
use FSR 4.

Args it can take:
`-m` - minimal
`-s` - SteamDeck=1
`-l` - PROTON_LOG=1
`-x` - PROTON_ENABLE_WAYLAND=0
`-g` - enable gamemode system-wide, don't `gamemoderun`
`-G` - enable gamemode system-wide, `gamemoderun`
`-b` - bypass game launcher (EAC, UPlay, etc.), `gamemoderun` the game itself
`-n` - no gamemode
`-S` - gamescope (poorly tested)
`-c` - clean/customize, to be used with these (which are on by default):
`-H` - optimize hyprland
`-O` - offload
`-M` - mangohud
`-P` - switch power profile

### Other small things
A justfile is included with the repo, if you have something to run it with:
```bash
just rebuild         # rebuilds config

just boot            # rebuild, switch on reboot

just test            # see if it'll build

just update          # update inputs and commit

just update [inputs] # update specific inputs

just gif [path]      # turns a video at <path> into a gif in your wallpapers
```

---

If for some reason you want to use one of my ISOs, there's an installer.
It is bad and will nuke a drive tho. Not a partition, a **drive**.

From a booted ISO:

```bash
sudo -i
llin
```

</details>

## TODO
- [ ] wifi menu
- [ ] bluetooth menu
- [ ] power menu
- [ ] brightness/volume sliders
- [ ] notifs
- [ ] better defaults customization
- [ ] kale seems to not exit properly

## Thank/Credits
- [isabelroses/dotfiles](https://github.com/isabelroses/dotfiles) - HEAVILY based upon, will happily steal more
- [neon-grim/NixConfig](https://github.com/neon-grim/NixConfig) - initial idea for `kale` and multihost setup, and also what got me to even try
- [anturated/dotfiles](https://github.com/anturated/.dotfiles/tree/master/nixos) - my old horrible config
- wallpapers: [swing](https://www.pixiv.net/en/artworks/102808319)
