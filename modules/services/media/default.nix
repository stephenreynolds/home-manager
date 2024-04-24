{ lib, ... }:

let
  inherit (lib) mkEnableOption;
in
{
  options.my.services.media = {
    enable = mkEnableOption "Whether to enable media services";
  };
}
