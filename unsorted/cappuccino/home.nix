{ config, lib, pkgs, ... }:



{
  imports = [ ./gui.nix ];
  
  home = {
    homeDirectory = "/home/plumps";
    packages = with pkgs; [ 
      
      niv

      git-crypt

      htop
      file
      bat
      tree
      zip
      unzip
      feh

      nodePackages.prettier

      pciutils
      mpv
      cmus

      aerc

    ];
    stateVersion = "21.03";
    username = "plumps";
  };

  programs = {
    autojump.enable = true;
    bash = {
      enable = true;
      initExtra = ''
        if command -v tmux >/dev/null 2>&1 && [ "$\{DISPLAY}" ]; then
          # if not inside a tmux session, and if no session is started, start a new session
          [ -z "$\{TMUX}" ] && (tmux attach -t main || tmux) >/dev/null 2>&1
        fi
        '';
    };
    direnv = {
      enable = true;
      enableBashIntegration = true;
      enableNixDirenvIntegration = true;
    };
    emacs = {
      enable = true;
      package = pkgs.emacs-nox;
    };
    firefox = {
      enable = true;
    };
    fzf = {
      enable = true;
      enableBashIntegration = true;
    };
    gh = {
      enable = true;
      gitProtocol = "ssh";
    };
    git = {
      enable = true;
      lfs.enable = true;
      userName = "mi-skam";
      userEmail = "maksim.codes@mailbox.org";
      signing.key = "DCD4 3646 C772 519F B4E3  150E E663 9BE8 15B7 2149";

    };
    gpg.enable = true;
    home-manager.enable = true;
    neovim = {
      enable = true;
      vimAlias = true;
      extraConfig = ''
        
        let mapleader = ','

        colorscheme desert
        
        set autowrite
        set number
        set smartindent
        set tabstop=4
        set expandtab
        
        nnoremap <leader>r :!home-manager switch<CR>
        nnoremap <leader>p :Files<CR>
        nnoremap <leader>g :GFiles<CR>
        nnoremap <leader>b :Buffers<CR>
        nnoremap <leader>h :History<CR>
        
        nnoremap <C-g> :Rg<CR>

        nnoremap <F5> mzgggqG`z

        " FORMATTERS
        au FileType javascript setlocal formatprg=prettier
        au FileType javascript.jsx setlocal formatprg=prettier
        au FileType typescript setlocal formatprg=prettier\ --parser\ typescript
        au FileType html setlocal formatprg=js-beautify\ --type\ html
        au FileType scss setlocal formatprg=prettier\ --parser\ css
        au FileType css setlocal formatprg=prettier\ --parser\ css

        " FILETYPE SPECIFIC SETTINGS
        
        " .pug
        au FileType pug setlocal shiftwidth=4 softtabstop=4 expandtab
      '';
      # package = pkgs.neovim-nightly;
      plugins = with pkgs.vimPlugins; [ 
        The_NERD_tree
        fzf-vim auto-pairs
        vim-commentary
        vim-nix 
        vim-polyglot
        vim-obsession
      ];
    };
    ssh = {
      enable = true;
      compression = true;
      forwardAgent = true;
      matchBlocks = {
        "miskam.github.com" = {
          hostname = "github.com";
          user = "mi-skam";
        };
        "herredgar.github.com" = {
          hostname = "github.com";
          user = "herredgar";
        };
      };
    };
    tmux = {
      enable = true;
      disableConfirmationPrompt = true;
      newSession = true;
      terminal = "screen-256color";
      plugins = with pkgs; [
        {
          plugin = tmuxPlugins.resurrect;
          extraConfig = ''
            set -g @resurrect-strategy-nvim 'session'
            set -g @resurrect-strategy-vim 'session'
          '';
        }
        {
        plugin = tmuxPlugins.continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '60' # minutes
        '';
        }
        {
        plugin = tmuxPlugins.yank;
        }
      ];
      extraConfig = ''
        unbind C-b

        set -g prefix M-a
        bind M-a send-prefix
        
        # make delay shorter
        set -sg escape-time 0

        set -g mouse-utf8 on
        set -g mouse on

        bind | split-window -h -c "#{pane_current_path}"
        bind - split-window -v -c "#{pane_current_path}"
        '';

    };

  };

  services = {
    lorri.enable = true;
    syncthing.enable = true;
    gpg-agent = {
      enable = true;
      enableSshSupport = true;
    };
  };

}
