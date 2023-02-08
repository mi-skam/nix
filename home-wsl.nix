{ pkgs, ... }:

let
  "wslNotify" = pkgs.writeShellScriptBin "wsl-notify" ''
    #!/usr/bin/env -bash

    pwsh.exe -C "New-BurntToastNotification -Text \"$1\""
  '';

in
{
  imports = [
    ./common.nix
  ];

  home.packages = with pkgs; [
    # nix
    nixUnstable

    # wsl
    wslNotify
  ];

  programs = {
    bash = {
      enable = true;
      bashrcExtra = ''
        export SSH_AUTH_SOCK=$HOME/.ssh/agent.sock

        ss -a | grep -q $SSH_AUTH_SOCK
        if [ $? -ne 0 ]; then
            rm -f $SSH_AUTH_SOCK
            (setsid ${pkgs.socat}/bin/socat UNIX-LISTEN:$SSH_AUTH_SOCK,fork EXEC:"${pkgs.npiperelay}/bin/npiperelay.exe -ei -s //./pipe/openssh-ssh-agent",nofork &) >/dev/null 2>&1
        fi       
        eval "$(oh-my-posh-wsl --init --shell bash --config /mnt/c/Users/plumps/Documents/WindowsPowerShell/prompt.json)"
      '';
      profileExtra = ''
        . /home/plumps/.nix-profile/etc/profile.d/nix.sh
      '';
    };
    # needs win32yank.exe in PATH of wsl instance
    neovim.extraConfig = ''
      set clipboard+=unnamedplus
      let g:clipboard = {
          \   'name': 'win32yank-wsl',
          \   'copy': {
          \      '+': 'win32yank.exe -i --crlf',
          \      '*': 'win32yank.exe -i --crlf',
          \    },
          \   'paste': {
          \      '+': 'win32yank.exe -o --lf',
          \      '*': 'win32yank.exe -o --lf',
          \   },
          \   'cache_enabled': 0,
          \ }
      '';
  };
}
