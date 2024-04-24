{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.cli.zoxide;
in
{
  options.my.cli.zoxide = {
    enable = mkEnableOption "Enable zoxide";
  };

  config = mkIf cfg.enable {
    programs.zoxide = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = config.my.cli.fish.enable;
      enableZshIntegration = config.my.cli.zsh.enable;
    };
  };
}
