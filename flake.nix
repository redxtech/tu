# Copyright (c) 2023 BirdeeHub
# Licensed under the MIT license

# This is an empty nixCats config.
# you may import this template directly into your nvim folder
# and then add plugins to categories here,
# and call the plugins with their default functions
# within your lua, rather than through the nvim package manager's method.
# Use the help, and the example repository https://github.com/BirdeeHub/nixCats-nvim

# It allows for easy adoption of nix,
# while still providing all the extra nix features immediately.
# Configure in lua, check for a few categories, set a few settings,
# output packages with combinations of those categories and settings.

# All the same options you make here will be automatically exported in a form available
# in home manager and in nixosModules, as well as from other flakes.
# each section is tagged with its relevant help section.

{
  description = "A Lua-natic's neovim flake, with extra cats! nixCats!";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixCats.url = "github:BirdeeHub/nixCats-nvim";
    nixCats.inputs.nixpkgs.follows = "nixpkgs";
    nix-appimage.url = "github:ralismark/nix-appimage";
    nix-appimage.inputs.nixpkgs.follows = "nixpkgs";
    nix-neovim-plugins.url = "github:NixNeovim/NixNeovimPlugins";
    nix-neovim-plugins.inputs.nixpkgs.follows = "nixpkgs";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    # see :help nixCats.flake.inputs
    # If you want your plugin to be loaded by the standard overlay,
    # i.e. if it wasnt on nixpkgs, but doesnt have an extra build step.
    # Then you should name it "plugins-something"
    # If you wish to define a custom build step not handled by nixpkgs,
    # then you should name it in a different format, and deal with that in the
    # overlay defined for custom builds in the overlays directory.
    # for specific tags, branches and commits, see:
    # https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-flake.html#examples

    # non-nixpkgs plugins
    blink-cmp.url = "github:saghen/blink.cmp";
    blink-cmp.inputs.nixpkgs.follows = "nixpkgs";
    blink-nvim.url = "github:saghen/blink.nvim";
    blink-nvim.inputs.nixpkgs.follows = "nixpkgs";
    dracula.url = "github:redxtech/dracula.nvim";
    dracula.inputs.nixpkgs.follows = "nixpkgs";
    moveline.url = "github:redxtech/moveline.nvim";
    moveline.inputs.nixpkgs.follows = "nixpkgs";
    vtsls.url = "github:redxtech/vtsls";
    vtsls.inputs.nixpkgs.follows = "nixpkgs";
  };

  # see :help nixCats.flake.outputs
  outputs = { self, nixpkgs, nixCats, ... }@inputs:
    let
      inherit (nixCats) utils;
      luaPath = "${./.}";
      forEachSystem = utils.eachSystem nixpkgs.lib.platforms.all;
      extra_pkg_config.allowUnfree = true;
      # sometimes our overlays require a ${system} to access the overlay.
      # management of this variable is one of the harder parts of using flakes.

      # so I have done it here in an interesting way to keep it out of the way.

      # First, we will define just our overlays per system.
      # later we will pass them into the builder, and the resulting pkgs set
      # will get passed to the categoryDefinitions and packageDefinitions
      # which follow this section.

      # this allows you to use ${pkgs.system} whenever you want in those sections
      # without fear.
      inherit (forEachSystem (system:
        let
          # see :help nixCats.flake.outputs.overlays
          dependencyOverlays = (import ./overlays inputs) ++ [
            # This overlay grabs all the inputs named in the format
            # `plugins-<pluginName>`
            # Once we add this overlay to our nixpkgs, we are able to
            # use `pkgs.neovimPlugins`, which is a set of our plugins.
            (utils.standardPluginOverlay inputs)
            # add any flake overlays here.
            inputs.nix-neovim-plugins.overlays.default
          ];
          # these overlays will be wrapped with ${system}
          # and we will call the same utils.eachSystem function
          # later on to access them.
        in { inherit dependencyOverlays; }))
        dependencyOverlays;

      # see :help nixCats.flake.outputs.categories
      # and
      # :help nixCats.flake.outputs.categoryDefinitions.scheme
      categoryDefinitions =
        { pkgs, settings, categories, name, ... }@packageDef:
        let inherit (pkgs) vimPlugins vimExtraPlugins nixCatsBuilds;
        in {
          # to define and use a new category, simply add a new list to a set here, 
          # and later, you will include categoryname = true; in the set you
          # provide when you build the package using this builder function.
          # see :help nixCats.flake.outputs.packageDefinitions for info on that section.

          # propagatedBuildInputs:
          # this section is for dependencies that should be available
          # at BUILD TIME for plugins. WILL NOT be available to PATH
          # However, they WILL be available to the shell 
          # and neovim path when using nix develop
          propagatedBuildInputs = {
            core = with pkgs; [ libgit2 ];
            # blink = with pkgs; [ inputs.blink-nvim.packages.${system}.default ];
          };

          # lspsAndRuntimeDeps:
          # this section is for dependencies that should be available
          # at RUN TIME for plugins. Will be available to PATH within neovim terminal
          # this includes LSPs
          lspsAndRuntimeDeps = {
            core = with pkgs; [
              curl
              git
              fd
              fzy
              ripgrep
              gnused
              gnutar
              gnumake
              nix-doc
              sqlite
              stdenv.cc.cc
              trashy
              tree-sitter
              wl-clipboard
              xclip
              xdg-utils
              zoxide

              lua51Packages.luarocks # use jit ?
              lua51Packages.jsregexp # do i need this?

              # lsp
            ];
            blink = with pkgs; [ libgit2 ];
            format = with pkgs; [ biome efm-langserver prettierd stylua ];
            fugit = with pkgs; [ gpgme libgit2 lua5_1 lua51Packages.luarocks ];
            git = with pkgs; [ git ];
            langs = with pkgs; [
              # cpp
              clang-tools
              gcc
              gdb
              lldb

              # go
              go
              gopls

              # lua
              lua-language-server
              stylua

              # nix
              nil # language server
              nurl # get hash from nix url
              nixfmt-classic

              # python
              black
              ruff-lsp
              python3Packages.debugpy
              pyright

              # rust
              # TODO: use nightly
              cargo
              rustfmt
              rust-analyzer
              graphviz

              # shell
              shellcheck
              shfmt
              nodePackages.bash-language-server

              # terraform
              terraform
              terraform-ls
              tflint

              # yaml
              yaml-language-server
              ansible-language-server
              kubectl
              helm-ls
              dockerfile-language-server-nodejs
              docker-compose-language-service
              hadolint

              # web
              biome
              deno
              nodePackages.eslint
              prettierd
              nodePackages.svelte-language-server
              typescript
              nodePackages.typescript-language-server
              tailwindcss-language-server
              vscode-extensions.vue.volar
              inputs.vtsls.packages.${pkgs.system}.default

              # formatting
              efm-langserver
            ];
            lint = with pkgs; [ markdownlint-cli eslint ];
            utils = with pkgs; [ glow ];

            appimage = with pkgs; [
              coreutils-full
              xclip
              wl-clipboard
              git
              nix
              curl
            ];
          };

          startupPlugins = {
            core = with vimExtraPlugins;
              with nixCatsBuilds; [
                lazy-nvim # lazy package manager
                inputs.dracula.packages.${pkgs.system}.default # dracula theme
                dashboard-nvim # dashboard  TODO: move to lazy ?
                flatten-nvim # open nested nvim instances in current window
              ];

            profile = with nixCatsBuilds; [ profile-nvim ];
          };

          # not loaded automatically at startup.
          optionalPlugins = {
            core = with vimExtraPlugins;
              with nixCatsBuilds; [
                any-jump-vim # fallback goto when no lsp
                barbecue-nvim # bufferline breadcrumbs
                before-nvim # go to previous edit
                # Comment-nvim # commenting  TODO: is this needed?
                diagflow-nvim # show diagnostics in corner
                vimPlugins.edgy-nvim # window management
                fidget-nvim # lsp status in bottom right
                flash-nvim # movement with s/S f/F
                fzy-lua-native # native fzy
                incline-nvim # alternative to winbar
                inc-rename-nvim # visual rename variables with lsp
                lazydev-nvim # load lua lsp faster
                lsp-lines-nvim # show lsp diagnostics as virtual text;
                mini-nvim # a bunch of minimal plugins
                neovim-project # project list
                neovim-session-manager # session management (dep for neovim-project)
                noice-nvim # ui replacements
                none-ls-nvim # fallback lsp
                nui-nvim # ui library
                nvim-lspconfig # lsp configs
                nvim-navbuddy # navic based navigation
                nvim-navic # breadcrumbs provider
                nvim-numbertoggle # toggle line numbers automatically
                nvim-spectre # search and replace
                vimPlugins.nvim-treesitter.withAllGrammars # syntax highlighting
                nvim-web-devicons # file icons
                plenary-nvim # lua helpers
                promise-async # async functions (dep for nvim-ufo)
                rainbow-delimiters-nvim # rainbow {}[]()
                smart-open-nvim # better file search
                sqlite-lua # sqlite bindings
                telescope-nvim # pickers
                telescope-repo-nvim # repo picker
                vimPlugins.telescope-fzy-native-nvim
                telescope-zoxide # zoxide integration
                tiny-devicons-auto-colors-nvim # colour devicons with theme colors
                todo-comments-nvim # highlight TODOs, FIXMEs, etc.
                toggleterm-nvim # toggleable terminal
                treesj # splits and joins
                trouble-nvim # quickfix and location list
                which-key-nvim # show keymaps

                # alternate themes
                onedark-nvim
                tokyonight-nvim
              ];

            ai = [ vimPlugins.supermaven-nvim ];
            blink = [
              inputs.blink-cmp.packages.${pkgs.system}.default
              inputs.blink-nvim.packages.${pkgs.system}.default
              # lazy
              vimPlugins.nvim-snippets
              vimExtraPlugins.friendly-snippets
            ];
            cmp = with vimExtraPlugins; [
              nvim-cmp
              LuaSnip
              cmp-luasnip
              cmp-nvim-lsp
              cmp-path
            ];
            debug = with vimExtraPlugins; [ nvim-dap ];
            format = with vimExtraPlugins;
              [
                conform-nvim # format  TODO: setup
              ];
            fugit = with vimExtraPlugins;
              with nixCatsBuilds; [
                # lazy
                diffview-nvim # git diff viewer
                dressing-nvim # ui lib (dep for overseer-nvim)
                fugit2-nvim # git client
                nvim-tinygit # github issue integration
                nui-nvim # ui library
              ];
            git = with vimPlugins;
              with vimExtraPlugins; [
                diffview-nvim # git diff viewer
                gitsigns-nvim # git signs in gutter
                neogit # git integration
              ];
            langs = with vimPlugins;
              with vimExtraPlugins;
              with nixCatsBuilds; [
                # format tool
                efmls-configs-nvim

                # lua
                luvit-meta

                # python
                venv-selector-nvim

                # rust
                rustaceanvim

                # yaml
                vim-helm
                yaml-companion-nvim

                # web
                nvim-ts-autotag
                nvim-vtsls
                tsc-nvim
              ];
            statusline = with vimExtraPlugins;
              [
                lualine-nvim # statusline
                # vimPlugins.lualine-lsp-progress # lsp progress
              ];
            bufferline = with vimExtraPlugins;
              [
                bufferline-nvim # bufferline
              ];
            utils = with vimExtraPlugins; [
              better-escape-nvim # jk to escape insert mode
              dressing-nvim # ui lib (dep for overseer-nvim)
              glow-nvim # markdown preview
              goto-preview # preview definition in window
              nvim-lightbulb # show code actions
              inputs.moveline.packages.${pkgs.system}.default # move blocks of text
              numb-nvim # peek at line before jump
              nvim-colorizer-lua # colorize hex, rgb, etc. codes
              nvim-ufo # folds
              overseer-nvim # task runner integration
              promise-async # async functions (dep for nvim-ufo)
              sort-nvim # sort lines
              url-open # open more urls
              vimPlugins.vim-eunuch # unix tools
            ];
          };

          # shared libraries to be added to LD_LIBRARY_PATH
          # variable available to nvim runtime
          sharedLibraries = {
            core = with pkgs; [
              libgit2
              sqlite
              # inputs.blink-nvim.packages.${pkgs.system}.default
            ];

            fugit = with pkgs; [ gpgme libgit2 ];
          };

          # environmentVariables:
          # this section is for environmentVariables that should be available
          # at RUN TIME for plugins. Will be available to path within neovim terminal
          environmentVariables = {
            fugit = {
              GIT2_DIR = "${pkgs.libgit2}";
              GIT2_LIBDIR = "${pkgs.libgit2.lib}";
            };
            profile.NVIM_PROFILE = "start";
            test.CATTESTVAR = "It worked!";
          };

          # If you know what these are, you can provide custom ones by category here.
          # If you dont, check this link out:
          # https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/setup-hooks/make-wrapper.sh
          extraWrapperArgs = {
            # test = [ ''--set CATTESTVAR2 "It worked again!"'' ];
          };

          # lists of the functions you would have passed to
          # python.withPackages or lua.withPackages

          # get the path to this python environment
          # in your lua config via
          # vim.g.python3_host_prog
          # or run from nvim terminal via :!<packagename>-python3
          extraPython3Packages = { test = (_: [ ]); };
          # populates $LUA_PATH and $LUA_CPATH
          extraLuaPackages = {
            core = [ (luaPkgs: with luaPkgs; [ fzy ]) ];
            test = [ (_: [ ]) ];
          };
        };

      # And then build a package with specific categories from above here:
      # All categories you wish to include must be marked true,
      # but false may be omitted.
      # This entire set is also passed to nixCats for querying within the lua.

      # see :help nixCats.flake.outputs.packageDefinitions
      packageDefinitions = rec {
        # These are the names of your packages
        # you can include as many as you wish.
        tu = { pkgs, ... }: {
          # they contain a settings set defined above
          # see :help nixCats.flake.outputs.settings
          settings = {
            wrapRc = true;
            # IMPORTANT:
            # you may not alias to nvim
            # your alias may not conflict with your other packages.
            aliases = [ "tuque" "vim" ];
            # caution: this option must be the same for all packages.
            # or at least, all packages that are to be installed simultaneously.
            # neovim-unwrapped = inputs.neovim-nightly-overlay.packages.${pkgs.system}.neovim;

            configDirName = "tu";

            withNodeJs = true;
            withRuby = true;
            withPython3 = true;
          };
          # and a set of categories that you want
          # (and other information to pass to lua)
          categories = {
            core = true;

            ai = true;
            blink = true;
            cmp = false;
            debug = false;
            # format = true;
            fugit = true;
            git = true;
            langs = true;
            utils = true;
            # profile = false;

            # ui elements
            colorscheme = "dracula";
            bufferline = true;
            statusline = true;
            uiElements = {
              barbecue = false;
              incline = true;
            };
          };
        };
        tu-dev = { pkgs, ... }:
          let tuque = tu { inherit pkgs; };
          in {
            inherit (tuque) categories;
            settings = {
              wrapRc = false;
              aliases = [ "tdev" ];
              unwrappedCfgDir = "~/Code/nvim/tu";
            };
          };
        tu-profile = { pkgs, ... }:
          let tuque = tuque { inherit pkgs; };
          in {
            settings = tuque.settings // { aliases = [ "tup" ]; };
            categories = tuque.categories // { profile = true; };
          };
      };
      # In this section, the main thing you will need to do is change the default package name
      # to the name of the packageDefinitions entry you wish to use as the default.
      defaultPackageName = "tu";

      # see :help nixCats.flake.outputs.exports
    in forEachSystem (system:
      let
        inherit (utils) baseBuilder;
        customPackager = baseBuilder luaPath {
          inherit nixpkgs system dependencyOverlays extra_pkg_config;
        } categoryDefinitions;
        nixCatsBuilder = customPackager packageDefinitions;
        # this is just for using utils such as pkgs.mkShell
        # The one used to build neovim is resolved inside the builder
        # and is passed to our categoryDefinitions and packageDefinitions
        pkgs = import nixpkgs { inherit system; };
      in {
        # these outputs will be wrapped with ${system} by utils.eachSystem

        app-images = {
          default = inputs.nix-appimage.bundlers.${system}.default
            (nixCatsBuilder "tu");
        };

        # this will make a package out of each of the packageDefinitions defined above
        # and set the default package to the one named here.
        packages =
          utils.mkPackages nixCatsBuilder packageDefinitions defaultPackageName;

        # choose your package for devShell
        # and add whatever else you want in it.
        devShells = {
          default = pkgs.mkShell {
            name = defaultPackageName;
            packages = builtins.map (name: nixCatsBuilder name) [
              defaultPackageName
              "tu-dev"
              "tu-profile"
            ];
            inputsFrom = [ ];
            shellHook = ''
              alias build-appimage="nix build .#app-images.default"
            '';
          };
        };

        # To choose settings and categories from the flake that calls this flake.
        # and you export overlays so people dont have to redefine stuff.
        inherit customPackager;
      }) // {

        # these outputs will be NOT wrapped with ${system}

        # this will make an overlay out of each of the packageDefinitions defined above
        # and set the default overlay to the one named here.
        overlays = utils.makeOverlays luaPath {
          # we pass in the things to make a pkgs variable to build nvim with later
          inherit nixpkgs dependencyOverlays extra_pkg_config;
          # and also our categoryDefinitions
        } categoryDefinitions packageDefinitions defaultPackageName;

        # we also export a nixos module to allow configuration from configuration.nix
        nixosModules.default = utils.mkNixosModules {
          inherit defaultPackageName dependencyOverlays luaPath
            categoryDefinitions packageDefinitions nixpkgs;
        };
        # and the same for home manager
        homeModule = utils.mkHomeModules {
          inherit defaultPackageName dependencyOverlays luaPath
            categoryDefinitions packageDefinitions nixpkgs;
        };
        # now we can export some things that can be imported in other
        # flakes, WITHOUT needing to use a system variable to do it.
        # and update them into the rest of the outputs returned by the
        # eachDefaultSystem function.
        inherit utils categoryDefinitions packageDefinitions dependencyOverlays;
        inherit (utils) templates baseBuilder;
        keepLuaBuilder = utils.baseBuilder luaPath;
      };

}
