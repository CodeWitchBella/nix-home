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

  programs.zed-editor = {
    enable = true;
    extensions = ["nix"];
    package = config.lib.nixGL.wrap pkgs.zed-editor;
    extraPackages = [ pkgs.nixd ];
    userSettings = {
      features = {
        copilot = false;
      };
      telemetry = {
        metrics = false;
      };
      vim_mode = false;
      ui_font_size = 16;
      buffer_font_size = 16;
    };
  };
  programs.htop.enable = true;
  programs.vim = {
    enable = true;
    defaultEditor = true;
  };
  programs.fish.enable = true;
  programs.zoxide = fishy;
  programs.atuin = fishy;
  programs.direnv.enable = true;
  programs.eza.enable = true;
  programs.bat.enable = true;
  programs.git = {
    enable = true;
    userName = "Isabella Skořepová";
    userEmail = "isabella@skorepova.info";
  };
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        email = "isabella@skorepova.info";
        name = "Isabella Skořepová";
      };
      aliases = {
        init = ["git" "init"];
        push = ["git" "push" "-c" "@-"];
      };
    };
  };

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    fend
    nixgl.nixGLIntel # It's actually mesa...
    # (config.lib.nixGL.wrap pkgs.gg-jj)
    (pkgs.writeShellScriptBin "nixGL" ''
        exec nixGLIntel $@
    '')
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
