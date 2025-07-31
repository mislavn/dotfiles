# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use latest kernel
  # boot.kernelPackages = pkgs.linuxPackages_latest;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.trusted-users = [ "root" "mislav" ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Helsinki";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fi_FI.UTF-8";
    LC_IDENTIFICATION = "fi_FI.UTF-8";
    LC_MEASUREMENT = "fi_FI.UTF-8";
    LC_MONETARY = "fi_FI.UTF-8";
    LC_NAME = "fi_FI.UTF-8";
    LC_NUMERIC = "fi_FI.UTF-8";
    LC_PAPER = "fi_FI.UTF-8";
    LC_TELEPHONE = "fi_FI.UTF-8";
    LC_TIME = "fi_FI.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "dvorak";
  };

  # Configure console keymap
  console.keyMap = "dvorak";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Flatpack
  services.flatpak.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mislav = {
    isNormalUser = true;
    description = "mislav";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    #  thunderbird
    ];
    shell = pkgs.zsh;
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  programs.nix-ld.enable = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Enable common container config files in /etc/containers
  virtualisation.containers.enable = true;
  virtualisation = {
    podman = {
      enable = true;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
     zathura
     vlc
     busybox
     pciutils
     dconf-editor
     signal-desktop
     nix-ld
     gnome-network-displays

     qutebrowser
     vivaldi

     # containers
     dive # look into docker image layers
     podman-tui # status of containers in the terminal
     podman-compose # start group of containers for dev

     # terminal
     rio
     neovim
     git
     tmux
     zellij

     helix
     starship
     jujutsu
     delta
     just
     devenv

     zsh
     bash
     nushell

     htop
     fzf

     # Rust replacements
     ripgrep
     bat
     eza
     fd
     dust
     skim
     zoxide
     procs

     # Programming
     rustup
     uv
     ruff
     python313Packages.python-lsp-server
     python313Packages.jedi-language-server
     zig
     zls
     typescript-language-server
     yaml-language-server
     nil
     vscode-langservers-extracted
     cmake-language-server
     bash-language-server
     tailwindcss-language-server
     go
     gopls
     libclang
     lldb
     clang
     gcc
     uiua-unstable
     deno
     bun
     nodejs
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall for gnome-network-displays
  networking.firewall.trustedInterfaces = [ "p2p-wl+" ]; # Or the name of your interface
  networking.firewall.interfaces."p2p-wl+".allowedTCPPorts = [7236 7250 7251];
  networking.firewall.interfaces."p2p-wl+".allowedUDPPorts = [5004 5005 7236 5353];
  networking.firewall.interfaces."p2p-wl+".allowedUDPPortRanges = [ { from = 32768; to = 60999; } ];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?


  # Suspend workaround
  # Disable network interface and remove kernel modules before suspend
  
  # cat /etc/systemd/scripts/sleep/before.sh
  # systemctl stop NetworkManager
  # /run/current-system/sw/bin/rmmod iwlmvm
  # /run/current-system/sw/bin/rmmod iwlwifi
  systemd.services."hack-stop-network-before-suspend" = {
    description = "Stop network and disable iwlwifi before suspend";
    wantedBy = [ "sleep.target" ];
    before = [ "sleep.target" "network.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash /etc/systemd/scripts/sleep/before.sh";
    };
  };

  # cat /etc/systemd/scripts/sleep/after.sh
  # /run/current-system/sw/bin/modprobe iwlmvm
  # /run/current-system/sw/bin/modprobe iwlwifi
  # systemctl start NetworkManager
  systemd.services."hack-start-network-after-suspend" = {
    description = "Start network and enable iwlwifi after suspend";
    after = [ "suspend.target" "hibernate.target" "hybrid-sleep.target" "suspend-then-hibernate.target" ];
    wantedBy = [ "suspend.target" "hibernate.target" "hybrid-sleep.target" "suspend-then-hibernate.target" ];
    before = [ "network.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash /etc/systemd/scripts/sleep/after.sh";
    };
  };

  # zsh
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ls = "eza";
    };

    histSize = 100000;
    histFile = "$HOME/.zsh_history";

    ohMyZsh = {
      enable = true;
      plugins = [
        "git"
        "sudo"
        "fzf"
      ];
      theme = "robbyrussell";
    };
  };

  programs.starship = {
    enable = true;
    # Configuration written to ~/.config/starship.toml
  };

}
