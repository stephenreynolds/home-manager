{ config, lib, pkgs, inputs, outputs, ... }:

let
  inherit (lib) mkOption types;
  cfg = config.my.nix;
in
{
  options.my.nix = {
    auto-optimise-store = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to automatically optimise the Nix store";
    };
    use-cgroups = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to execute builds inside cgroups";
    };
    gc = {
      automatic = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description =
          "Automatically run the garbage collector at a specific time";
      };
      frequency = lib.mkOption {
        type = lib.types.str;
        default = "weekly";
        description = "How often or when garbage collection is performed";
      };
      options = lib.mkOption {
        type = lib.types.str;
        default = "--delete-older-than 30d";
        description = "Options to pass to the garbage collector";
      };
    };
  };

  config = {
    nix = {
      package = pkgs.nix;
      settings = {
        trusted-users = [ "root" "@wheel" ];
        trusted-substituters = [ "https://cache.nixos.org" ];
        trusted-public-keys = [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" ];
        experimental-features = [
          "auto-allocate-uids"
          "ca-derivations"
          "cgroups"
          "flakes"
          "nix-command"
        ];
        warn-dirty = false;
        inherit (cfg) auto-optimise-store use-cgroups;
      };

      gc = { inherit (cfg.gc) automatic frequency options; };

      # Add each flake input as a registry
      # To make nix3 commands consistent with the flake
      registry = lib.mapAttrs (_: value: { flake = value; }) inputs;
    };

    nixpkgs = {
      overlays = builtins.attrValues outputs.overlays;
      config = {
        allowUnfree = true;
      };
    };
  };
}
