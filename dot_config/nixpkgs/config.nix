{
  packageOverrides = pkgs: with pkgs; {
    myPackages = pkgs.buildEnv {
      name = "my-packages";
      paths = [
        bat
        delta
        du-dust
        fd
        fzf
        lazygit
        lsd
        ripgrep
        starship
        tmux
        tmuxinator
        zoxide
        zsh
      ];
    };
  };
}

