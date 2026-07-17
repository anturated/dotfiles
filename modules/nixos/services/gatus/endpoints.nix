{
  websites = {
    "anturated.dev".url = "https://anturated.dev";
  };

  dev = {
    gefail.url = "https://git.anturated.dev";
    ci.url = "https://ci.anturated.dev";
  };

  services = {
    jellyfin.url = "https://fin.anturated.dev";

    pds.url = "https://pds.anturated.dev";

    matrix.url = "https://matrix.anturated.dev/_matrix/client/versions";
    matrix-ui.url = "https://chat.anturated.dev";

    adguard-ui.url = "https://dns.anturated.dev";
    adguard = {
      url = "tcp://dns.anturated.dev:853";
      defaultConditions = false;
      conditions = [ "[CONNECTED] == true" ];
    };
  };

  mailserver = {
    webui.url = "https://rc.anturated.dev";

    imap = {
      url = "tcp://mail.anturated.dev:993";
      defaultConditions = false;
      conditions = [ "[CONNECTED] == true" ];
    };

    smtp = {
      url = "tls://mail.anturated.dev:465";
      defaultConditions = false;
      conditions = [
        "[CONNECTED] == true"
        "[CERTIFICATE_EXPIRATION] > 48h"
      ];
    };
  };
}
