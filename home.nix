{ config, pkgs, lib, ... }:

{
  ## Usuario
  home.username = "pham";
  home.homeDirectory = "/home/pham";

  ## Discord (OpenASAR + Vencord)
  programs.discord = {
    enable = true;
    package = pkgs.discord.override {
      withVencord = true;
    };
  };

  ## Paquetes de usuario
  home.packages = with pkgs; [
    # Gnome
    gnomeExtensions.dash-to-dock
    gnomeExtensions.blur-my-shell
    gnomeExtensions.just-perfection
    gnomeExtensions.appindicator
    gnomeExtensions.no-overview
    gnomeExtensions.vitals

    # Utilidades
    fastfetch
    nnn
    zip
    xz
    unzip
    p7zip
    file
    which
    tree

    # Gaming
    mangohud
    lutris
    protonplus
    prismlauncher
    winetricks
    hydralauncher
    wineWowPackages.staging
    bottles
    heroic

    # Navegador y seguridad
    brave
    keepassxc

    # CLI moderna
    ripgrep
    jq
    yq-go
    eza
    fzf
    glow
    nix-output-monitor

    # Red
    mtr
    iperf3
    dnsutils
    ldns
    aria2
    socat
    nmap
    ipcalc

    # Sistema
    btop
    iotop
    iftop
    sysstat
    lm_sensors
    ethtool
    pciutils
    usbutils

    # Debug
    strace
    ltrace
    lsof

    # GNU utils
    gnused
    gnutar
    gawk
    zstd
    gnupg
  ];

  ## Git
  programs.git = {
    enable = true;
    settings = {
      user.name = "Phamzito";
      user.email = "phamzito@outlook.com";
    };
  };

  ## Prompt (Starship)
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      line_break.disabled = true;
      aws.disabled = true;
      gcloud.disabled = true;
    };
  };

  ## Terminal (Alacritty)
  programs.alacritty = {
    enable = true;
    settings = {
      env.TERM = "xterm-256color";

      font = {
        size = 12;
        draw_bold_text_with_bright_colors = true;
      };

      scrolling.multiplier = 5;
      selection.save_to_clipboard = true;
    };
  };

  ## Bash
  programs.bash = {
    enable = true;
    enableCompletion = true;

    bashrcExtra = ''
      export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
    '';

    shellAliases = {
      k = "kubectl";
      urldecode = "python3 -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.stdin.read()))'";
      urlencode = "python3 -c 'import sys, urllib.parse as ul; print(ul.quote_plus(sys.stdin.read()))'";
    };
  };

  dconf.settings = {
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [
        "dash-to-dock@micxgx.gmail.com"
        "blur-my-shell@aunetx"
        "just-perfection-desktop@just-perfection"
        "appindicatorsupport@rgcjonas.gmail.com"
        "Vitals@CoreCoding.com"
        "no-overview@fthx"
      ];
    };
    "org/gnome/shell/extensions/vitals" = {
      hot-sensors = [ "_processor_usage_" "_memory_usage_" "_temperature_processor_" "_temperature_gpu_" ];
      update-time = 2; # Segundos entre actualizaciones
      show-voltage = false;
    };
    "org/gnome/shell/extensions/blur-my-shell/panel" = {
      blur = true;
      brightness = 0.75;
      sigma = 30;
    };
    "org/gnome/shell/extensions/dash-to-dock" = {
      dash-max-icon-size = 32;
      extend-height = false;
      dock-position = "BOTTOM";
      background-opacity = 0.4;
      transparency-mode = "FIXED";
      dock-fixed = false;
      autohide = true;
      intellihide = true;
      show-mounts = false;
      show-trash = false;
      custom-theme-shrink = true;
    };
    "org/gnome/settings-daemon/plugins/power" = {
      sleep-inactive-ac-type = "nothing";
      power-button-action = "interactive";
    };
    "org/gnome/desktop/peripherals/keyboard" = {
      delay = lib.hm.gvariant.mkUint32 180;
      repeat-interval = lib.hm.gvariant.mkUint32 20;
    };
  };

  ## Versión de Home Manager (NO tocar)
  home.stateVersion = "25.11";
}
