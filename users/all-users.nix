{
  ceirios.allUsers = {
    desant = {
      hashedPassword = "$y$j9T$gVFMTg9bPiCeQV1QmYCW80$Sow4EyH1UCKBRYra94EY1d2DFWKxE/0ZzADroGJzg/9";

      git = {
        name = "Desant";
        email = "desant" + "@" + "anturated" + "." + "dev";
      };

      ssh.settings = {
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

        "forge" = {
          user = "forgejo";
          hostname = "anturated.dev";
        };
      };
    };

    anturated = {
      hashedPassword = "$y$j9T$9CEup4wvJEEDXsx649flE.$9tpBeVTHGAaH4uo/qN7rE.TjqoD0wFxPdEGFILDKbU2";
      ssh.authorizedKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMOJoauZQLAdUyxVmB+oxNQK+LSQ1Y3/L///GjC+oQlG"
      ];
    };
  };
}
