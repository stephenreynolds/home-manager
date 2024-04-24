{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.cli.lazygit;
in
{
  options.my.cli.lazygit = {
    enable = mkEnableOption "Enable LazyGit";
  };

  config = mkIf cfg.enable {
    programs.lazygit = {
      enable = true;
      settings = {
        gui = {
          showRandomTip = false;
          nerdFontsVersion = "3";
        };
        git.overrideGpg = true;
      };
    };
  };
}
