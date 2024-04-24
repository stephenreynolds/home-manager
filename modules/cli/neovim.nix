{ config, lib, inputs, ... }:

let
  inherit (lib) mkEnableOption mkOption mkIf types;
  cfg = config.my.cli.neovim;
in
{
  imports = [ inputs.nvim-config.homeManagerModules.default ];

  options.my.cli.neovim = {
    enable = mkEnableOption "Enable Neovim";
    defaultEditor = mkEnableOption "Set Neovim as the default editor";
    viAlias = mkOption {
      type = types.bool;
      default = true;
      description = "Create vi alias";
    };
    vimAlias = mkOption {
      type = types.bool;
      default = true;
      description = "Create vim alias";
    };
    vimdiffAlias = mkOption {
      type = types.bool;
      default = true;
      description = "Create vimdiff alias";
    };
  };

  config = mkIf cfg.enable {
    programs.neovim = {
      enable = true;
      inherit (cfg) defaultEditor viAlias vimAlias vimdiffAlias;
    };
  };
}
