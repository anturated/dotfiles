##############
#  INTERNAL  #
##############

flake := env('FLAKE', justfile_directory())

[group('rebuild')]
[no-exit-message]
[private]
builder action *args:
  #!/usr/bin/env bash
  set -euo pipefail
  nixos-rebuild {{ action }} \
    --flake {{ flake }} \
    --log-format internal-json \
    --no-reexec \
    --sudo \
    {{ args }} \
    |& nom --json

[group('deploy')]
[no-exit-message]
[private]
deployer host action *args:
  #!/usr/bin/env bash
  set -euo pipefail
  just builder {{ action }} \
    --target-host {{ host }} \
    --use-substitutes \
    {{ args }}

[group('deploy')]
[no-exit-message]
[private]
deployer-all goal:
    #!/usr/bin/env bash
    set -euo pipefail

    just deployer cynnil {{ goal }}

################
#   REBUILDS   #
################

alias rb := rebuild

[group('rebuild')]
[no-exit-message]
rebuild *args: (builder "switch" args)

[group('rebuild')]
[no-exit-message]
boot *args: (builder "boot" args)

[group('rebuild')]
[no-exit-message]
test *args: (builder "test" args)

###############
#   DEPLOYS   #
###############

[group('deploy')]
[no-exit-message]
deploy host *args: (deployer host "switch" args)

[group('deploy')]
[no-exit-message]
deploy-boot host *args: (deployer host "boot" args)

[group('rebuild')]
[no-exit-message]
deploy-all: (deployer-all "switch")

[group('rebuild')]
[no-exit-message]
deploy-all-boot: (deployer-all "boot")

###############
#   SHARING   #
###############

[group('sharing')]
[no-exit-message]
iso image:
  nom build {{ flake }}#nixosConfigurations.{{ image }}.config.system.build.isoImage

# this produces the entire system config
[group('sharing')]
[no-exit-message]
tar host:
  sudo nix run {{ flake }}#nixosConfigurations.{{ host }}.config.system.build.tarballBuilder

[group('sharing')]
[no-exit-message]
dots host user:
  nix build -L {{ flake }}#nixosConfigurations.{{host}}.config.home-manager.users.{{ user }}.home-files
  tar -czvhf dotfiles.tar.gz result/

#############
#   ADMIN   $
#############

[group('admin')]
[no-exit-message]
update *inputs:
    nix flake update {{ inputs }} \
      --flake {{ flake }} \
      --refresh \
      --commit-lock-file \
      --commit-lockfile-summary "flake: {{ if inputs == "" { "bump" } else { "update " + inputs } }}"

[group('admin')]
[no-exit-message]
rotate-secrets:
    find secrets/ -name "*.yaml" | xargs -I {} sops rotate -i {}

[group('admin')]
[no-exit-message]
update-secrets:
    find secrets/ -name "*.yaml" | xargs -I {} sops updatekeys -y {}

#############
#   UTILS   #
#############

[group('utils')]
[no-exit-message]
gc:
    nix-collect-garbage --delete-older-than 3d
    nix store optimise

# makes a gif from a video
[group('utils')]
[no-exit-message]
gif input:
    #!/usr/bin/env bash
    stem=$(basename "{{input}}" | sed 's/\.[^.]*$//')
    palette="/tmp/${stem}-palette.png"
    output="$XDG_PICTURES_DIR/wallpapers/${stem}.gif"
    ffmpeg -i "{{input}}" \
      -vf "fps=60,scale=1920:1080:flags=lanczos:force_original_aspect_ratio=increase,crop=1920:1080,palettegen=stats_mode=diff" \
      "$palette"
    ffmpeg -i "{{input}}" -i "$palette" \
      -lavfi "fps=60,scale=1920:1080:flags=lanczos:force_original_aspect_ratio=increase,crop=1920:1080 [x]; [x][1:v] paletteuse=dither=bayer:bayer_scale=5:diff_mode=rectangle" \
      "$output"

# same as gif but tries to make it better quality
[group('utils')]
[no-exit-message]
bettergif input:
    #!/usr/bin/env bash
    stem=$(basename "{{input}}" | sed 's/\.[^.]*$//')
    palette="/tmp/${stem}-palette.png"
    output="$XDG_PICTURES_DIR/wallpapers/${stem}.gif"
    ffmpeg -i "{{input}}" \
      -vf "fps=60,scale=1920:1080:flags=lanczos:force_original_aspect_ratio=increase,crop=1920:1080,unsharp=5:5:0.8:3:3:0.4,palettegen=stats_mode=diff" \
      "$palette"
    ffmpeg -i "{{input}}" -i "$palette" \
      -lavfi "fps=60,scale=1920:1080:flags=lanczos:force_original_aspect_ratio=increase,crop=1920:1080,unsharp=5:5:0.8:3:3:0.4 [x]; [x][1:v] paletteuse=dither=bayer:bayer_scale=5:diff_mode=rectangle" \
      "$output"

[group('utils')]
[no-exit-message]
hash url:
    nix-prefetch-url --type sha256 '{{url}}' 2>/dev/null | xargs -I{} nix hash convert --hash-algo sha256 {}
