{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkOption mkIf types;
  cfg = config.my.cli.gh;
in
{
  options.my.cli.gh = {
    enable = mkEnableOption "Enable GitHub CLI";
    extensions = {
      markdown-preview = mkOption {
        type = types.bool;
        default = true;
        description = "Enable markdown previewer";
      };
    };
  };

  config = mkIf cfg.enable {
    programs.gh = {
      enable = true;
      settings = {
        git_protocol = "ssh";
      };
    };
  };
}
