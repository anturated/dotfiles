[
  {
    name = "anturated.dev";
    group = "Websites";
    url = "https://anturated.dev";
  }

  {
    name = "Gefail";
    group = "Dev";
    url = "https://git.anturated.dev";
  }
  {
    name = "CI";
    group = "Dev";
    url = "https://ci.anturated.dev";
  }

  {
    name = "Jellyfin";
    group = "Services";
    url = "https://fin.anturated.dev";
  }
  {
    name = "PDS";
    group = "Services";
    url = "https://pds.anturated.dev";
  }
  {
    name = "Matrix";
    group = "Services";
    url = "https://matrix.anturated.dev/_matrix/client/versions";
  }
  {
    name = "Matrix UI";
    group = "Services";
    url = "https://chat.anturated.dev";
  }
  {
    name = "AdGuard";
    group = "Services";
    url = "tcp://dns.anturated.dev:853";
    defaultConditions = false;
    conditions = [ "[CONNECTED] == true" ];
  }
  {
    name = "AdGuard UI";
    group = "Services";
    url = "https://dns.anturated.dev";
  }

  {
    name = "Webmail";
    group = "Email";
    url = "https://rc.anturated.dev";
  }
  {
    name = "imap";
    group = "Email";
    url = "tcp://mail.anturated.dev:993";
    defaultConditions = false;
    conditions = [ "[CONNECTED] == true" ];
  }
  {
    name = "smtp";
    group = "Email";
    url = "tls://mail.anturated.dev:465";
    defaultConditions = false;
    conditions = [
      "[CONNECTED] == true"
      "[CERTIFICATE_EXPIRATION] > 48h"
    ];
  }
]
