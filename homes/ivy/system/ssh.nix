{ config, ... }:

{
  programs.ssh = {
    enable = config.ceirios.profiles.workstation;
    enableDefaultConfig = false;

    includes = [ ];

    settings = {
      ####################
      ## VPS / MACHINES ##
      ####################

      "pinwydd" = {
        user = "anturated";
        hostname = "82.38.2.58";
      };

      "cynnil" = {
        user = "anturated";
        hostname = "178.105.140.238";
      };

      "fawrion" = {
        user = "desant";
        hostname = "185.233.46.184";
      };

      "brethyn" = {
        user = "wizard";
        hostname = "185.233.36.209";
      };

      ############
      ## FORGES ##
      ############

      "github" = {
        user = "git";
        hostname = "github.com";
      };

      "forge" = {
        user = "forgejo";
        hostname = "anturated.dev";
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
