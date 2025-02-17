{
  description = "My Nix Home Manager config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    haumea = {
      url = "github:nix-community/haumea/v0.2.2";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvim-config = {
      url = "github:stephenreynolds/nvim";
    };
  };

  outputs = { self, nixpkgs, home-manager, haumea, ... }@inputs:
    let
      inherit (self) outputs;
      lib = nixpkgs.lib // home-manager.lib;

      systems = [ "x86_64-linux" ];

      mkPkgs = pkgs: system: extraOverlays:
        import pkgs {
          inherit system;
        };
      pkgsFor = lib.genAttrs systems (sys: mkPkgs nixpkgs sys [ self.overlays.default ]);

      forEachSystem = f: lib.genAttrs systems (sys: f pkgsFor.${sys});

      loadPath = src: haumea.lib.load {
        inherit src;
        loader = haumea.lib.loaders.path;
      };

      packages = loadPath ./pkgs;
      users = loadPath ./home;

      mapModules = path: lib.attrsets.collect builtins.isPath (haumea.lib.load {
        src = path;
        loader = haumea.lib.loaders.path;
      });

      homeManagerModules = mapModules ./modules;
    in
    {
      homeConfigurations = (lib.mapAttrs
        (userHome: home: lib.homeManagerConfiguration {
          modules = [ home.default ] ++ homeManagerModules;
          pkgs = pkgsFor.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
        })
        users);

      packages = forEachSystem (pkgs: lib.mapAttrs (_: v: pkgs.callPackage v { }) packages);

      overlays.default = final: prev: { my = self.packages.x86_64-linux; };

      formatter = forEachSystem (pkgs: pkgs.nixfmt-rfc-style);

      templates = lib.pipe ./templates [
        builtins.readDir
        (builtins.mapAttrs (name: _: {
          description = name;
          path = ./templates/${name};
        }))
      ];

      devShells = forEachSystem (pkgs: { default = import ./shell.nix { inherit pkgs; }; });
    };
}
