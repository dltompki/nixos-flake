{
  inputs,
  pkgs,
  ...
}: {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "dylan";
  home.homeDirectory = "/home/dylan";
  xdg.configHome = "/home/dylan/.config/";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    obsidian
    vscode
    rbw
    rofi-rbw-wayland
    pinentry-qt
    nodejs_20
    kdePackages.qtwayland
    brightnessctl
    docker

    # https://nixos.wiki/wiki/LibreOffice
    libreoffice
    hunspell
    hunspellDicts.en_US

    ranger
    fzf

    xdg-desktop-portal-hyprland

    grim
    slurp

    obs-studio
    obs-studio-plugins.wlrobs
    mpv

    wl-mirror

    alejandra

    feh

    racket

    neovide

    localsend

    gradle

    taskwarrior3
    taskwarrior-tui

    thunderbird

    hoppscotch

    zoom-us

    cargo

    jetbrains.idea-ultimate
    jetbrains.webstorm
    keepass #trying to store github creds

    slack

    flameshot

    awscli2

    discord

    prismlauncher

    zellij

    inputs.zen-browser.packages."${system}".default

    texliveFull

    firefoxpwa
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
    ".config/waybar/config".source = dotfiles/waybar.json;

    ".config/rofi/config.rasi".source = dotfiles/rofi/config.rasi;
    ".config/rofi/current.rasi".source = dotfiles/rofi/current.rasi;
    ".config/flameshot/flameshot.ini".source = dotfiles/flameshot.ini;
    ".config/zellij/config.kdl".source = dotfiles/zellij-config.kdl;
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/dylan/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting
      zoxide init --cmd cd fish | source
    '';
    shellAliases = {
      lg = "lazygit";
    };
    functions = {
      nix-rebuild = builtins.readFile ./dotfiles/nix-rebuild.fish;
      amplify = builtins.readFile ./dotfiles/amplify.fish;
    };
  };

  programs.nixvim = {
    enable = true;

    extraPackages = with pkgs; [
      alejandra
      prettierd
      ripgrep # for telescope.nvim
    ];

    extraPlugins = with pkgs.vimPlugins; [
      everforest
      friendly-snippets
    ];
    colorscheme = "everforest";

    clipboard = {
      register = "unnamedplus";
      providers.wl-copy.enable = true;
    };

    plugins = {
      alpha = {
        enable = true;
        theme = "dashboard";
      };
      vimtex = {
        enable = true;
        texlivePackage = null;
      };
      treesitter.enable = true;
      bufferline.enable = true;
      cmp = {
        enable = true;
        settings = {
          sources = [
            {name = "nvim_lsp";}
            {name = "buffer";}
            {name = "path";}
            {name = "luasnip";}
          ];
          mapping = {
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
          };
          snippet.expand = ''
            function(args)
              require('luasnip').lsp_expand(args.body)
            end
          '';
        };
      };
      lsp = {
        enable = true;
        servers = {
          ltex.enable = true;
          ts_ls.enable = true;
          eslint.enable = true;
          nil_ls.enable = true;
        };
      };
      luasnip = {
        enable = true;
        fromVscode = [{}];
      };
      oil.enable = true;
      which-key.enable = true;
      lualine.enable = true;
      conform-nvim = {
        enable = true;
        settings = {
          formatters_by_ft = {
            tex = ["latexindent"];
            nix = ["alejandra"];
            typescript = ["prettierd"];
            typescriptreact = ["prettierd"];
            javascript = ["prettierd"];
            javascriptreact = ["prettierd"];
            markdown = ["prettierd"];
            racket = ["racket_fmt"];
          };
          format_on_save = {
            lsp_format = "fallback";
          };
          formatters = {
            racket_fmt = {
              command = "/etc/profiles/per-user/dylan/bin/raco";
              args = ["fmt" "--width" "90"];
              stdin = true;
            };
          };
        };
      };
      gitgutter.enable = true;
      toggleterm.enable = true;
      autoclose.enable = true;
      telescope = {
        enable = true;
        extensions = {
          fzf-native.enable = true;
        };
        keymaps = {
          "<Leader>fg" = "live_grep";
          "<Leader>ff" = "find_files";
          "<Leader>fb" = "buffers";
          "<Leader>fh" = "help_tags";
        };
      };
      web-devicons.enable = true;
    };

    opts = {
      number = true;
      relativenumber = true;
      tabstop = 2;
      shiftwidth = 2;
      expandtab = true;
      fillchars.eob = " ";
      ignorecase = true;
      wrap = false;
      guifont = "FiraCode Nerd Font:h11";
    };

    globals = {
      mapleader = " ";
      neovide_opacity = 0.9;
    };

    extraConfigLuaPost = ''
      local Terminal  = require('toggleterm.terminal').Terminal

      local lazygit = Terminal:new({
        cmd = "lazygit",
        dir = "git_dir",
        direction = "float",
        float_opts = {
          border = "curved",
        },
        -- function to run on opening the terminal
        on_open = function(term)
          vim.cmd("startinsert!")
          vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", {noremap = true, silent = true})
        end,
        -- function to run on closing the terminal
        on_close = function(term)
          vim.cmd("startinsert!")
        end,
      })

      function _lazygit_toggle()
        lazygit:toggle()
      end

      vim.api.nvim_set_keymap("n", "<leader>tg", "<cmd>lua _lazygit_toggle()<CR>", {noremap = true, silent = true})
    '';

    keymaps = [
      {
        mode = "t";
        key = "<S-Esc>";
        action = "<C-\\><C-n>";
      }
      {
        key = "<Leader>e";
        action = "<Cmd>Oil<CR>";
        options = {
          desc = "Toggle File Explorer";
        };
      }
      {
        key = "<Leader>bb";
        action = "<Cmd>BufferLinePick<CR>";
        options = {
          desc = "Pick Tab";
        };
      }
      {
        key = "<Leader>bc";
        action = "<Cmd>BufferLinePickClose<CR>";
        options = {
          desc = "Close Tab";
        };
      }
      {
        key = "<Esc>";
        mode = "n";
        action = "<Cmd>noh<CR>";
      }
      {
        key = "<Leader>r";
        action = ''<Cmd>TermExec cmd="raco cover % && echo === === === && racket %"<CR>'';
      }
      {
        key = "<Leader>ca";
        action = ''<cmd>lua vim.lsp.buf.code_action()<CR>'';
        options = {
          desc = "LSP Code Action";
        };
      }
      {
        key = "<Leader>cr";
        action = ''<cmd>lua vim.lsp.buf.rename()<CR>'';
        options = {
          desc = "LSP Rename";
        };
      }
      {
        key = "<Leader>cd";
        action = ''<cmd>lua vim.diagnostic.open_float()<CR>'';
        options = {
          desc = "Show Diagnostic";
        };
      }
    ];

    autoCmd = [
      {
        event = "FileType";
        pattern = "gitcommit";
        command = "lua vim.diagnostic.disable(0)";
      }
    ];
  };

  programs.zathura = {
    enable = true;
    options = {
      selection-clipboard = "clipboard";
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    settings = {
      monitor = [
        "desc:Lenovo Group Limited LEN P32p-20 VNA83LFH,preferred,auto,1.5"
        "desc:Lenovo Group Limited LEN P32p-20 VNA5WK47,preferred,auto,1.5"
        "desc:LG Electronics LG ULTRAWIDE 201NTLEK6552,preferred,-3440x0,1"
        "desc:Chimei Innolux Corporation 0x152A,preferred,0x0,1.25"
        ",preferred,auto,auto"
      ];

      # unscale xwayland to make not pixelated
      xwayland = {
        force_zero_scaling = true;
      };

      env = [
        # independent toolkit scaling vars
        "XCURSOR_SIZE,24"
        # from nvidia section of hyprland wiki
        "LIBVA_DRIVER_NAME,nvidia"
        "XDG_SESSION_TYPE,wayland"
        "GBM_BACKEND,nvidia-drm"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
      ];

      exec-once = [
        "waybar &"
        "hyprpaper &"
        "dunst &"
        "lxqt-policykit-agent"
      ];

      input = {
        kb_layout = "us";

        follow_mouse = 1;

        touchpad = {
          natural_scroll = "no";
          scroll_factor = 0.2;
        };

        sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
      };

      cursor = {
        no_hardware_cursors = 1;
      };

      general = {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more

        gaps_in = 5;
        gaps_out = 20;
        border_size = 2;
        "col.active_border" = "rgba(7FBBB3ee) rgba(83C092ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";

        layout = "master";
      };

      decoration = {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more

        rounding = 10;
      };

      animations = {
        enabled = "yes";

        # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      dwindle = {
        # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
        pseudotile = "yes"; # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
        preserve_split = "yes"; # you probably want this
      };

      master = {
        # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
        new_status = "master";
      };

      gestures = {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more
        workspace_swipe = "off";
      };

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
      };

      # Example per-device config
      # See https://wiki.hyprland.org/Configuring/Keywords/#executing for more
      #"device:epic-mouse-v1 = {
      #    sensitivity = -0.5;
      #};

      # Example windowrule v1
      # windowrule = float, ^(kitty)$
      # Example windowrule v2
      # windowrulev2 = float,class:^(kitty)$,title:^(kitty)$
      # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
      windowrulev2 = [
        "float,title:rofi.*"
        "suppressevent maximize,class:.*"
      ];

      # See https://wiki.hyprland.org/Configuring/Keywords/ for more
      "$mainMod" = "SUPER";

      # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
      bind = [
        "$mainMod, Q, exec, wezterm"
        ''$mainMod, S, exec, rofi-rbw --typing-key-delay 1 --selector-args \"-normal-window\"''
        "$mainMod, C, killactive, "
        "$mainMod, M, exit, "
        "$mainMod, E, exec, dolphin"
        "$mainMod, V, togglefloating, "
        "$mainMod, R, exec, rofi -normal-window -show drun"
        "$mainMod, W, exec, swaylock"
        "$mainMod, P, pseudo, # dwindle"
        "$mainMod, J, togglesplit, # dwindle"
        "$mainMod, O, layoutmsg, orientationcycle left center"

        # Move focus with mainMod + arrow keys
        "$mainMod, J, layoutmsg, cyclenext"
        "$mainMod, K, layoutmsg, cycleprev"
        "$mainMod, L, layoutmsg, swapnext"
        "$mainMod, H, layoutmsg, swapprev"

        # Switch workspaces with mainMod + [0-9]
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"

        # Move active window to a workspace with mainMod + SHIFT + [0-9]
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"

        # Scroll through existing workspaces with mainMod + scroll
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"

        # Screenshot
        ''$mainMod SHIFT, S, exec, grim -g "$(slurp)"''
      ];

      debug = {
        disable_logs = false;
      };

      # Move/resize windows with mainMod + LMB/RMB and dragging
      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];
    };
  };
  programs.waybar.enable = true;

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.wezterm = {
    enable = true;
    extraConfig = builtins.readFile ./dotfiles/wezterm.lua;
    package = inputs.wezterm.packages.${pkgs.system}.default;
  };

  home.pointerCursor = {
    gtk.enable = true;
    size = 32;

    name = "phinger-cursors-dark";
    package = pkgs.phinger-cursors;
  };

  gtk = {
    enable = true;
    theme = {
      name = "WhiteSur-Dark";
      package = pkgs.whitesur-gtk-theme;
    };
    iconTheme = {
      name = "WhiteSur";
      package = pkgs.whitesur-icon-theme;
    };
  };

  qt.platformTheme = "gtk";

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf" = ["org.pwmt.zathura.desktop"];
      "x-scheme-handler/http" = "zen-browser.desktop";
      "x-scheme-handler/https" = "zen-browser.desktop";
      "text/html" = "zen-browser.desktop";
    };
  };

  services.gnome-keyring.enable = true;

  programs.firefox = {
    enable = true;
    nativeMessagingHosts = [pkgs.firefoxpwa];
  };
}
