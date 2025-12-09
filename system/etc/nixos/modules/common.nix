# Common configuration shared across all hosts
{
  config,
  pkgs,
  modulesPath,
  lib,
  ...
}:

{
  imports = [
    # QEMU guest optimizations for VMs
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  # Enable QEMU Guest services for better VM performance
  services.qemuGuest.enable = true;

  # Bootloader configuration
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Automatically resize the root filesystem
  fileSystems."/".autoResize = true;

  # Networking defaults
  networking.networkmanager.enable = true;
  networking.firewall.enable = false;

  # Time and localization
  time.timeZone = "America/Los_Angeles";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };

  # X11 keymap
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # User configuration
  users.groups.armaan = {
    gid = 1000;
  };

  users.users.armaan = {
    isNormalUser = true;
    description = "Armaan Lala";
    extraGroups = [
      "networkmanager"
      "wheel"
      "armaan"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAxWbEebtUXP/g3+lSqQxRV8j3HbDZPEfvksbBognPtz armaan@nyx 2025-12-2"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPS2foqCO+tCzjg/CYsuaTX5SsjZyEpquDjbH4WXkLwR armaan@thinkpad 2025-12-03"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGWCoSW1PMIeftP7bqfZntLdRvhGBhpvzaLFZrXTvTrp armaanlala@apple-j616c 2025-12-03"
    ];
    packages = with pkgs; [
      # Development tools
      ripgrep
      fd
      git
      lazygit
      neovim
      gcc
      nil
      nixfmt-rfc-style
      tealdeer

      # System utilities
      duf
      gdu
      htop
      wget
      parallel
      bat # Better cat (for alias)
      eza # Better ls (for aliases)

      # Media and file tools
      mediainfo
      zip
      unzip
      rmlint
      tokei

      # Terminal experience
      fish
      tmux
      stylua
      fastfetch
      starship # Shell prompt
    ];
  };

  # Shell configuration - default to fish
  programs.bash = {
    interactiveShellInit = ''
      if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
      then
        shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
      fi
    '';
  };

  # Fish shell configuration with aliases
  programs.fish = {
    enable = true;
    shellAliases = {
      v = "nvim";
      cat = "bat";
      mv = "mv -i";
      rm = "rm -Iv";
      df = "df -h";
      du = "du -h -d 1";
      k = "killall";
      p = "ps aux | grep $1";
      l = "eza --color=auto --icons -h";
      ll = "eza --color=auto --icons -lh";
      ls = "eza --color=auto --icons -h";
      la = "eza --color=auto --icons -lah";
    };
  };

  # Nix configuration
  nix.settings = {
    trusted-users = [
      "root"
      "@wheel"
    ];
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };
  nixpkgs.config.allowUnfree = true;

  # Editor
  environment.variables.EDITOR = "nvim";

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/etc/nixos";
  };

  # Essential system packages
  environment.systemPackages = with pkgs; [
    vim # for emergencies when nvim isn't available
    python3 # for ansible and automation

    # Security and monitoring tools
    nmap # network scanning
    lsof # list open files
    strace # system call tracing

    nh
  ];

  # Enable mDNS for hostname.local addresses
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      addresses = true;
    };
  };

  # Security configuration
  security.sudo.wheelNeedsPassword = false; # Convenient for VMs

  # SSH configuration - secure and convenient
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      KbdInteractiveAuthentication = true;
    };
  };

  # System version - Do not change after initial deployment
  system.stateVersion = "25.05";
}
