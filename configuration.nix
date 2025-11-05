# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, pkgsUnstable ? null, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "jonb-work-laptop"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
  networking.networkmanager.wifi.backend = "iwd";
  networking.networkmanager.wifi.powersave = false; # Prevent wifi being disconnected every now and then
  networking.extraHosts =
  ''
    #192.168.8.187 tempservo.local
    #10.11.12.229 tempservo.local
    10.11.13.4 tempservo.local
  '';
  # Provide all firmware (including iwlwifi firmware)
  hardware.enableAllFirmware = true;

  # Set your time zone.
  time.timeZone = "Atlantic/Reykjavik";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;


  nixpkgs.config.allowUnfree = true;

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # hardware.pulseaudio.enable = true;
  # OR
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };
  services.blueman.enable = true;
  hardware.bluetooth.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;
  services.teamviewer.enable = true;
  virtualisation.docker.enable = true;
  #virtualisation.virtualbox.host.enable = true;
  #virtualisation.virtualbox.host.enableExtensionPack = true;
  users.extraGroups.vboxusers.members = [ "jonb" ];
  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = ["jonb"];
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  services.hardware.bolt.enable = true;

  boot.kernelParams = [ "kvm.enable_virt_at_load=0" ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jonb = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" "dialout" "wireshark" ]; # Enable ‘sudo’ for the user.
    shell = "${pkgs.fish}/bin/fish";
    packages = with pkgs; [
      tree
      sway
      swaylock
      mako
      waybar
      grim
      slurp
      wf-recorder
      wl-clipboard
      networkmanagerapplet
      blueman
      wofi
      wdisplays
      # kdeconnect
      polkit_gnome
      alacritty
      remmina
      bambu-studio
      bitwarden
      discord
      google-chrome
      # thunar
      # tigervnc
      wireshark
      zed
      lapce
      signal-desktop
      spotify
      kicad
      jetbrains.clion
      jetbrains-toolbox
      d-spy
      iperf3
      signal-desktop
      vlc
      python3
      freerdp3
      libreoffice-qt
      hunspell
      hunspellDicts.en_US
      jetbrains.pycharm-community-bin
      teamviewer
      openfortivpn
      realvnc-vnc-viewer
      vscode
      zenity
    ] ++ lib.optionals (pkgsUnstable != null) [
      pkgsUnstable.code-cursor
    ];
  };

  programs.firefox.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    cmake
    gcc
    ninja
    automake
    autoconf
    autoconf-archive
    libtool
    autogen
    pkg-config
    gnumake
    htop
    rustup
    musl
    clang
    mold
    graphviz
    rustfmt
    pavucontrol
    git
    killall
    vcpkg
    ltunify
    direnv
    unzip
    socat
    lsof
    usbutils
    android-tools
    gnome-terminal
    ntfs3g
    nodejs
    jq
    yarn
    inkscape
    lld
    jdk
    qemu
    parted
    debootstrap
    ethtool
    tcpdump
    lldb
    eww
  ];

  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      font-awesome
      source-han-sans
      source-han-sans-japanese
      source-han-serif-japanese
    ];
    fontconfig.defaultFonts = {
      serif = [ "Noto Serif" "Source Han Serif" ];
      sansSerif = [ "Noto Sans" "Source Han Sans" ];
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 5900 1040 5201 ];
  networking.firewall.allowedUDPPorts = [ 9993 51820 ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  #networking.wireguard.enable = true;
  #networking.wireguard.interfaces = {
  #  vorduberg20 = {
  #    ips = [ "10.11.13.5/24" ];
  #    listenPort = 51820;
  #    privateKeyFile = "/wg-keys/private";
  #    peers = [
  #      {
  #        publicKey = "Q8J60aRDV0aC6i5KBQU08x660GxvT225jUYhJyK5GWY=";
  #        allowedIPs = [ "0.0.0.0/0" ];
  #        endpoint = "153.92.133.244:51820";
  #        persistentKeepalive = 25;
  #      }
  #    ];
  #  };
  #};

  services.zerotierone = {
    enable = true;
    #localConf = {
    #  settings = {
    #    primaryPort = 9993;
    #    portMappingEnabled = true;
    #    allowTcpFallbackRelay = true;
    #    #forceTcpRelay = true;
    #    tcpFallbackRelay = "213.181.115.232/443";
    #  };
    #};
  };
  networking.firewall.trustedInterfaces = [ "ztm5tynveb" ];
  services.tailscale.enable = false;
  services.gnome.gnome-keyring.enable = true;
  security.polkit.enable = true;

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };
  programs.wireshark = {
    enable = true;
    # dumpcap = true;
    # usbmon.enable = true;
  };

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
  };


  # TFC based config
  systemd.tmpfiles.rules = [
    "d /var/run/tfc 0755 jonb users -"
  ];

  services.dbus.packages = [
    (pkgs.writeTextFile {
      name = "dbus-centroid-conf";
      destination = "/share/dbus-1/system.d/is.centroid.conf";
      text = ''
        <!DOCTYPE busconfig PUBLIC
        "-//freedesktop//DTD D-Bus Bus Configuration 1.0//EN"
        "http://www.freedesktop.org/standards/dbus/1.0/busconfig.dtd">
        <busconfig>
        <policy context="default">
          <allow own_prefix="is.centroid"/>
          <allow send_destination_prefix="is.centroid"/>
        </policy>
        </busconfig>
      '';
    })
  ];

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?

}

