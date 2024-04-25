{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.cli.nushell;
in
{
  options.my.cli.nushell = {
    enable = mkEnableOption "Whether to enable Nushell";
  };

  config = mkIf cfg.enable {
    programs.nushell = {
      enable = true;
    };
  };
}
