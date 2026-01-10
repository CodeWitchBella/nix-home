{ config, pkgs, ... }:
let
  fishy = {
    enable = true;
    enableFishIntegration = true;
  };
in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "isabella";
  home.homeDirectory = "/home/isabella";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  # programs.zed-editor = {
  #   enable = true;
  #   extensions = [ "nix" ];
  #   package = config.lib.nixGL.wrap pkgs.zed-editor;
  #   extraPackages = [ pkgs.nixd ];
  #   userSettings = {
  #     features = {
  #       copilot = false;
  #     };
  #     telemetry = {
  #       metrics = false;
  #     };
  #     vim_mode = false;
  #     ui_font_size = 16;
  #     buffer_font_size = 16;
  #   };
  # };
  programs.htop.enable = true;
  programs.vim = {
    enable = true;
    defaultEditor = true;
  };
  programs.fish = {
    enable = true;
    shellInitLast = ''
      source "$HOME/.cargo/env.fish"
      set -gx PNPM_HOME "/home/isabella/.local/share/pnpm"
      if not string match -q -- $PNPM_HOME $PATH
        set -gx PATH "$PNPM_HOME" $PATH
      end
    '';
  };
  programs.zoxide = fishy;
  programs.atuin = fishy;
  programs.direnv.enable = true;
  programs.eza.enable = true;
  programs.bat.enable = true;
  programs.git = {
    enable = true;
    userName = "Isabella Skořepová";
    userEmail = "isabella@skorepova.info";
    lfs.enable = true;
    extraConfig = {
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      submodule.recurse = "true";
      # user.signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEGS4V/SauPK+C9moGX5gscGYYPNV5E6QNUyaZrL1eg0";
      # commit.gpgsign = true;
      # gpg.format = "ssh";
      alias.frp = "!bash -c \"git fetch --prune --tags ; git rebase `git symbolic-ref refs/remotes/origin/HEAD --short`; git push --force\"";
      alias.squash = ''
        !bash -c '
          if [ -z "$1" ]; then
            echo "Usage: git squash [REF]"
            echo "eg. git squash HEAD~3 would squash the last three commits"
            exit 0
          fi
          echo "0: $0"
          echo "1: $1"
          echo "2: $2"
          set -xe
          BRANCH=`git symbolic-ref HEAD --short`
          if git rev-parse --abbrev-ref --symbolic-full-name @{u}
          then TRACKING=`git rev-parse --abbrev-ref --symbolic-full-name @{u}`
          else TRACKING=""
          fi
          git branch -m "tmp/$BRANCH"
          git checkout "$1"

          git switch -c "$BRANCH"
          git merge --squash "tmp/$BRANCH"
          git commit --no-edit
          git branch -D "tmp/$BRANCH"
          if [ ! -z "$TRACKING" ]
          then git branch --set-upstream-to "$TRACKING"
          fi
        ' - \
      '';
      alias.fprune =
        let
          bin = pkgs.writeShellScriptBin "fp" ''
            set -e

            echo "fetching"
            git fetch -p
            echo "fetched"

            for branch in $(git for-each-ref --format "%(refname) %(upstream:track)" refs/heads | awk '$2 == "[gone]" {sub("refs/heads/", "", $1); print $1}'); do
              git branch -D "$branch"
            done
          '';
        in
        "!${bin}/bin/fp";
      alias.fr = "!bash -c \"git fetch --prune --tags ; git rebase `git symbolic-ref refs/remotes/origin/HEAD --short`\"";
      alias.ruff = ''
        !bash -c "
            set -xe
            if [ -z \"`git status --porcelain`\" ]; then
                if ruff format --check && ruff check; then
                echo \"Everything ok\"
                else
                ruff format
                ruff check --fix
                git commit -a -m ruff
                echo \"ruffed some feathers\"
                fi
            else
                echo \"not ready for ruff\"
                exit 1
            fi
        "
      '';
      rebase.autostash = true;
      pull.rebase = true;
      "gpg \"ssh\"".program = "${pkgs.openssh}/bin/ssh-keygen";
    };
  };
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        email = "isabella@skorepova.info";
        name = "Isabella Skořepová";
      };
      aliases = {
        init = [ "git" "init" ];
        push = [ "git" "push" "-c" "@-" ];
      };
    };
  };

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    fend
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/isabella/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "vim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
