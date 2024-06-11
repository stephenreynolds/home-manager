{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.services.keyring;
in
{
  options.my.services.keyring = {
    enable = mkEnableOption "Enable gnome-keyring service";
  };

  config = mkIf cfg.enable {
    services.gnome-keyring = {
      enable = true;
      components = [ "pkcs11" "secrets" "ssh" ];
    };

    services.ssh-agent = {
      enable = true;
    };
  };
}
