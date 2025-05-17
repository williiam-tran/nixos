{
  description = "main flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    stylix.url = "github:danth/stylix";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixCats = {
      url = "path:/home/william/nixconfig/modules/nixCats";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    hyprpanel.url = "github:Jas-SinghFSU/HyprPanel";
    xremap-flake.url = "github:xremap/nix-flake";
    dolphin-overlay.url = "github:rumboon/dolphin-overlay";
    lightly.url = "github:Bali10050/Darkly";
    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    };
    split-monitor-workspaces = {
      url = "github:Duckonaut/split-monitor-workspaces";
    };
    hyprswitch.url = "github:h3rmt/hyprswitch/release";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixCats,
      hyprpanel,
      dolphin-overlay,
      split-monitor-workspaces,
      ...
    }@inputs:
    let
      system = "x86_64-linux";

      # Define the custom SDDM theme as an overlay
      customSddmThemeOverlay = final: prev: {
        customSddmTheme = prev.stdenv.mkDerivation {
          name = "rose-pine";
          src = ./modules/sddm-theme;
          installPhase = ''
            mkdir -p $out/share/sddm/themes/rose-pine
            cp -r $src/* $out/share/sddm/themes/rose-pine
          '';
        };
      };

      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations.william = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          (
            {
              config,
              pkgs,
              ...
            }:
            {
              nixpkgs.config.allowUnfree = true;

              # Add the custom theme overlay
              nixpkgs.overlays = [
                customSddmThemeOverlay
                hyprpanel.overlay
                dolphin-overlay.overlays.default
              ];
            }
          )
          ./hosts/william/configuration.nix
          inputs.stylix.nixosModules.stylix
          inputs.home-manager.nixosModules.default
        ];
      };
    };
}
