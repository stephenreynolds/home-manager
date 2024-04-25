{ config, lib, ... }:

let
  inherit (lib) mkOption mkIf types;
  cfg = config.my.cli.bash;
in
{
  options.my.cli.bash = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable bash";
    };
  };

  config = mkIf cfg.enable {
    programs.bash.enable = true;

    home.sessionVariables.HISTFILE =
      "${config.xdg.stateHome}/bash/history";
  };
}
