{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf optionalString;
  cfg = config.my.cli.gh;
in
{
  options.my.cli.gh = {
    enable = mkEnableOption "Enable GitHub CLI";
  };

  config = mkIf cfg.enable {
    programs.gh = {
      enable = false;
      settings = {
        editor = optionalString config.programs.neovim.enable "nvim";
        git_protocol = "ssh";
      };
    };
  };
}
