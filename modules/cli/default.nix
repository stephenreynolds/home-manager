{ config, lib, ... }:

let
  inherit (lib) mkOption types;
  cfg = config.my.cli;
in
{
  options.my.cli = {
    extraPackages = mkOption {
      type = types.listOf types.package;
      default = [ ];
      description = "Packages to install in the CLI environment";
    };
  };

  config = {
    home.packages = cfg.extraPackages;
  };
}
