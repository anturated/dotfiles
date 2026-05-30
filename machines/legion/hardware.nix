{ ... }:

{

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/a759a98c-12ae-432c-b7ab-670e8caf1704";
    fsType = "ext4";
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/1dce67d0-6a6c-4b90-8208-2c5e2cbd8595";
    fsType = "ext4";
  };

  fileSystems."/run/media/desant/debil" = {
    device = "/dev/disk/by-uuid/ed18b60f-830b-4884-aaa2-6ad3d52d4634";
    fsType = "ext4";
    options = [
      "nofail"
      "x-gvfs-show"
    ];
  };

  fileSystems."/run/media/desant/borderlands3" = {
    device = "/dev/disk/by-uuid/bf2e0f82-4fc6-4940-993f-0d4db339c4ff";
    fsType = "ext4";
    options = [
      "nofail"
      "x-gvfs-show"
    ];
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/c924a917-cab8-4f03-b956-ea0eee0ebc80"; }
  ];

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/ECB0-41F7";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };
}
