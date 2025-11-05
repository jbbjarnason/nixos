{
  description = "My flake dependencies";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    zerotier-desktop-ui.url = "github:jbbjarnason/DesktopUI/add-nix";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, zerotier-desktop-ui }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
    pkgsUnstable = import nixpkgs-unstable { inherit system; config.allowUnfree = true; };
  in {
    nixosConfigurations."jonb-work-laptop" = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit pkgsUnstable; };  # <- make pkgsUnstable available to modules
      modules = [
        ./configuration.nix
        ({ pkgsUnstable, ... }: {
          # Add code-cursor from unstable (keep the rest on stable)
          users.users.jonb.packages = [
            pkgsUnstable.code-cursor
          ];
        })
        {
          environment.systemPackages = [
            zerotier-desktop-ui.packages.${system}.desktopui
          ];
        }
      ];
    };
  };
}

