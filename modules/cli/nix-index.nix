{ config, lib, inputs, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.cli.nix-index;
in
{

  imports = [ inputs.nix-index-database.hmModules.nix-index ];
  options.my.cli.nix-index = {
    enable = mkEnableOption "Enable nix-index";
    comma = {
      enable = mkEnableOption "Install comma";
    };
  };

  config = mkIf cfg.enable {

    programs = {
      nix-index.enable = true;
      nix-index-database.comma.enable = cfg.comma.enable;
    };
  };
}
