{ config, pkgs, ... }:

{
  ## Usuario
  home.username = "pham";
  home.homeDirectory = "/home/pham";

  ## Recursos X (cursor, DPI)
  xresources.properties = {
    "Xcursor.size" = 24;
    "Xft.dpi" = 96;
  };

  ## Discord (OpenASAR + Vencord)
  programs.discord = {
    enable = true;
    package = pkgs.discord.override {
      withOpenASAR = true;
      withVencord = true;
    };
  };

  ## Paquetes de usuario
  home.packages = with pkgs; [
    # Gnome
    gnomeExtensions.no-overview
    gnomeExtensions.emoji-copy

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
    "org/gnome/settings-daemon/plugins/power" = {
      sleep-inactive-ac-type = "nothing";
      power-button-action = "interactive";
    };
    "org/gnome/desktop/peripherals/keyboard" = {
      delay = uint32 200;
      repeat-interval = uint32 20;
    };
  };

  ## Versión de Home Manager (NO tocar)
  home.stateVersion = "25.11";
}
