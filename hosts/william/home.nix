{
  config,
  pkgs,
  inputs,
  ...
}: let
  userName = "william";
  homeDirectory = "/home/${userName}";
  stateVersion = "24.11";
  onePassPath = "~/.1password/agent.sock";
in {
  home = {
    username = userName;
    homeDirectory = homeDirectory;
    stateVersion = stateVersion; # Please read the comment before changing.

    file = {
      # Hyprland Config
      # ".config/hypr".source = ../../dotfiles/.config/hypr;

      # wlogout icons
      ".config/wlogout/icons".source = ../../config/wlogout;

      # Top Level Files symlinks
      ".zshrc".source = ../../dotfiles/.zshrc;
      ".gitconfig".source = ../../dotfiles/.gitconfig;
      ".local/bin/wallpaper".source = ../../dotfiles/.local/bin/wallpaper;

      # Config directories
      ".config/dunst".source = ../../dotfiles/.config/dunst;
      ".config/fastfetch".source = ../../dotfiles/.config/fastfetch;
      ".config/kitty".source = ../../dotfiles/.config/kitty;
      ".config/mpv".source = ../../dotfiles/.config/mpv;
      ".config/tmux/tmux.conf".source = ../../dotfiles/.config/tmux/tmux.conf;
      ".config/waybar".source = ../../dotfiles/.config/waybar;
      ".config/yazi".source = ../../dotfiles/.config/yazi;

      # Individual config files
      ".config/starship.toml".source = ../../dotfiles/.config/starship.toml;
      ".config/autostart/cider.desktop".text = ''
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
    };

    sessionVariables = {
      # Default applications
      EDITOR = "nvim";
      VISUAL = "nvim";
      TERMINAL = "kitty";
      BROWSER = "zen";

      # XDG Base Directories
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_STATE_HOME = "$HOME/.local/state";
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_SCREENSHOTS_DIR = "$HOME/Pictures/screenshots";

      # Path modifications - now as a string
      # PATH = "$HOME/.local/bin:$HOME/go/bin:$PATH";

      # Wayland and Hyprland specific
      JAVA_AWT_WM_NOREPARENTING = 1;
      XDG_SESSION_TYPE = "wayland";
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_DESKTOP = "Hyprland";

      # NVIDIA specific
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      GBM_BACKEND = "nvidia-drm";

      # Electron/Wayland hint
      ELECTRON_OZONE_PLATFORM_HINT = "auto";

      # Localization
      LC_ALL = "en_US.UTF-8";
    };

    sessionPath = [
      "$HOME/.local/bin"
      "$HOME/go/bin"
    ];

    packages = [
      (import ../../scripts/rofi-launcher.nix {inherit pkgs;})
    ];
  };

  imports = [
    ../../config/rofi/rofi.nix
    ../../config/wlogout.nix
  ];

  # Styling
  stylix.targets.waybar.enable = false;
  gtk = {
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };
  qt = {
    enable = true;
    style.package = [
      inputs.lightly.packages.${pkgs.system}.darkly-qt5
      inputs.lightly.packages.${pkgs.system}.darkly-qt6
    ];
    platformTheme.name = "qtct";
  };

  services.copyq = {
    enable = true;
  };

  services.hypridle = {
    settings = {
      general = {
        after_sleep_cmd = "hyprctl dispatch dpms on";
        ignore_dbus_inhibit = false;
        lock_cmd = "hyprlock";
      };
      listener = [
        {
          timeout = 900;
          on-timeout = "hyprlock";
        }
        {
          timeout = 1200;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };

  programs.home-manager.enable = true;
  # programs.ssh = {
  #   enable = true;
  #   extraConfig = "";
  # };

  xdg.portal.config.common.default = "*";
  xdg.desktopEntries = {
    cider = {
      name = "Cider";
      genericName = "Apple Music";
      exec = "/home/william/Downloads/cider-v2.0.3-linux-x64.AppImage %U";
      icon = "/home/william/applications/cider/tray.png";
      terminal = false;
      categories = [
        "Application"
        "Music"
      ];
      mimeType = [
        "text/html"
        "text/xml"
      ];
    };
    cursor = {
      name = "Cursor";
      genericName = "Apple Music";
      exec = "/home/william/Downloads/Cursor-0.50.4-x86_64.AppImage %U";
      terminal = false;
      icon = "/home/william/applications/cursor/code.png";
      categories = [
        "Application"
        "Music"
      ];
      mimeType = [
        "text/plain"
        "inode/directory"
        "application/x-cursor-workspace"
      ];
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    systemd.variables = ["--all"];
    extraConfig = ''
      source = ~/.config/hypr/custom.conf
      source = ~/.config/hypr/keybindings.conf
      source = ~/.config/hypr/windowrules.conf
    '';
  };

  wayland.windowManager.hyprland.plugins = [
    pkgs.hyprlandPlugins.hyprsplit
  ];
}
