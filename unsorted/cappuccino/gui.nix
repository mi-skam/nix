{ pkgs, ... }:

let

  keepassWithPlugins = pkgs.keepass.override {
    plugins =  with pkgs; [
      keepass-keepasshttp
      keepass-keeagent
    ];
  };
  yed_3_21_1 = pkgs.yed.overrideAttrs (oldAttrs: rec {
    version = "3.21.1";

    src = pkgs.fetchzip {
      url = "https://www.yworks.com/resources/yed/demo/yEd-${version}.zip";
      sha256 = "1jw28hkd7p0n660gid8yh5y0kdcz6ycn4hsgjlf0pq48x9kv6w0c";
    };
  });

in
  {
    home.packages = with pkgs; [
      # browser
      calibre
      chromium
      
      # communication
      signal-desktop
      tdesktop
      teams
      zoom-us

      # creativity
      openscad
      freecad
      gimp
      inkscape

      # gaming
      steam

      # office
      libreoffice-fresh
      
      # utils
      qbittorrent
      pavucontrol
      nextcloud-client
      joplin-desktop
      keepassWithPlugins
      wl-clipboard
      klavaro
      yed_3_21_1

    ];

    programs.vscode = {
      enable = true; 
      extensions = with pkgs.vscode-extensions; [
        ms-python.python
        ms-vscode.cpptools
      ];
    };
  }
