{ pkgs, ... }:

{
  home.sessionVariables = {
    EDITOR = "vim";
    PS1 = "\\u@\\h:\\w\\$ ";
  };

  home.packages = with pkgs; [
    # utils
    bashInteractive
    moreutils
    bat
    fd
    jq
    ranger
    ripgrep
    tree
    htop
    unzip

    # nix

    nixpkgs-fmt # nix code formatter
    rnix-lsp # nix language server
    yarn
    yarn2nix

    # multimedia
    youtube-dl


  ];

  programs = {
    autojump = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
    };
    bash = {
      enable = true;
      initExtra = ''
        export FZF_DEFAULT_COMMAND='${pkgs.ripgrep}/bin/rg --files --follow --hidden'
      '';

    };
    direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv = {
        enable = true;
        enableFlakes = true;
      };
    };
    emacs = {
      enable = true;
    };
    fish = {
      enable = true;
      shellInit = ''
        export FZF_DEFAULT_COMMAND='${pkgs.ripgrep}/bin/rg --files --follow --hidden'
      '';
    };
    gh = {
      enable = true;
      settings = {
          aliases = {
            co = "pr checkout";
            pv = "pr view";
            cr = "repo create";
            };
          git_protocol = "ssh";
      };
    };
    git = {
      enable = true;
      userName = "mi-skam";
      userEmail = "maksim.codes@mailbox.org";
      signing.key = "8DFFF673";
      aliases = {
        co = "checkout";
        s = "status";
        p = "pull";
        c = "commit -S";
        d = "diff";
        l = "log --oneline";
      };
      delta.enable = true;
      extraConfig = {
        init = {
          defaultBranch = "main";
        };
        push.default = "current";
      };
      lfs.enable = true;
    };
    gpg = {
      enable = true;
    };
    neovim = {
      enable = true;
      vimAlias = true;
      plugins = with pkgs.vimPlugins; [ ale fzf-vim vim-polyglot ];
      coc = {
        enable = true;
      };
      extraConfig = ''
        " g
        let mapleader = ","
        " mouse
        set mouse=a
        " Fix the code
        nmap <F6> :ALEFix<CR>
        " FZF
        nnoremap <Leader>p :GFiles<CR>
        nnoremap <Leader>b :Buffers<CR>
        nnoremap <Leader>h :History<CR>
      '';
    };
  };
  xdg.configFile."nvim/ftplugin/javascript.vim".text = ''
    " Fix files with prettier, and then ESLint.
    let b:ale_fixers = ['prettier', 'eslint']
    " Equivalent to the above.
    let b:ale_fixers = {'javascript': ['prettier', 'eslint']}
    '';
  services = {
    gpg-agent = {
      enable = true;
      pinentryFlavor = "tty";
    };
  };
}
