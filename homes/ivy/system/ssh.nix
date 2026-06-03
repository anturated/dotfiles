{
  config,
  osConfig,
  user,
  ...
}:

let
  userSettings = osConfig.ceirios.allUsers.${user}.ssh.settings;
in
{
  programs.ssh = {
    enable = config.ceirios.profiles.workstation;
    enableDefaultConfig = false;

    includes = [ ];

    settings = userSettings // {
      ############
      ## FORGES ##
      ############

      "github" = {
        user = "git";
        hostname = "github.com";
      };

      #########
      ## ??? ##
      #########

      "*" = {
        forwardAgent = false;
        addKeysToAgent = "no";
        compression = true;
        serverAliveInterval = 0;
        serverAliveCountMax = 3;
        hashKnownHosts = true;
        userKnownHostsFile = "~/.ssh/known_hosts";
        controlMaster = "no";
        controlPath = "~/.ssh/master-%r@%n:%p";
        controlPersist = "no";
      };
    };
  };
}
