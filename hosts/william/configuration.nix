{
  config,
  pkgs,
  inputs,
  options,
  pkgs_zen_kernel,
  ...
}: let
  username = "william";
  userDescription = "William Tran";
  homeDirectory = "/home/${username}";
  hostName = "william";
  timeZone = "Asia/Ho_Chi_Minh";
  pkgs-unstable = inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in {
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
    ../../modules/sunshine.nix
    inputs.home-manager.nixosModules.default
    inputs.xremap-flake.nixosModules.default
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_zen;
    kernelModules = ["v4l2loopback"];
    extraModulePackages = [
      config.boot.kernelPackages.v4l2loopback
      # (config.boot.kernelPackages.callPackage ../../modules/custom-bluetooth-driver.nix {})
    ];
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
    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
      "8.8.8.8"
    ];
    networkmanager = {
      enable = true;
      insertNameservers = [
        "1.1.1.1"
        "1.0.0.1"
        "8.8.8.8"
      ];
    };
    # timeServers = options.networking.timeServers.default ++ ["pool.ntp.org"];
    firewall = {
      enable = true;
      allowedTCPPorts = [
        3030
        8003
        9009
        9010
        9011
        9012
        9013
        4242
        47984
        47989
        47990
        48010
      ];
      allowedUDPPorts = [
        3030
        24800
        4242
        48000
        48010
      ];
      allowedUDPPortRanges = [
        {
          from = 47998;
          to = 48000;
        }
        {
          from = 8000;
          to = 8010;
        }
      ];
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
    image = ../../config/assets/black_hole.png;
    polarity = "dark";
    opacity.terminal = 0.9;
    cursor.package = pkgs.bibata-cursors;
    cursor.name = "Bibata-Modern-Ice";
    cursor.size = 40;
    fonts = {
      monospace = {
        package = pkgs.unstable.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono derd Font Mono";
      };
      sansSerif = {
        package = pkgs.unstable.montserrat;
        name = "Montserrat";
      };
      serif = {
        package = pkgs.unstable.montserrat;
        name = "Montserrat";
      };
      sizes = {
        applications = 14;
        terminal = 16;
        desktop = 14;
        popups = 14;
      };
    };
  };

  virtualisation = {
    docker = {
      enable = true;
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
      daemon = {
        settings = {
          data-root = "/home/william/docker-data";
        };
      };
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
    steam = {
      enable = true;
      gamescopeSession.enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    };
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
    hyprland = {
      enable = true;
      withUWSM = true;
      # package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      # portalPackage =
      # inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    };
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "ventoy-gtk3-1.1.05"
  ];

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
  xdg.portal.config.common.default = "*";
  environment.systemPackages = with pkgs; [
    # Wine
    unstable.winetricks
    vulkan-tools
    # native wayland support (unstable)
    unstable.wineWowPackages.stagingFull
    unstable.wineWowPackages.waylandFull
    broadcom-bt-firmware
    rtl8761b-firmware
    # Zen Browser from custom input
    inputs.hyprswitch.packages.x86_64-linux.default
    inputs.alejandra.defaultPackage.${pkgs.system}

    syncthing
    unstable.shotcut
    unstable.cloudflared
    unstable.celluloid
    unstable.zsync2
    unstable.barrier
    unstable.gh
    unstable.aider-chat
    unstable.tofi
    unstable.obs-studio
    unstable.ventoy-full-gtk
    unstable.vimPlugins.neogit
    unstable.luajitPackages.luarocks

    # Programming languages and tools
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
    virtualenv
    uv
    clang
    zig
    rustup
    cargo
    nodePackages_latest.pnpm
    nodePackages_latest.yarn
    prisma-engines
    fnm
    bun
    maven
    mongodb-compass
    gcc
    ruby
    lsof
    openssl
    nodePackages_latest.live-server

    # Learn
    unstable.anki-bin

    # Frappe Bench
    redis
    wkhtmltopdf
    nginx
    uv
    mariadb

    # Video editor
    unstable.davinci-resolve

    # Version control and development tools
    git
    gh
    lazygit
    lazydocker
    docker-compose
    bruno
    postman
    gnumake
    coreutils
    nixfmt-rfc-style
    meson
    pkg-config
    cairo
    cpio
    cmake
    nix-prefetch-git
    nix-prefetch-github
    ninja
    xdg-utils

    # Shell and terminal utilities
    usbutils
    croc
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
    nvidia-vaapi-driver
    anydesk

    # Network and internet tools
    aria2
    qbittorrent
    cloudflare-warp
    tailscale

    # Audio and video
    pulseaudio
    helvum
    pavucontrol
    ffmpeg
    mpv
    x265
    kvazaar
    deadbeef-with-plugins

    # Image and graphics
    imagemagick
    gimp
    hyprpicker
    # swww
    hyprlock
    waypaper
    imv

    # Productivity and office
    obsidian
    libreoffice-qt6-fresh

    # Communication and social
    unstable.discord
    unstable.caprine

    # Browsers
    firefox
    inputs.zen-browser.packages."${system}".default
    google-chrome

    # Gaming and entertainment
    stremio
    steam
    unstable.lutris
    unstable.protobuf

    # System utilities
    libgcc
    bc
    bluez5-experimental
    bluez-tools
    bluez-alsa
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
    hyprwayland-scanner
    hyprland-protocols
    hyprland-workspaces
    hyprutils
    hyprlang
    unstable.pkgconf
    brightnessctl
    virt-viewer

    unstable.sunshine

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
    # waybar
    hyprpanel
    # dunst
    wl-clipboard
    # swaynotificationcenter

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
    # cliphist
    # clipse
    copyq

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
  ];

  # Create a custom .desktop file for imv
  environment.sessionVariables.XCURSOR_PATH = [
    "${config.system.path}/share/icons"
    "$HOME/.local/share/icons"
    "$HOME/.icons"
  ];

  environment.etc."sddm/wayland-sessions/hyprland.desktop".text = ''
    [Desktop Entry]
    Name=Hyprland
    Exec=Hyprland
    Type=Application
  '';

  environment.etc = {
    "1password/custom_allowed_browsers" = {
      text = ''
        zen
        zen-browser
      '';
      mode = "0755";
    };
  };

  fonts.packages = with pkgs; [
    unstable.noto-fonts-emoji
    unstable.fira-sans
    unstable.roboto
    unstable.jetbrains-mono
    unstable.noto-fonts-cjk-sans
    unstable.nerd-fonts.fira-code
    unstable.font-awesome
    unstable.material-icons
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
    postgresql = {
      enable = true;
      authentication = pkgs.lib.mkOverride 10 ''
        #type database  DBuser  auth-method
        local all       all     trust
      '';
    };
    sunshine = {
      enable = true;
      autoStart = true;
      capSysAdmin = true;
      openFirewall = true;
      package = pkgs.unstable.sunshine.override {
        cudaSupport = true;
      };
    };
    xremap = {
      withHypr = true;
      serviceMode = "user";
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
        keymap = [
          {
            name = "global";
            remap = {
              Shift_R = "Tab";
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
      videoDrivers = ["nvidia"];
    };
    displayManager.sddm = {
      enable = true;
      wayland.enable = true; # Enable Wayland backend
      theme = "rose-pine"; # Your custom theme name
      autoLogin = {
        enable = true;
        user = "william";
      };
    };

    logind = {
      extraConfig = ''
        HandlePowerKey=suspend
      '';
    };

    cloudflared = {
      package = pkgs.unstable.cloudflared;
      enable = true;
      tunnels = {
        "22414bb7-b356-42bd-8355-15569c8afa5b" = {
          credentialsFile = "/home/william/.cloudflared/22414bb7-b356-42bd-8355-15569c8afa5b.json";
          default = "http_status:404";
          ingress = {
            "presentation.williamtran.tech" = {
              service = "http://localhost:3030";
            };
          };
        };
      };
    };

    cloudflare-warp.enable = false;
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
    openssh = {
      enable = true;
      extraConfig = "";
    };
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
      publish = {
        enable = true;
        userServices = true;
      };
    };

    ipp-usb.enable = true;
    syncthing = {
      enable = false;
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

  systemd.services.NetworkManager-wait-online.enable = false;

  systemd.user.services.onepassword = {
    script = "${pkgs.unstable._1password-gui}/bin/1password --silent %U";
    wantedBy = ["default.target"];
  };

  systemd.user.services.caprine = {
    script = "${pkgs.unstable.caprine}/bin/caprine %U";
    wantedBy = ["default.target"];
    serviceConfig = {
      Restart = "on-failure";
      RestartSec = 3; # Wait 5 seconds before restarting
    };
  };

  systemd.user.services.obsidian = {
    enable = true;
    script = "${pkgs.obsidian}/bin/obsidian %U";
    wantedBy = ["default.target"];
    serviceConfig = {
      Restart = "on-failure";
      RestartSec = 3; # Wait 5 seconds before restarting
    };
  };

  systemd.user.services.xremap = {
    enable = true;
    wantedBy = ["default.target"];
  };

  systemd.user.services.zalo = {
    enable = true;
    script = ''
      ${pkgs.unstable.wineWowPackages.stagingFull}/bin/wine "C:\\users\\william\\AppData\\Roaming\\Microsoft\\Windows\\Start Menu\\Programs\\Zalo.lnk"
    '';
    wantedBy = ["multi-user.target"];
  };

  systemd.user.services.lan-mouse = {
    script = "export PATH=$PATH:/usr/bin; /home/william/scripts/lan-mouse.sh";
    path = ["/usr/bin"];
    environment.HOME = "/home/william";
    wantedBy = ["graphical.target"];
    serviceConfig = {
      Restart = "on-failure";
      RestartSec = 3; # Wait 5 seconds before restarting
    };
  };

  # start up
  systemd.services = {
    cursor = {
      script = ''
        ${pkgs.appimage-run}/bin/appimage-run /home/william/Downloads/Cursor-0.50.4-x86_64.AppImage &
      '';
      wantedBy = ["multi-user.target"];
    };
    cider = {
      script = ''
        ${pkgs.appimage-run}/bin/appimage-run /home/william/Downloads/cider-v2.0.3-linux-x64.AppImage &
      '';
      wantedBy = ["multi-user.target"];
    };
    flatpak-repo = {
      path = [pkgs.flatpak];
      script = "flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo";
    };
    libvirtd = {
      enable = true;
      wantedBy = ["multi-user.target"];
      requires = ["virtlogd.service"];
    };
  };

  hardware = {
    enableAllFirmware = true;
    enableRedistributableFirmware = true;
    sane = {
      enable = true;
      extraBackends = [pkgs.sane-airscan];
      disabledDefaultBackends = ["escl"];
    };
    xone = {
      enable = true;
    };
    xpadneo = {
      enable = true;
    };
    logitech.wireless = {
      enable = true;
      enableGraphical = true;
    };
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      package = pkgs.bluez5-experimental;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
          FastConnectable = "true";
          Experimental = "true";
          ControllerMode = "dual";
        };
        Policy = {
          AutoEnable = "true";
        };
      };
    };
    nvidia = {
      powerManagement.enable = true;
      open = false;
      package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
        version = "575.51.02";
        sha256_64bit = "sha256-XZ0N8ISmoAC8p28DrGHk/YN1rJsInJ2dZNL8O+Tuaa0=";
        openSha256 = "sha256-NQg+QDm9Gt+5bapbUO96UFsPnz1hG1dtEwT/g/vKHkw=";
        settingsSha256 = "sha256-6n9mVkEL39wJj5FB1HBml7TTJhNAhS/j5hqpNGFQE4w=";
        usePersistenced = false;
      };
    };
    graphics = {
      enable = true;
      enable32Bit = true;
      package = pkgs-unstable.mesa;
      package32 = pkgs-unstable.pkgsi686Linux.mesa;
      extraPackages = with pkgs; [
        vpl-gpu-rt
        intel-media-driver
        vaapi-intel-hybrid
        libva-vdpau-driver
        intel-compute-runtime
      ];
    };
  };

  services.blueman.enable = true;

  environment.variables.XDG_RUNTIME_DIR = "/run/user/$UID";

  security = {
    pam.services.gdm-password.enableGnomeKeyring = true;
    pam.services.greetd.enableGnomeKeyring = true;
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
      download-buffer-size = 524288000;
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
  programs.gamemode.enable = false;
  programs._1password = {
    enable = true;
    package = pkgs.unstable._1password-cli;
  };
  programs._1password-gui = {
    enable = true;
    package = pkgs.unstable._1password-gui;
    polkitPolicyOwners = ["william"];
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
    "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = "libreoffice-writer.desktop";
    "application/vnd.ms-powerpoint" = "libreoffice-impress.desktop";
    "application/vnd.openxmlformats-officedocument.presentationml.presentation" = "libreoffice-impress.desktop";

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
    extraSpecialArgs = {inherit inputs;};
    users.${username} = import ./home.nix;
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
  };

  # fileSystems."/var/lib/bluetooth" = {
  #   device = "/persist/var/lib/bluetooth";
  #   options = [
  #     "bind"
  #     "noauto"
  #     "x-systemd.automount"
  #   ];
  #   noCheck = true;
  # };

  system.stateVersion = "25.05";
}
