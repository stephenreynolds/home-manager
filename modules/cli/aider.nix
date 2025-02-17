{ config, lib, pkgs, ...}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.cli.aider;
in
{
  options.my.cli.aider = {
    enable = mkEnableOption "Whether to enable aider";
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.aider-chat ];
  };
}
