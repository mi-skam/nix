{ config, pkgs, ... }:

let

dbConfig = {
  db = "smartdrei";
  user = "testuser";
  password = "dTlf1IkthgZ5uk9v";
};

in
{
  imports =
    [
      ./hardware-configuration.nix
    ];
 
  services.mysql = {
    enable = true;
    bind = "localhost";
    package = pkgs.mariadb;
    ensureDatabases = [
      dbConfig.db
    ];
    ensureUsers = [
      {
        name = "${dbConfig.user}";
	ensurePermissions = {
	  "${dbConfig.db}.*" = "ALL PRIVILEGES";
	};
      }
    ];
  };

  systemd.services.setdbpass = {
    description = "MySQL database password setup";
    wants = [ "mysql.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = ''
      ${pkgs.mariadb}/bin/mysql -e "grant all privileges on ${dbConfig.db}.* to ${dbConfig.user}@localhost identified by '${dbConfig.password}';" ${dbConfig.db}
      '';
      User = "root";
      PermissionsStartOnly = true;
      RemainAfterExit = true;
    };
  };
 
  boot = {
    kernel.sysctl = {
      "net.ipv4.ip_forward" = 1;
    };
    kernelModules = [ "kvm-intel" ];
    kernelParams = [ "intel_iommu=on" "elevator=none" "acpi_osi=!" "acpi_osi=\"Windows 2009\"" ];
    loader = {
      systemd-boot.enable = true;
      efi.efiSysMountPoint = "/boot/efi";
    };
    supportedFilesystems = [ "zfs" ];
    zfs.requestEncryptionCredentials = true;
  };

  environment.systemPackages = with pkgs; [
     fd
     kristall
     evince
     pcmanfm
     playerctl
     pamixer
     pulseaudio
     ripgrep
     vim
     vlc
     wob
  ];

  fonts.fonts = with pkgs; [ font-awesome ];

  networking = {
    firewall = {
      allowedTCPPorts = [ 8080 22000 9955 ];
      allowedUDPPorts = [ 21027 ];
    };
    hostId = "8f891c31";
    hostName = "cappuccino"; # Define your hostname.
    interfaces = {
      enp61s0.useDHCP = true;
      wlo1.useDHCP = true;
    };
    networkmanager.enable = true;
    useDHCP = false;
  };

  nixpkgs.config.allowUnfree = true;

  nix = {
    package = pkgs.nixUnstable;
    trustedUsers = [ "root" "plumps" ];
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  programs = {
    adb.enable = true;
    ssh.startAgent = true;
    sway = {
      enable = true;
      extraPackages = with pkgs; [
	alacritty
        i3status
	waybar
	gammastep
	clipman
	wofi
	flashfocus
	slurp
	wf-recorder
	mako
      ];
      extraSessionCommands =
        ''
          export SDL_VIDEODRIVER=wayland
          # needs qt5.qtwayland in systemPackages
          export QT_QPA_PLATFORM=wayland
          export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
          # Fix for some Java AWT applications (e.g. Android Studio),
          # use this if they aren't displayed properly:
          export _JAVA_AWT_WM_NONREPARENTING=1
          export XDG_CURRENT_DESKTOP=sway
	  # starting gnome-keyring
	  eval $(/run/wrappers/bin/gnome-keyring-daemon --start --daemonize) export SSH_AUTH_SOCK
        '';
    };
  };

  security = {
    pam.services.lightdm.enableGnomeKeyring = true;
    rtkit.enable = true;
  };

  services = {
    dbus.packages = with pkgs; [ gnome.dconf ];
    gnome.gnome-keyring.enable = true;
    openssh.enable = true;
    pipewire = {
      enable = true; # enables display capturing on wayland; requires xdg.portal
      alsa.enable = true;
      pulse.enable = true;
    };
    printing = {
      enable = true;
      drivers = with pkgs; [ samsung-unified-linux-driver_1_00_37 ];
    };
    teamviewer.enable = false;
    tor = {
      enable = true;
      client.enable = true;
    };
    udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];
    xserver = {
      enable = true;
      layout = "de";
      libinput.enable = true;
      xkbVariant = "neo";
      displayManager = {
        lightdm.enable = true;
      };
    };
    zfs.autoScrub.enable = true;
  };

  # NVIDIA
  hardware = {
     bluetooth.enable = true;
     bumblebee = {
       enable = true; # This should power off secondary GPU until its use is requested by running an application with optirun.
       connectDisplay = true;
       driver = "nouveau";
       pmMethod = "bbswitch";
     };
    logitech = {
      wireless.enable = true;
      wireless.enableGraphical = true;
    };
    nvidia.modesetting.enable = true;
    opengl = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver # LIBVA_DRIVER_NAME=iHD
        vaapiIntel         # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
        vaapiVdpau
        libvdpau-va-gl
      ];
      driSupport32Bit = true;
      extraPackages32 = with pkgs.pkgsi686Linux; [ libva vaapiIntel ];
    };
    pulseaudio.enable = false;
  };


  # Enable sound.
  sound.enable = true;

  time.timeZone = "Europe/Berlin";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.plumps = {
    isNormalUser = true;
    extraGroups = [ "adbusers" "wheel" "docker" "libvirtd" ]; # Enable ‘sudo’ for the user.
  };
  
  system = {
    autoUpgrade = {
      enable = true;
    };
    stateVersion = "21.05";
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-wlr xdg-desktop-portal-gtk ];
    gtkUsePortal = true;
  };
  virtualisation = {
    docker = {
      enable = true;
      storageDriver = "zfs";
    };
  };
}

