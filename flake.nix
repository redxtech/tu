{
  description = "A Lua-natic's neovim flake, with extra cats! nixCats!";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixCats.url = "github:BirdeeHub/nixCats-nvim";
    nix-appimage.url = "github:ralismark/nix-appimage";
    nix-appimage.inputs.nixpkgs.follows = "nixpkgs";
    nix-neovim-plugins.url = "github:NixNeovim/NixNeovimPlugins";
    nix-neovim-plugins.inputs.nixpkgs.follows = "nixpkgs";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    fenix.url = "github:nix-community/fenix";
    fenix.inputs.nixpkgs.follows = "nixpkgs";

    # non-nixpkgs plugins
    blink-cmp.url = "github:saghen/blink.cmp";
    blink-cmp.inputs.nixpkgs.follows = "nixpkgs";
    blink-nvim.url = "github:saghen/blink.nvim";
    blink-nvim.inputs.nixpkgs.follows = "nixpkgs";
    dracula.url = "github:redxtech/dracula.nvim";
    dracula.inputs.nixpkgs.follows = "nixpkgs";
    vtsls.url = "github:kuglimon/nixpkgs/vtsls";
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
            (utils.standardPluginOverlay inputs)
            inputs.nix-neovim-plugins.overlays.default
            inputs.fenix.overlays.default
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
        let
          inherit (pkgs) vimPlugins vimExtraPlugins nixCatsBuilds;
          # TODO: remove this when vtsls is merged into nixpkgs
          vtsls = inputs.vtsls.legacyPackages.${pkgs.system}.vtsls;
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
          propagatedBuildInputs = { core = with pkgs; [ libgit2 ]; };

          # lspsAndRuntimeDeps:
          # this section is for dependencies that should be available
          # at RUN TIME for plugins. Will be available to PATH within neovim terminal
          # this includes LSPs
          lspsAndRuntimeDeps = {
            ai = let
              inherit (pkgs) stdenv fetchurl;

              platform = if stdenv.isDarwin then "darwin" else "linux-musl";
              arch = if stdenv.isAarch64 then "aarch64" else "x86_64";
              version = "2/8";

              supermaven-agent = stdenv.mkDerivation {
                pname = "supermaven-agent";
                version = "2024-11-12";

                src = fetchurl {
                  url =
                    "https://supermaven-public.s3.amazonaws.com/sm-agent/v${version}/${platform}/${arch}/sm-agent";
                  hash = "sha256-lsaS7IoNQUIkTL1Qo+UymeD8y4eX4mPR6XFC2qMlp4g=";
                };

                dontUnpack = true;

                installPhase = ''
                  mkdir -p $out/bin

                  cp $src $out/bin/sm-agent
                  chmod +x $out/bin/sm-agent
                '';
              };
            in [ supermaven-agent ];
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
              nurl # get hash from nix url
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
            ];
            debug = with pkgs; [ gdb lldb ];
            fugit = with pkgs; [ gpgme libgit2 lua5_1 lua51Packages.luarocks ];
            git = with pkgs; [ git libgit2 ];
            langs = with pkgs; [
              # general
              dprint # formatter for many languages
              treefmt # multui-language format tool
              vscode-langservers-extracted # a bunch of language servers

              # cpp
              clang-tools
              gcc

              # deno
              deno

              # docker
              dockerfile-language-server-nodejs
              docker-compose-language-service
              hadolint

              # go
              go
              gopls
              golangci-lint

              # lua
              lua-language-server
              stylua

              # markdown
              markdownlint-cli
              marksman
              proselint

              # nix
              alejandra # very opinionated nix formatter
              nil
              nixfmt-classic
              statix

              # python
              basedpyright # fork of pyright
              black
              ruff
              # pyright
              python3Packages.debugpy

              # rust
              (fenix.complete.withComponents [
                "cargo"
                "clippy"
                "rust-src"
                "rustc"
                "rustfmt"
              ])
              rust-analyzer-nightly
              graphviz

              # shell
              shellcheck
              shellharden
              shfmt
              nodePackages.bash-language-server
              fish # for fish_indent

              # terraform
              terraform
              terraform-ls
              tflint

              # yaml
              yaml-language-server
              # ansible-language-server
              kubectl
              helm-ls

              # web
              biome
              eslint
              eslint_d
              prettierd
              nodePackages.prettier
              nodePackages.svelte-language-server
              typescript
              nodePackages.typescript-language-server
              nodePackages.graphql-language-service-cli
              fixjson
              # htmx-lsp
              tailwindcss-language-server
              vscode-extensions.vue.volar
              vtsls
              # inputs.vtsls.packages.${pkgs.system}.default

              # misc
              buf # protobuf utility
              buf-language-server # protobuf language server
              hyprls # hyprland language server
              taplo # toml toolkit
            ];

            appimage = with pkgs; [
              coreutils-full
              xclip
              wl-clipboard
              git
              nix
              curl
            ];
          };

          startupPlugins = with vimExtraPlugins; {
            core = [
              lazy-nvim # lazy package manager
              inputs.dracula.packages.${pkgs.system}.default # dracula theme
              dashboard-nvim # dashboard  TODO: move to lazy ?
              flatten-nvim # open nested nvim instances in current window
            ];

            profile = [ profile-nvim ];
          };

          # not loaded automatically at startup.
          optionalPlugins = with vimExtraPlugins; {
            core = [
              any-jump-vim # fallback goto when no lsp
              before-nvim # go to previous edit
              inputs.blink-cmp.packages.${pkgs.system}.default
              inputs.blink-nvim.packages.${pkgs.system}.default
              # Comment-nvim # commenting  TODO: is this needed?
              diagflow-nvim # show diagnostics in corner
              edgy-nvim # window management
              fidget-nvim # lsp status in bottom right
              flash-nvim # movement with s/S f/F
              friendly-snippets
              nixCatsBuilds.fzy-lua-native # native fzy
              incline-nvim # alternative to winbar
              inc-rename-nvim # visual rename variables with lsp
              instant-nvim # session sharing
              lazydev-nvim # load lua lsp faster
              lsp-lines-nvim # show lsp diagnostics as virtual text;
              mini-nvim # a bunch of minimal plugins
              neoscroll-nvim # smooth scrolling
              neovim-project # project list
              neovim-session-manager # session management (dep for neovim-project)
              noice-nvim # ui replacements
              none-ls-nvim # fallback lsp
              nui-nvim # ui library
              nvim-lspconfig # lsp configs
              nvim-navbuddy # navic based navigation
              nvim-navic # breadcrumbs provider
              nvim-notify # notifications
              nvim-numbertoggle # toggle line numbers automatically
              nvim-spectre # search and replace
              nvim-snippets
              vimPlugins.nvim-treesitter.withAllGrammars # syntax highlighting
              nvim-web-devicons # file icons
              plenary-nvim # lua helpers
              promise-async # async functions (dep for nvim-ufo)
              rainbow-delimiters-nvim # rainbow {}[]()
              satellite-nvim # scrollbar
              scrollofffraction-nvim # auto scrolloff size
              nixCatsBuilds.sharing-nvim # session sharing QoL
              smart-open-nvim # better file search
              sqlite-lua # sqlite bindings
              telescope-nvim # pickers
              telescope-repo-nvim # repo picker
              telescope-fzy-native-nvim
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

            ai = [ supermaven-nvim ];
            cmp = [ nvim-cmp LuaSnip cmp-luasnip cmp-nvim-lsp cmp-path ];
            debug = [ nvim-dap ];
            fugit = [
              # lazy
              diffview-nvim # git diff viewer
              dressing-nvim # ui lib (dep for overseer-nvim)
              fugit2-nvim # git client
              nvim-tinygit # github issue integration
            ];
            git = [
              diffview-nvim # git diff viewer
              gitsigns-nvim # git signs in gutter
              nixCatsBuilds.neogit # git integration
            ];
            langs = [
              # format wrapper plugin
              conform-nvim

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
            statusline = [
              lualine-nvim # statusline
              # vimPlugins.lualine-lsp-progress # lsp progress
            ];
            bufferline = [
              bufferline-nvim # bufferline
            ];
            utils = [
              better-escape-nvim # jk to escape insert mode
              dressing-nvim # ui lib (dep for overseer-nvim)
              goto-preview # preview definition in window
              nixCatsBuilds.markview-nvim # markdown preview
              vimPlugins.moveline-nvim # move blocks of text
              nix-develop-nvim # run `nix develop` without restarting neovim
              nixCatsBuilds.nix-reaver-nvim # update rev & hash of fetchFromGitHub
              numb-nvim # peek at line before jump
              nvim-colorizer-lua # colorize hex, rgb, etc. codes
              nvim-lightbulb # show code actions
              nvim-ufo # folds
              oil-nvim # tree explorer
              overseer-nvim # task runner integration
              promise-async # async functions (dep for nvim-ufo)
              screenkey-nvim # screenkey in neovim
              nixCatsBuilds.silicon-nvim # screenshot code
              nixCatsBuilds.smart-tab-nvim # tab on non-whitespace line jumps to end of blick
              nixCatsBuilds.tabs-vs-spaces-nvim # smart tab/spaces
              sort-nvim # sort lines
              url-open # open more urls
              vim-eunuch # unix tools
            ];
          };

          # shared libraries to be added to LD_LIBRARY_PATH
          # variable available to nvim runtime
          sharedLibraries = {
            core = with pkgs; [ libgit2 sqlite ];
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
          extraPython3Packages = { test = _: [ ]; };
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
            cmp = false;
            debug = false;
            fugit = true;
            git = true;
            langs = true;
            utils = true;
            profile = false;

            # ui elements
            colorscheme = "dracula";
            bufferline = true;
            statusline = true;
          };
        };
        tu-dev = { pkgs, ... }:
          let tuque = tu { inherit pkgs; };
          in {
            inherit (tuque) categories;
            settings = tuque.settings // {
              wrapRc = false;
              aliases = [ "tdev" ];
              unwrappedCfgDir = "~/Code/nvim/tu";
            };
          };
        tu-profile = { pkgs, ... }:
          let tuque = tu { inherit pkgs; };
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
            packages = builtins.map nixCatsBuilder [
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
        homeManagerModules.default = utils.mkHomeModules {
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
