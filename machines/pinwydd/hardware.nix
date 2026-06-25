{
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/79def9ae-0c37-4d42-9f53-430fb23c4eae";
    fsType = "btrfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/9140-B564";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/23a6d9cd-8c3f-4ec4-9c99-e3f43d8dff1a"; }
  ];
}
