{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkOption mkIf types;
  cfg = config.my.cli.bat;
in
{
  options.my.cli.bat = {
    enable = mkEnableOption "Whether to enable bat";
    theme = mkOption {
      type = types.str;
      default = "base16";
      description = "The theme to use";
    };
  };

  config = mkIf cfg.enable {
    programs.bat = {
      enable = true;
      config.theme = cfg.theme;
    };
  };
}
