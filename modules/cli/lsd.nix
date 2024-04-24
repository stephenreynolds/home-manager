{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf mkMerge;
  cfg = config.my.cli.lsd;
in
{
  options.my.cli.lsd = {
    enable = mkEnableOption "Enable lsd, an ls alternative";
  };

  config = mkIf cfg.enable (mkMerge [
    {
      programs.lsd = {
        enable = true;
        settings = { date = "relative"; };
      };
    }

    (mkIf config.my.cli.fish.enable {
      programs.fish.shellAbbrs = {
        ls = "lsd";
        lsa = "lsd -A";
        lsl = "lsd -l";
        lsla = "lsd -lA";
        lst = "lsd --tree";
        lslt = "lsd -l --tree";
        tree = "lsd --tree";
      };
    })
  ]);
}
