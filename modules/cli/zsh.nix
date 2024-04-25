{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.cli.zsh;
in
{
  options.my.cli.zsh = {
    enable = mkEnableOption "Whether to enable zsh";
  };

  config = mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      enableVteIntegration = true;
      autocd = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
    };
  };
}
