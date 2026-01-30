{ config, pkgs, inputs, ... }:

{
  imports = [
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
    inputs.nixos-hardware.nixosModules.common-cpu-amd-zenpower
    inputs.nixos-hardware.nixosModules.common-gpu-amd
    inputs.nixos-hardware.nixosModules.common-pc
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    ./hardware-configuration.nix
  ];

  ## Arranque del sistema
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;
  boot.kernelModules = [ "ntsync" ];
  boot.kernelParams = [
    "usbhid.kbpoll=1"
    "usbhid.mousepoll=1"    
    "usbhid.jspoll=1"
    "amdgpu.ppfeaturemask=0xffffffff"
  ];
  boot.kernel.sysctl = {
    "kernel.sched_latency_ns" = 6000000;
    "kernel.sched_min_granularity_ns" = 750000;
    "kernel.sched_wakeup_granularity_ns" = 1000000;
    "vm.max_map_count" = 2147483642;
    "vm.swappiness" = 10;
  };

  ## Configuración de Nix
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  ## Red
  networking = {
    hostName = "phamnochita";
    networkmanager.enable = true;
  };

  ## Zona horaria e idioma
  time.timeZone = "America/Mexico_City";
  i18n.defaultLocale = "es_MX.UTF-8";
  console.keyMap = "es";

  ## Modo Rendimiento de CPU
  powerManagement.cpuFreqGovernor = "performance";

  ## Servidor gráfico y GNOME
  services.xserver = {
    enable = true;

    xkb = {
      layout = "es";
      variant = "";
    };

    # Driver de video para AMD
    videoDrivers = [ "amdgpu" ];
  };

  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  ## Configuración de hardware
  hardware = {
    # Soporte OpenCL para AMD
    amdgpu.opencl.enable = true;

    # I2C (sensores, brillo por DDC/CI, etc.)
    i2c.enable = true;
  };

  ## Impresión
  services.printing.enable = true;

  ## Audio (PipeWire)
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;

    alsa = {
      enable = true;
      support32Bit = true;
    };

    pulse.enable = true;
    jack.enable = true;
  };

  ## Usuarios
  users.users.pham = {
    isNormalUser = true;
    description = "Pham";

    extraGroups = [
      "networkmanager"
      "wheel"
      "gamemode"
      "i2c"
    ];

    packages = with pkgs; [ ];
  };

  systemd.services.lact = {
    description = "AMDGPU Control Daemon";
    after = ["multi-user.target"];
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      ExecStart = "${pkgs.lact}/bin/lact daemon";
    };
    enable = true;
  };

  ## Variables de entorno
  environment.sessionVariables = {
    AMD_VULKAN_ICD = "RADV";
    RADV_PERFTEST = "aco";
    MESA_DISK_CACHE_SINGLE_FILE = "1";
  };

  ## Gaming
  programs.gamemode.enable = true;

  programs.steam = {
    enable = true;

    package = pkgs.steam.override {
      extraPkgs = pkgs: with pkgs; [
        gamemode
      ];
    };
  };

  ## Paquetes del sistema
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    lact
    git
    vim
    wget
  ];

  ## Versión del sistema
  system.stateVersion = "25.11";
}
