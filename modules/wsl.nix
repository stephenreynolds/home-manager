{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.wsl;
in
{
  options.my.wsl = {
    enable = mkEnableOption "Whether to configure for WSL";
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.wslu ];

    home.sessionVariables.BROWSER = "${pkgs.wslu}/bin/wslview";

    programs.git.extraConfig = {
      credential.helper = "/mnt/c/Program\\ Files/Git/mingw64/bin/git-credential-manager.exe";
    };
  };
}
