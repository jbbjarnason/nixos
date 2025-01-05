{
  description = "My flake dependencies";
  inputs.zerotier-desktop-ui.url = "github:jbbjarnason/DesktopUI/add-nix";

  outputs = { zerotier-desktop-ui, ... }: {
    packages.x86_64-linux = {
      inherit (zerotier-desktop-ui.packages.x86_64-linux) zerotier-desktop-ui;
    };
  };
}
