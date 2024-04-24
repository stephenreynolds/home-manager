{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkOption mkIf mkMerge types;
  cfg = config.my.cli.fzf;
in
{
  options.my.cli.fzf = {
    enable = mkEnableOption "Enable fzf";
    colors = mkOption {
      type = types.nullOr types.attrs;
      default = { };
      description = "Color scheme to use";
    };
    silver-searcher = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to use silver-searcher.";
    };
    shellIntegrations = mkOption {
      type = types.bool;
      default = true;
      description = "Enable shell integrations";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      programs.fzf = {
        enable = true;
        defaultOptions = [ "--color 16" ];
      };
    }

    (mkIf cfg.silver-searcher {
      programs.fzf =
        let ag = "${pkgs.silver-searcher}/bin/ag";
        in {
          defaultCommand = "${ag} -g ''";
          fileWidgetCommand = "${ag} --hidden";
        };
    })

    (mkIf cfg.shellIntegrations {
      programs.fzf = {
        enableBashIntegration = true;
        enableFishIntegration = config.programs.fish.enable;
        tmux.enableShellIntegration = config.programs.tmux.enable;
      };
    })
  ]);
}
