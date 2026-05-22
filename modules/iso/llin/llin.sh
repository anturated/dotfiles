#!/usr/bin/env bash

set -euo pipefail

# WARN: probably should do all the checks (repo, boot, etc.) BEFORE we wipe the disk.

VERBOSE=false
if [[ "${1:-}" == "-v" ]]; then
  VERBOSE=true
fi

# wrapper
run() {
  if $VERBOSE; then
    "$@"
  else
    "$@" >/dev/null 2>&1 # TODO: collect logs and print on failure
  fi
}

mask_to_cidr() {
  local mask=$1
  local cidr=0
  IFS='.' read -r a b c d <<< "$mask"
  for octet in $a $b $c $d; do
    while [ "$octet" -gt 0 ]; do
      cidr=$((cidr + (octet & 1)))
      octet=$((octet >> 1))
    done
  done
  echo $cidr
}

echo "• ──────────────────   Ceirios ────────────────── •"
echo "  Welcome to Ceirios! (installer)"
echo "  Press Ctrl+C to cancel."
echo "• ──────────────────── System ──────────────────── •"

##################
# CHECK INTERNET #
##################

echo "  Checking if we have internet..."
ping -c1 -W3 8.8.8.8 > /dev/null 2>&1 && HAS_INTERNET=1 || HAS_INTERNET=0

if [ "$HAS_INTERNET" -eq 0 ]; then
  echo "  No internet. Unfortunate. Checking adapters..."

  adapters=$(ip -o link show | awk -F': ' '{print $2}' | grep -v lo)
  count=$(echo "$adapters" | wc -l)
  adapter=""

  if [ "$count" -eq 1 ]; then
    adapter="$adapters"
    echo "  One adapter found, good."
  else
    adapter=$(echo "$adapters" |
    gum choose \
      --header "  Choose the real adapter:" \
      --header.foreground 15 \
      --item.foreground 8 \
      --cursor.foreground 2)
  fi

  if [ -z "$adapter" ]; then
    echo "Well that's awkward. No adapter"
    exit 1
  fi

  echo "  Your adapter is: $adapter"
  echo "  Go to your panel and find this info:"

  ipv4=$(gum input \
      --header "  IPv4, optionally add /prefix:" \
      --header.foreground 15 \
      --placeholder "123.45.67.89/24" \
      --placeholder.foreground 8 \
      --prompt.foreground 8 \
      --cursor.foreground 15)

  [ -z "$ipv4" ] && exit 1

  ip_cidr="$ipv4"

  if ! echo "$ipv4" | grep -q '/'; then
    netmask=$(gum input \
        --header "  No prefix. Enter your netmask:" \
        --header.foreground 15 \
        --placeholder "255.255.255.0" \
        --placeholder.foreground 8 \
        --prompt.foreground 8 \
        --cursor.foreground 15)

    [ -z "$netmask" ] && exit 1

    ip_cidr="${ipv4}/$(mask_to_cidr "$netmask")"
  fi

  echo "  ip: $ip_cidr"

  gateway=$(gum input \
      --header "  Enter your gateway:" \
      --header.foreground 15 \
      --placeholder "192.168.1.1" \
      --placeholder.foreground 8 \
      --prompt.foreground 8 \
      --cursor.foreground 15)

  [ -z "$gateway" ] && exit 1

  echo "  gateway: $gateway"

  # set the device up
  ip addr flush dev "$adapter" # for good measure
  ip addr add "$ip_cidr" dev "$adapter"
  ip route add default via "$gateway"
  ip link set "$adapter" up

  echo "  See if it works..."
  ping -c1 -W3 8.8.8.8 > /dev/null 2>&1 && GOT_INTERNET=1 || GOT_INTERNET=0

  if [ "$GOT_INTERNET" -eq 0 ]; then
    echo "  Nope."
    exit 1
  fi
fi

echo "  Yep. See if DNS works..."
ping -c1 -W3 github.com > /dev/null 2>&1 && HAS_DNS=1 || HAS_DNS=0

if [ "$HAS_DNS" -eq 0 ]; then
  nameserver=$(gum input \
    --header "  Enter your nameserver (one is enough):" \
      --header.foreground 15 \
      --placeholder "192.168.1.1" \
      --placeholder.foreground 8 \
      --prompt.foreground 8 \
      --cursor.foreground 15)

  [ -z "$nameserver" ] && exit 1

  echo "nameserver $nameserver" >> /etc/resolv.conf
  echo "  See if it works now..."
  ping -c1 -W3 github.com > /dev/null 2>&1 && GOT_DNS=1 || GOT_DNS=0

  if [ "$GOT_DNS" -eq 0 ]; then
    echo "  Nope."
    exit 1
  fi
fi

echo "  You have internet."

gum confirm "Exit installer so you can SSH?" \
    --affirmative "yes" \
    --negative "no" \
    --prompt.foreground 15 \
    --selected.foreground 16 \
    --selected.background 15 \
    --unselected.foreground 15 \
    --unselected.background 16 \
    --padding "1 2" \
    --no-show-help \
&& exit 0 \
|| true

# get some information from the user
hostname=$(gum input \
    --header "  Enter your hostname:" \
    --header.foreground 15 \
    --placeholder "saeth" \
    --placeholder.foreground 8 \
    --prompt.foreground 8 \
    --cursor.foreground 15)
echo "  Hostname: $hostname"

drive=$(lsblk -nlo PATH,TYPE |
  awk '$2 == "disk" { print $1 }' | # choose only disks
  gum choose \
    --header "  Install to:" \
    --header.foreground 15 \
    --item.foreground 8 \
    --cursor.foreground 2)
echo "  Install to: $drive"
echo "• ──────────────────────────────────────────────── •"
echo "  Checking if we are BIOS or UEFI..."

IS_UEFI=1
ls /sys/firmware/efi >/dev/null 2>&1 || IS_UEFI=0

if [ "$IS_UEFI" -eq 0 ]; then
  echo "  BIOS."
  echo "! MAKE SURE YOU HAVE GRUB AND GRUB DEVICE SET!"

  # Determine partition prefix based on drive type
  if [[ $drive == *"nvme"* ]]; then
    # nvme dirves like /dev/nvme0n1p1
    echo "  Looks like nvme. Using p1-p4"
    bios_part="${drive}p1"
    boot_part="${drive}p2"
    root_part="${drive}p3"
    swap_part="${drive}p4"
  else
    # handle /dev/sda1 style drives
    echo "  Doesn't look like nvme. Using 1-4"
    bios_part="${drive}1"
    boot_part="${drive}2"
    root_part="${drive}3"
    swap_part="${drive}4"
  fi

  echo "  Will create these partitions:"
  echo "  $bios_part 1MiB"
  echo "  $boot_part 1024MiB"
  echo "  $root_part Most of it"
  echo "  $swap_part 8GiB"
else
  echo "  UEFI."
  # Determine partition prefix based on drive type
  if [[ $drive == *"nvme"* ]]; then
    # nvme dirves like /dev/nvme0n1p1
    echo "  Looks like nvme. Using p1-p3"
    boot_part="${drive}p1"
    root_part="${drive}p2"
    swap_part="${drive}p3"
  else
    # handle /dev/sda1 style drives
    echo "  Doesn't look like nvme. Using 1-3"
    boot_part="${drive}1"
    root_part="${drive}2"
    swap_part="${drive}3"
  fi

  echo "  Will create these partitions:"
  echo "  $boot_part 1024MiB"
  echo "  $root_part Most of it"
  echo "  $swap_part 8GiB"
fi

# last warning
gum confirm "Wipe $drive and set up flake?" \
    --affirmative "yes" \
    --negative "no" \
    --default=false \
    --prompt.foreground 1 \
    --selected.foreground 16 \
    --selected.background 15 \
    --unselected.foreground 15 \
    --unselected.background 16 \
    --padding "0 2" \
    && echo "  Wiping $drive..." \
    || exit 1

##############
#   MOUNTS   #
##############

# remove old install attempts (if there are any)
umount -R /mnt 2>/dev/null || true
swapoff -a 2>/dev/null || true

# cleanup
run wipefs -af "$drive" # fs signature
run sgdisk --zap-all "$drive" # headers

# refresh info
run partprobe "$drive"
run udevadm settle

# create some partitions
run parted -s "$drive" -- mklabel gpt

# partitions should start some space from 0 because alignment

# boot & root
if [ "$IS_UEFI" -eq 0 ]; then
  run parted -s "$drive" -- mkpart bios-boot 1MiB 2MiB # raw
  run parted -s "$drive" -- mkpart boot fat32 2MiB 1025MiB
  run parted -s "$drive" -- mkpart root btrfs 1025MiB -8GiB
  run parted -s "$drive" -- set 1 bios_grub on
  run parted -s "$drive" -- set 2 esp on # this needs to be on boot partition
else
  run parted -s "$drive" -- mkpart boot fat32 1MiB 1024MiB
  run parted -s "$drive" -- mkpart root btrfs 1024MiB -8GiB
  run parted -s "$drive" -- set 1 esp on
fi

# swap
run parted -s "$drive" -- mkpart swap linux-swap -8GiB 100%

# refresh info
run partprobe "$drive"
run udevadm settle

# format the partitions
echo "  Formatting..."
# boot-bios doesn't need formatting
run mkfs.fat -F32 -n boot "$boot_part"
run mkfs.btrfs -f -L root "$root_part" # force
run mkswap -L swap "$swap_part"
run swapon "$swap_part"

# mount the partitions whilst ensuring the directories exist
echo "  Mounting..."
run mkdir -p /mnt
run mount "$root_part" /mnt
run mkdir -p /mnt/boot
run mount "$boot_part" /mnt/boot

###################
#   GIT / FLAKE   #
###################

echo "  Setting up flake..."
run mkdir -p /mnt/etc/nixos/machines/"$hostname" # extend it all the way so we can write hw

# need to check a whole lot of git stuff because i might get funky
FLAKE_REPO="https://github.com/anturated/dotfiles"
CUSTOM_FLAKE=0

gum confirm "Do you want to use your own flake?" \
    --affirmative "yes" \
    --negative "no" \
    --default=false \
    --prompt.foreground 1 \
    --selected.foreground 16 \
    --selected.background 15 \
    --unselected.foreground 15 \
    --unselected.background 16 \
    --padding "0 2" \
    && CUSTOM_FLAKE=1 \
    || true # "no" exits with 1

if [ "$CUSTOM_FLAKE" -eq 1 ]; then
  echo "  Getting custom flake ready..."

  FLAKE_REPO=$(gum input \
      --header "  Enter your flake's git url:" \
      --header.foreground 15 \
      --placeholder "https://github.com/you/nix-config" \
      --placeholder.foreground 8 \
      --prompt.foreground 8 \
      --cursor.foreground 15)

  echo "  Checking if we can read..."
  CAN_READ=0
  git ls-remote "$FLAKE_REPO" HEAD >/dev/null 2>&1 && CAN_READ=1

  if [ "$CAN_READ" -eq 0 ]; then
    echo "  Can't read."
    echo "  Assuming this is a private repo. Generating keys."
    run ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -N ""

    IS_SSH=0
    echo "$FLAKE_REPO" | grep -q "@" && IS_SSH=1

    if [ "$IS_SSH" -eq 0 ]; then
      FLAKE_REPO=$(gum input \
          --header "  Enter ssh format url" \
          --header.foreground 15 \
          --placeholder "git@github.com:you/nix-config" \
          --placeholder.foreground 8 \
          --prompt.foreground 8 \
          --cursor.foreground 15)
    fi

    echo " ──  Add this to your flake repo's deploy keys:  ── "
    cat ~/.ssh/id_ed25519.pub
    echo " ──  ──  ──  ──  ──  ──  ──  ──  ──  ──  ──  ──  ── "

    read -rn 1 -p "  Press any key after you've done so."
    echo

    echo "  Setting up ssh agent..."

    # i NEED word splitting
    # shellcheck disable=SC2046
    eval $(ssh-agent -s) >/dev/null
    ssh-add ~/.ssh/id_ed25519 2>/dev/null

    # make git ssh silently accept github.com or whateve
    export GIT_SSH_COMMAND="ssh -o StrictHostKeyChecking=no"

    echo "  Trying to read one last time..."
    git ls-remote "$FLAKE_REPO" HEAD >/dev/null 2>&1 && CAN_READ=1

    if [ "$CAN_READ" -eq 0 ]; then
      echo "  Can't read repo unfortunately."
      exit 1
    fi
  fi
fi

echo "  Config will be grabbed from $FLAKE_REPO"
branch="master" # this flake's primary branch

# determine main branch if it's not my flake
if [ "$CUSTOM_FLAKE" -eq 1 ]; then
  DEFAULT_BRANCH=$(git ls-remote --symref "$FLAKE_REPO" HEAD | awk '/^ref:/ {sub("refs/heads/", "", $2); print $2}')

  branch=$(gum input \
    --header "  Branch:" \
    --header.foreground 15 \
    --value "$DEFAULT_BRANCH" \
    --prompt.foreground 8 \
    --cursor.foreground 15)
fi


echo "  Doing git stuff..."

# force our branch to silence the warning
run git -C /mnt/etc/nixos init -b "$branch"
run git -C /mnt/etc/nixos remote add origin "$FLAKE_REPO"

# get data from the forge
run git -C /mnt/etc/nixos fetch
run git -C /mnt/etc/nixos reset --hard "origin/$branch" # --hard actually copies the files
run git -C /mnt/etc/nixos branch --set-upstream-to=origin/"$branch" "$branch"

# overwrite, we formatted.
echo "  Generating hardware config..."
nixos-generate-config --root /mnt --show-hardware-config >/mnt/etc/nixos/machines/"$hostname"/hardware.nix
run git -C /mnt/etc/nixos add machines/"$hostname"/hardware.nix

################
#   SSH KEYS   #
################

# create ssh keys with no passphrases
echo "  Creating ssh host keys (for the new install)..."
run mkdir -p /mnt/etc/ssh
run ssh-keygen -t ed25519 -f /mnt/etc/ssh/ssh_host_ed25519_key -N ""
run ssh-keygen -t rsa -b 4096 -f /mnt/etc/ssh/ssh_host_rsa_key -N ""

###############
#   INSTALL   #
###############

# setup our installer args based off of our configuration
# this is concept is taken from https://github.com/lilyinstarlight/foosteros/blob/0d40c72ac4e81c517a7aa926b2a1fb4389124ff7/installer/default.nix
echo "  Checking if we should set password..."
installArgs=(--no-channel-copy)
if [ "$(nix eval "/mnt/etc/nixos#nixosConfigurations.$hostname.config.users.mutableUsers")" = "false" ]; then
  echo "  Nope."
  installArgs+=(--no-root-password)
else
  echo "  Yep. nixos-install will give you a prompt"
fi

echo "  We should be good."
echo ""
echo " ──  ──  ──  ──  To finish run this  ──  ──  ──  ── "
echo "nixos-install --flake /mnt/etc/nixos#$hostname ${installArgs[*]}"
echo " ──  ──  ──  ──  ──  ──  ──  ──  ──  ──  ──  ──  ── "

gum confirm "Want me to run it?" \
    --affirmative "yes" \
    --negative "no" \
    --prompt.foreground 15 \
    --selected.foreground 16 \
    --selected.background 15 \
    --unselected.foreground 15 \
    --unselected.background 16 \
    --padding "1 2" \
    --no-show-help \
&& nixos-install --flake "/mnt/etc/nixos#$hostname" "${installArgs[@]}" \
|| echo "  Ok. Run it manually then."
echo

# not really "keys" but you get the idea
# and it stays symmetrical
echo " ──  ──  ──  ──  ──   SSH KEYS   ──  ──  ──  ──  ── "
cat  /mnt/etc/ssh/ssh_host_ed25519_key.pub
echo " ──  ──  ──  ──  ──   RSA KEYS   ──  ──  ──  ──  ── "
cat  /mnt/etc/ssh/ssh_host_rsa_key.pub
echo " ──  ──  ──  ──  ──  ──  ──  ──  ──  ──  ──  ──  ── "
echo "  This is as far as the installer goes."
echo "  You can reboot into hard drive now."
echo "• ──────────────────────────────────────────────── •"

