{ lib, ... }:

let
  inherit (lib) mkOption types;
in
{
  options.my.user = {
    name = mkOption {
      type = types.str;
      default = "stephen";
      description = "The username";
    };
  };
}
