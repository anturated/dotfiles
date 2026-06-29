{ ... }:

{
  services = {
    tlp = {
      # TODO: make conditional
      enable = false;

      # ppd bridge
      pd.enable = true;

      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "schedutil";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        PLATFORM_PROFILE_ON_AC = "balanced";
        PLATFORM_PROFILE_ON_BAT = "low-power";

        CPU_BOOST_ON_AC = 0;
        CPU_BOOST_ON_BAT = 0;
      };
    };
  };
}
