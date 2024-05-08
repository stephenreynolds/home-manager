{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkOption mkIf types optionalString;
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
        editor = optionalString config.programs.neovim.enable "nvim";
        git_protocol = "ssh";
      };
    };
  };
}
