{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkOption mkIf mkMerge types optionalString;
  cfg = config.my.cli.direnv;
in
{
  options.my.cli.direnv = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable direnv";
    };
    log = {
      enable = mkEnableOption "Whether to enable logging";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
    }

    (mkIf (!cfg.log.enable) {
      programs.fish.interactiveShellInit =
        optionalString config.my.cli.fish.enable
          "set -x DIRENV_LOG_FORMAT ''";
    })
  ]);
}
