{
  lib,
  pkgs,
  config,
  ...
}:

let
  inherit (lib.attrsets)
    attrValues
    attrNames
    mapAttrs
    ;

  logo = ./custom/icon.svg;
  favicon = ./custom/favicon_sm.svg;
  home = ./custom/home.tmpl;

  themes = {
    evergarden-fall-lime = pkgs.fetchurl {
      url = "https://evergarden.moe/gitea/theme-evergarden-fall-lime.css";
      hash = "sha256-xdcNuG/3DTlquUfQ8Otx4x3XWNGkDWK9zheG89B3dgg=";
    };

    evergarden-fall-cherry = pkgs.fetchurl {
      url = "https://evergarden.moe/gitea/theme-evergarden-fall-cherry.css";
      hash = "sha256-9uSOQKkpgVDcb4zMdYCL+WU2Lvg7NVQ7fCW718WUiD4=";
    };

    evergarden-fall-skye = pkgs.fetchurl {
      url = "https://evergarden.moe/gitea/theme-evergarden-fall-skye.css";
      hash = "sha256-58GPpaIT/En3FziL/un5foZPMT1BUt1oFM2PHSfOcMQ=";
    };

    gefail = ./custom/theme.css;
  };
in
{
  services.forgejo.settings.ui = {
    DEFAULT_THEME = "gefail";

    THEMES = lib.concatStringsSep "," (
      lib.flatten [
        (attrNames themes)
        [
          "forgejo-auto"
          "forgejo-light"
          "forgejo-dark"
        ]
      ]
    );
  };

  systemd.services.forgejo-themes = {
    description = "Install Forgejo custom themes";
    wantedBy = [ "forgejo.service" ];
    before = [ "forgejo.service" ];
    serviceConfig = {
      Type = "oneshot";
      User = "forgejo";
      Group = "forgejo";
    };
    script =
      lib.concatStringsSep "" (
        # this SHOULD download the theme where it needs to be
        attrValues (
          mapAttrs (name: file: ''
            install -Dm644 ${file} \
            ${config.services.forgejo.stateDir}/custom/public/assets/css/theme-${name}.css
          '') themes
        )
      )
      # navbar reads icon.svg and we feed homepage the "hero.svg" that is the full icon
      + ''
        install -Dm644 ${favicon} \
          ${config.services.forgejo.stateDir}/custom/public/assets/img/logo.svg
        install -Dm644 ${favicon} \
          ${config.services.forgejo.stateDir}/custom/public/assets/img/favicon.svg
        install -Dm644 ${logo} \
          ${config.services.forgejo.stateDir}/custom/public/assets/img/hero.svg
        install -Dm644 ${home} \
          ${config.services.forgejo.stateDir}/custom/templates/home.tmpl
      '';
  };
}
