{ config, ... }:

{
  users = {
    # only define users in the config
    mutableUsers = false;

    # root inherits the password of whatever the main user is
    users.root = {
      inherit (config.users.users.${config.ceirios.system.mainUser}) hashedPassword;
    };
  };
}
