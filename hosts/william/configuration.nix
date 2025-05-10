{
  config,
  lib,
  pkgs,
  inputs,
  options,
  ...
}:
let
  username = "william";
  userDescription = "William Tran";
  homeDirectory = "/home/${username}";
  hostName = "william";
  timeZone = "Asia/Ho_Chi_Minh";
in
{
  nixpkgs.overlays = [
    (final: _: {
      # this allows you to access `pkgs.unstable` anywhere in your config
      unstable = import inputs.nixpkgs-unstable {
        inherit (final.stdenv.hostPlatform) system;
        inherit (final) config;
      };
    })
  ];
  imports = [
    ./hardware-configuration.nix
    ./user.nix
    ../../modules/nvidia-drivers.nix
    ../../modules/nvidia-prime-drivers.nix
    ../../modules/intel-drivers.nix
    inputs.home-manager.nixosModules.default
    inputs.xremap-flake.nixosModules.default
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_zen;
    kernelModules = [ "v4l2loopback" ];
    extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
    kernel.sysctl = {
      "vm.max_map_count" = 2147483642;
    };
    kernelParams = [
      "intel_pstate=active"
      "i915.enable_psr=1" # Panel self refresh
      "i915.enable_fbc=1" # Framebuffer compression
      "i915.enable_dc=2" # Display power saving
      "nvme.noacpi=1" # Helps with NVME power consumption
    ];
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        useOSProber = true;
        timeoutStyle = "hidden";
      };
      timeout = 0;
    };
    tmp = {
      useTmpfs = true;
      tmpfsSize = "10G";
    };
    binfmt.registrations.appimage = {
      wrapInterpreterInShell = false;
      interpreter = "${pkgs.appimage-run}/bin/appimage-run";
      recognitionType = "magic";
      offset = 0;
      mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
      magicOrExtension = ''\x7fELF....AI\x02'';
    };
    plymouth.enable = true;
  };

  networking = {
    hostName = hostName;
    networkmanager = {
      enable = true;
      insertNameservers = [
        "1.1.1.1"
        "1.0.0.1"
        "8.8.8.8"
      ];
    };
    timeServers = options.networking.timeServers.default ++ [ "pool.ntp.org" ];
    firewall = {
      allowedTCPPorts = [ 8003 ];
    };
    firewall = {
      checkReversePath = "loose";
    };
  };

  time.timeZone = timeZone;

  i18n = {
    inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5.addons = with pkgs; [
        fcitx5-gtk
        fcitx5-unikey
        fcitx5-hangul
      ];
    };
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };

  stylix = {
    enable = true;
    base16Scheme = {
      base00 = "191724";
      base01 = "1f1d2e";
      base02 = "26233a";
      base03 = "6e6a86";
      base04 = "908caa";
      base05 = "e0def4";
      base06 = "e0def4";
      base07 = "524f67";
      base08 = "eb6f92";
      base09 = "f6c177";
      base0A = "ebbcba";
      base0B = "31748f";
      base0C = "9ccfd8";
      base0D = "c4a7e7";
      base0E = "f6c177";
      base0F = "524f67";
    };
    image = ../../config/assets/wall.png;
    polarity = "dark";
    opacity.terminal = 0.9;
    cursor.package = pkgs.bibata-cursors;
    cursor.name = "Bibata-Modern-Ice";
    cursor.size = 40;
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font Mono";
      };
      sansSerif = {
        package = pkgs.montserrat;
        name = "Montserrat";
      };
      serif = {
        package = pkgs.montserrat;
        name = "Montserrat";
      };
      sizes = {
        applications = 12;
        terminal = 15;
        desktop = 11;
        popups = 12;
      };
    };
  };

  virtualisation = {
    docker = {
      enable = true;
    };
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
        ovmf.enable = true;
        runAsRoot = true;
      };
    };
    spiceUSBRedirection.enable = true;
  };

  programs = {
    nix-ld = {
      enable = true;
      package = pkgs.nix-ld-rs;
    };
    firefox.enable = false;
    dconf.enable = true;
    fuse.userAllowOther = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
      ];
    };
  };

  nixpkgs.config.allowUnfree = true;

  users = {
    mutableUsers = true;
    users.${username} = {
      isNormalUser = true;
      description = userDescription;
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
      packages = with pkgs; [
        firefox
        thunderbird
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    # Zen Browser from custom input
    inputs.zen-browser.packages."${system}".default

    unstable.caprine
    unstable.tofi
    unstable.obs-studio
    unstable.ventoy-full-gtk
    unstable.vimPlugins.neogit
    unstable.luajitPackages.luarocks

    # Programming languages and tools
    unstable.code-cursor
    fd
    jq

    go
    go-blueprint
    go-migrate
    sqlc
    goose
    air
    lua
    python3
    python312Packages.pip
    uv
    clang
    zig
    rustup
    cargo
    nodePackages_latest.pnpm
    nodePackages_latest.yarn
    fnm
    bun
    maven
    mongodb-compass
    gcc
    openssl
    nodePackages_latest.live-server

    # Frappe Bench
    redis
    wkhtmltopdf
    nginx
    uv
    mariadb

    # Version control and development tools
    git
    gh
    lazygit
    lazydocker
    bruno
    postman
    gnumake
    coreutils
    nixfmt-rfc-style
    meson
    ninja

    # Shell and terminal utilities
    stow
    wget
    killall
    eza
    kitty
    neovim
    zoxide
    fzf
    tmux
    progress
    tree
    exfatprogs

    # inputs.nixCats.packages.${pkgs.system}.nvim
    # inputs.ghostty.packages.${pkgs.system}.default

    # File management and archives
    yazi
    p7zip
    unzip
    zip
    unrar
    file-roller
    ncdu
    duf

    # System monitoring and management
    htop
    btop
    # nvtopPackages.nvidia
    anydesk

    # Network and internet tools
    aria2
    qbittorrent
    # cloudflare-warp
    tailscale

    # Audio and video
    pulseaudio
    pavucontrol
    ffmpeg
    mpv
    deadbeef-with-plugins

    # Image and graphics
    imagemagick
    gimp
    hyprpicker
    swww
    hyprlock
    waypaper
    imv

    # Productivity and office
    obsidian
    libreoffice-qt6-fresh

    # Communication and social

    # Browsers
    firefox
    google-chrome

    # Gaming and entertainment
    stremio

    # System utilities
    libgcc
    bc
    kdePackages.dolphin
    lxqt.lxqt-policykit
    libnotify
    v4l-utils
    ydotool
    pciutils
    socat
    cowsay
    ripgrep
    lshw
    bat
    pkg-config
    brightnessctl
    virt-viewer
    swappy
    appimage-run
    yad
    playerctl
    nh
    ansible

    # Wayland specific
    hyprshot
    hypridle
    grim
    slurp
    waybar
    hyprpanel
    dunst
    wl-clipboard
    swaynotificationcenter

    # Virtualization
    libvirt
    qemu
    virt-manager
    spice
    spice-gtk
    spice-protocol
    OVMF

    # File systems
    ntfs3g
    os-prober

    # Downloaders
    yt-dlp
    localsend

    # Clipboard managers
    cliphist

    # Fun and customization
    cmatrix
    lolcat
    fastfetch
    onefetch
    microfetch

    # Networking
    networkmanagerapplet

    # Miscellaneous
    greetd.tuigreet
    customSddmTheme
    libsForQt5.qt5.qtgraphicaleffects
    libsForQt5.qt5.qtmultimedia
    libsForQt5.qt5.qtquickcontrols
    libsForQt5.qt5.qtquickcontrols2
    libsForQt5.qt5.qtwayland
  ];

  # Create a custom .desktop file for imv
  environment.sessionVariables.XCURSOR_PATH = [
    "${config.system.path}/share/icons"
    "$HOME/.local/share/icons"
    "$HOME/.icons"
  ];

  environment.etc."sddm/wayland-sessions/imv.desktop".text = ''
    [Desktop Entry]
    Name=imv
    GenericName=Image Viewer
    Comment=Fast image viewer
    Exec=imv %F
    Terminal=false
    Type=Application
    Categories=Graphics;Viewer;
    MimeType=image/bmp;image/gif;image/jpeg;image/jpg;image/pjpeg;image/png;image/tiff;image/x-bmp;image/x-pcx;image/x-png;image/x-portable-anymap;image/x-portable-bitmap;image/x-portable-graymap;image/x-portable-pixmap;image/x-tga;image/x-xbitmap;image/webp;image/svg+xml;
    Keywords=Image;Viewer;
  '';

  environment.etc."sddm/wayland-sessions/cider.desktop".text = ''
    [Desktop Entry]
    Name=Cider
    GenericName=Music Player
    Comment=Apple Music client
    Exec=/home/william/Downloads/cider-v2.0.3-linux-x64.AppImage %U
    Icon=cider
    Terminal=false
    Type=Application
    Categories=Audio;Music;Player;AudioVideo;
    MimeType=audio/aac;audio/flac;audio/mp4;audio/mpeg;audio/ogg;audio/x-vorbis+ogg;audio/wav;audio/webm;
    Keywords=apple;music;player;
    StartupWMClass=Cider
  '';

  environment.etc."sddm/wayland-sessions/hyprland.desktop".text = ''
    [Desktop Entry]
    Name=Hyprland
    Exec=Hyprland
    Type=Application
  '';

  fonts.packages = with pkgs; [
    noto-fonts-emoji
    fira-sans
    roboto
    noto-fonts-cjk-sans
    nerd-fonts.fira-code
    fira-code
    fira-code-symbols
    font-awesome
    material-icons
  ];

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal
    ];
    configPackages = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal
    ];
  };

  services = {
    xremap = {
      withHypr = true;
      userName = "william";
      config = {
        modmap = [
          {
            name = "global";
            remap = {
              Alt_L = "Super_L";
              Super_L = "Alt_L";
            };
          }
        ];
      };
    };
    logrotate = {
      checkConfig = false;
    };
    xserver = {
      enable = false;
      xkb = {
        layout = "us";
        variant = "";
      };
      videoDrivers = [ "nvidia" ];
    };
    displayManager.sddm = {
      enable = true;
      wayland.enable = true; # Enable Wayland backend
      theme = "rose-pine"; # Your custom theme name
    };
    # greetd = {
    #   enable = true;
    #   vt = 3;
    #   settings = {
    #     default_session = {
    #       user = username;
    #       command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
    #     };
    #   };
    # };
    logind = {
      extraConfig = ''
        HandlePowerKey=suspend
      '';
    };
    # cloudflare-warp.enable = true;
    # supergfxd.enable = true;
    # asusd = {
    #   enable = true;
    #   enableUserService = true;
    # };
    tailscale = {
      enable = true;
      useRoutingFeatures = "client";
    };
    # ollama = {
    #   enable=true;
    #   acceleration = "cuda";
    # };
    cron = {
      enable = true;
    };
    libinput.enable = true;
    upower.enable = true;
    fstrim.enable = true;
    gvfs.enable = true;
    openssh.enable = true;
    flatpak.enable = true;
    printing = {
      enable = false;
    };
    power-profiles-daemon.enable = false;
    thermald.enable = true;
    auto-cpufreq = {
      enable = true;
      settings = {
        battery = {
          governor = "powersave";
          turbo = "never";
        };
        charger = {
          governor = "performance";
          turbo = "auto";
        };
      };
    };
    gnome.gnome-keyring.enable = true;
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    ipp-usb.enable = true;
    syncthing = {
      enable = true;
      user = username;
      dataDir = homeDirectory;
      configDir = "${homeDirectory}/.config/syncthing";
    };
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;
    };
    pulseaudio.enable = false;
  };

  # powerManagement.powertop.enable = true;

  systemd.services = {
    onepassword = {
      script = ''
        1password &
      '';
      # "Enable" the service
      wantedBy = [ "multi-user.target" ];
    };
    cider = {
      script = ''
        ${pkgs.appimage-run}/bin/appimage-run /home/william/Downloads/cider-v2.0.3-linux-x64.AppImage &
      '';
      # "Enable" the service
      wantedBy = [ "multi-user.target" ];
    };
    flatpak-repo = {
      path = [ pkgs.flatpak ];
      script = "flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo";
    };
    libvirtd = {
      enable = true;
      wantedBy = [ "multi-user.target" ];
      requires = [ "virtlogd.service" ];
    };
  };

  hardware = {
    sane = {
      enable = true;
      extraBackends = [ pkgs.sane-airscan ];
      disabledDefaultBackends = [ "escl" ];
    };
    logitech.wireless = {
      enable = true;
      enableGraphical = true;
    };
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    graphics.enable = true;
  };

  services.blueman.enable = true;

  security = {
    sudo = {
      wheelNeedsPassword = false;
    };
    rtkit.enable = true;
    polkit = {
      enable = true;
      extraConfig = ''
        polkit.addRule(function(action, subject) {
          if (
            subject.isInGroup("users")
              && (
                action.id == "org.freedesktop.login1.reboot" ||
                action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
                action.id == "org.freedesktop.login1.power-off" ||
                action.id == "org.freedesktop.login1.power-off-multiple-sessions"
              )
            )
          {
            return polkit.Result.YES;
          }
        })
      '';
    };
    pam.services.swaylock.text = "auth include login";
  };

  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  programs.hyprland.enable = true;
  programs.hyprland.withUWSM = true;
  programs._1password = {
    enable = true;
    package = pkgs.unstable._1password-cli;
  };
  programs._1password-gui = {
    enable = true;
    package = pkgs.unstable._1password-gui;
    polkitPolicyOwners = [ "william" ];
  };

  xdg.mime.defaultApplications = {
    # Web and HTML
    "x-scheme-handler/http" = "zen.desktop";
    "x-scheme-handler/https" = "zen.desktop";
    "x-scheme-handler/chrome" = "zen.desktop";
    "text/html" = "zen.desktop";
    "application/x-extension-htm" = "zen.desktop";
    "application/x-extension-html" = "zen.desktop";
    "application/x-extension-shtml" = "zen.desktop";
    "application/x-extension-xhtml" = "zen.desktop";
    "application/xhtml+xml" = "zen.desktop";

    # File management
    "inode/directory" = "org.kde.dolphin.desktop";

    # Text editor
    "text/plain" = "nvim.desktop";

    # Terminal
    "x-scheme-handler/terminal" = "kitty.desktop";

    # Images
    "image/png" = "imv.desktop";
    "image/jpeg" = "imv.desktop";
    "image/jpg" = "imv.desktop";
    "image/gif" = "imv.desktop";
    "image/webp" = "imv.desktop";
    "image/svg+xml" = "imv.desktop";
    "image/bmp" = "imv.desktop";
    "image/tiff" = "imv.desktop";
    "image/x-tga" = "imv.desktop";

    # Videos
    "video/quicktime" = "mpv-2.desktop";
    "video/x-matroska" = "mpv-2.desktop";

    # LibreOffice formats
    "application/vnd.oasis.opendocument.text" = "libreoffice-writer.desktop";
    "application/vnd.oasis.opendocument.spreadsheet" = "libreoffice-calc.desktop";
    "application/vnd.oasis.opendocument.presentation" = "libreoffice-impress.desktop";
    "application/vnd.ms-excel" = "libreoffice-calc.desktop";
    "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" = "libreoffice-calc.desktop";
    "application/msword" = "libreoffice-writer.desktop";
    "application/vnd.openxmlformats-officedocument.wordprocessingml.document" =
      "libreoffice-writer.desktop";
    "application/vnd.ms-powerpoint" = "libreoffice-impress.desktop";
    "application/vnd.openxmlformats-officedocument.presentationml.presentation" =
      "libreoffice-impress.desktop";

    # PDF
    "application/pdf" = "zen.desktop";

    # Torrents
    "application/x-bittorrent" = "org.qbittorrent.qBittorrent.desktop";
    "x-scheme-handler/magnet" = "org.qbittorrent.qBittorrent.desktop";

    # Other handlers
    "x-scheme-handler/about" = "zen.desktop";
    "x-scheme-handler/unknown" = "zen.desktop";
    "x-scheme-handler/postman" = "Postman.desktop";
    "x-scheme-handler/tonsite" = "org.telegram.desktop.desktop";
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users.${username} = import ./home.nix;
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
  };

  system.stateVersion = "24.11";
}
