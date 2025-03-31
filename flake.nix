{
  description = "My neovim flake, fully nix-ed out!";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixCats.url = "github:BirdeeHub/nixCats-nvim";

    nix-neovim-plugins.url = "github:NixNeovim/NixNeovimPlugins";
    nix-neovim-plugins.inputs.nixpkgs.follows = "nixpkgs";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    fenix.url = "github:nix-community/fenix";
    fenix.inputs.nixpkgs.follows = "nixpkgs";

    # blink plugins
    blink-cmp.url = "github:saghen/blink.cmp";
    blink-pairs.url = "github:saghen/blink.pairs";
    blink-nvim.url = "github:saghen/blink.nvim";

    # non-nixpkgs plugins
    dracula.url = "github:redxtech/dracula.nvim";
    dracula.inputs.nixpkgs.follows = "nixpkgs";
  };

  # see :help nixCats.flake.outputs
  outputs = { self, nixpkgs, nixCats, ... }@inputs:
    let
      inherit (nixCats) utils;
      luaPath = "${./.}";
      forEachSystem = utils.eachSystem nixpkgs.lib.platforms.all;
      extra_pkg_config.allowUnfree = true;
      # management of the system variable is one of the harder parts of using flakes.

      # so I have done it here in an interesting way to keep it out of the way.
      # It gets resolved within the builder itself, and then passed to your
      # categoryDefinitions and packageDefinitions.

      # this allows you to use ${pkgs.system} whenever you want in those sections
      # without fear.

      dependencyOverlays = (import ./nix/overlays inputs) ++ [
        (utils.standardPluginOverlay inputs)
        inputs.nix-neovim-plugins.overlays.default
        inputs.fenix.overlays.default

        # when other people mess up their overlays by wrapping them with system,
        # you may instead call this function on their overlay.
        # it will check if it has the system in the set, and if so return the desired overlay
        # (utils.fixSystemizedOverlay inputs.codeium.overlays
        #   (system: inputs.codeium.overlays.${system}.default)
        # )
      ];

      # see :help nixCats.flake.outputs.categories
      # and
      # :help nixCats.flake.outputs.categoryDefinitions.scheme
      categoryDefinitions =
        { pkgs, settings, categories, extra, name, ... }@packageDef:
        let
          inherit (pkgs) vimPlugins vimExtraPlugins nixCatsBuilds;
          mkNamed = name: plugin: { inherit plugin name; };
        in {
          # to define and use a new category, simply add a new list to a set here, 
          # and later, you will include categoryname = true; in the set you
          # provide when you build the package using this builder function.
          # see :help nixCats.flake.outputs.packageDefinitions for info on that section.

          # lspsAndRuntimeDeps:
          # this section is for dependencies that should be available
          # at RUN TIME for plugins. Will be available to PATH within neovim terminal
          # this includes LSPs
          lspsAndRuntimeDeps = with pkgs; {
            core = [
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
              universal-ctags
              wl-clipboard
              xclip
              xdg-utils
              zoxide

              # NOTE:
              # lazygit
              # Apparently lazygit when launched via snacks cant create its own config file
              # but we can add one from nix!
              (pkgs.writeShellScriptBin "lazygit" ''
                exec ${pkgs.lazygit}/bin/lazygit --use-config-file ${
                  pkgs.writeText "lazygit_config.yml" ""
                } "$@"
              '')

              lua51Packages.luarocks # use jit ?
              lua51Packages.jsregexp # do i need this?
            ];

            ai = let supermaven-agent = pkgs.callPackage ./nix/supermaven { };
            in [ supermaven-agent ];
            debug = with pkgs; [ gdb lldb ];
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

              # elixir
              elixir
              lexical

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
              # nodePackages.graphql-language-service-cli
              fixjson
              # htmx-lsp
              tailwindcss-language-server
              vscode-extensions.vue.volar
              vtsls

              # misc
              buf # protobuf utility & language server
              hyprls # hyprland language server
              taplo # toml toolkit
            ];
          };

          # startupPlugins = with pkgs.vimPlugins; {
          startupPlugins = with vimExtraPlugins; {
            core = [
              (mkNamed "lazy.nvim" lazy-nvim)
              (mkNamed "dracula.nvim"
                inputs.dracula.packages.${pkgs.system}.default)
              (mkNamed "flatten.nvim"
                flatten-nvim) # open nested nvim instances in current window
              dashboard-nvim # dashboard
            ];

            profile = [ (mkNamed "profile.nvim" profile-stevearc) ];
          };

          optionalPlugins = with vimExtraPlugins; {
            core = [
              (mkNamed "any-jump.vim" any-jump-vim) # fallback goto when no lsp
              (mkNamed "before.nvim" before-nvim) # go to previous edit
              (mkNamed "blink.cmp"
                inputs.blink-cmp.packages.${pkgs.system}.default)
              (mkNamed "blink.nvim"
                inputs.blink-nvim.packages.${pkgs.system}.default)
              (mkNamed "blink.pairs"
                inputs.blink-pairs.packages.${pkgs.system}.default)
              # Comment-nvim # commenting  TODO: is this needed?
              (mkNamed "diagflow.nvim"
                diagflow-nvim) # show diagnostics in corner
              (mkNamed "edgy.nvim" edgy-nvim) # window management
              (mkNamed "fidget.nvim" fidget-nvim) # lsp status in bottom right
              (mkNamed "flash.nvim" flash-nvim) # movement with s/S f/F
              friendly-snippets
              nixCatsBuilds.fzy-lua-native # native fzy
              (mkNamed "incline.nvim" incline-nvim) # alternative to winbar
              (mkNamed "inc-rename.nvim"
                inc-rename-nvim) # visual rename variables with lsp
              (mkNamed "instant.nvim" instant-nvim) # session sharing
              (mkNamed "lazydev.nvim" lazydev-nvim) # load lua lsp faster
              (mkNamed "lsp_lines.nvim"
                nixCatsBuilds.lsp-lines-nvim) # show lsp diagnostics as virtual text;
              (mkNamed "mini.nvim" mini-nvim) # a bunch of minimal plugins
              (mkNamed "neoscroll.nvim" neoscroll-nvim) # smooth scrolling
              neovim-project # project list
              neovim-session-manager # session management (dep for neovim-project)
              (mkNamed "noice.nvim" noice-nvim) # ui replacements
              (mkNamed "none-ls.nvim" none-ls-nvim) # fallback lsp
              (mkNamed "nui.nvim" nui-nvim) # ui library
              nvim-lspconfig # lsp configs
              nvim-navbuddy # navic based navigation
              nvim-navic # breadcrumbs provider
              nvim-notify # notifications
              nvim-numbertoggle # toggle line numbers automatically
              nvim-spectre # search and replace
              nvim-snippets
              vimPlugins.nvim-treesitter-textobjects
              vimPlugins.nvim-treesitter.withAllGrammars # syntax highlighting
              nvim-web-devicons # file icons
              (mkNamed "plenary.nvim" plenary-nvim) # lua helpers
              promise-async # async functions (dep for nvim-ufo)
              (mkNamed "satellite.nvim" satellite-nvim) # scrollbar
              (mkNamed "scrollofffraction.nvim"
                scrollofffraction-nvim) # auto scrolloff size
              (mkNamed "sharing.nvim"
                nixCatsBuilds.sharing-nvim) # session sharing QoL
              (mkNamed "smart-open.nvim" smart-open-nvim) # better file search
              (mkNamed "sqlite.lua" sqlite-lua) # sqlite bindings
              (mkNamed "telescope.nvim" telescope-nvim) # pickers
              (mkNamed "telescope-repo.nvim" telescope-repo-nvim) # repo picker
              (mkNamed "telescope-fzy-native.nvim" telescope-fzy-native-nvim)
              telescope-zoxide # zoxide integration
              (mkNamed "tiny-devicons-auto-colors.nvim"
                tiny-devicons-auto-colors-nvim) # colour devicons with theme colors;
              (mkNamed "todo-comments.nvim"
                todo-comments-nvim) # highlight TODOs, FIXMEs, etc.
              (mkNamed "toggleterm.nvim" toggleterm-nvim) # toggleable terminal
              treesj # splits and joins
              (mkNamed "trouble.nvim" trouble-nvim) # quickfix and location list
              (mkNamed "which-key.nvim" which-key-nvim) # show keymaps

              # alternate themes
              (mkNamed "onedark.nvim" onedark-nvim)
              (mkNamed "tokyonight.nvim" tokyonight-nvim)
            ];

            ai = [ supermaven-nvim ];
            debug = [ nvim-dap ];
            git = [
              (mkNamed "diffview.nvim" diffview-nvim) # git diff viewer
              (mkNamed "gitsigns.nvim" gitsigns-nvim) # git signs in gutter
              nixCatsBuilds.neogit # git integration
            ];
            langs = [
              # format wrapper plugin
              (mkNamed "conform.nvim" conform-nvim)

              # lua
              luvit-meta

              # python
              (mkNamed "venv-selector.nvim" venv-selector-nvim)

              # rust
              rustaceanvim

              # yaml
              vim-helm
              (mkNamed "yaml-companion.nvim" yaml-companion-nvim)

              # web
              nvim-ts-autotag
              nvim-vtsls
              (mkNamed "tsc.nvim" tsc-nvim)
            ];
            statusline = [
              (mkNamed "lualine.nvim" lualine-nvim) # statusline
              # vimPlugins.lualine-lsp-progress # lsp progress
            ];
            bufferline = [
              (mkNamed "bufferline.nvim" bufferline-nvim) # bufferline
            ];
            utils = [
              (mkNamed "better-escape.nvim"
                better-escape-nvim) # jk to escape insert mode
              (mkNamed "dressing.nvim"
                dressing-nvim) # ui lib (dep for overseer-nvim)
              goto-preview # preview definition in window
              (mkNamed "moveline.nvim"
                vimPlugins.moveline-nvim) # move blocks of text
              (mkNamed "nix-develop.nvim"
                nix-develop-nvim) # run `nix develop` without restarting neovim
              (mkNamed "nix-reaver.nvim"
                nixCatsBuilds.nix-reaver-nvim) # update rev & hash of fetchFromGitHub
              (mkNamed "numb.nvim" numb-nvim) # peek at line before jump
              (mkNamed "nvim-colorizer.lua"
                nvim-colorizer-catgoose) # colorize hex, rgb, etc. codes
              nvim-lightbulb # show code actions
              nvim-ufo # folds
              (mkNamed "oil.nvim" oil-nvim) # tree explorer
              (mkNamed "overseer.nvim" overseer-nvim) # task runner integration
              promise-async # async functions (dep for nvim-ufo)
              (mkNamed "screenkey.nvim" screenkey-nvim) # screenkey in neovim
              (mkNamed "silicon.nvim"
                nixCatsBuilds.silicon-nvim) # screenshot code
              (mkNamed "tabs-vs-spaces.nvim"
                nixCatsBuilds.tabs-vs-spaces-nvim) # smart tab/spaces
              (mkNamed "sort.nvim" sort-nvim) # sort lines
              url-open # open more urls
              vim-eunuch # unix tools
            ];
          };

          # shared libraries to be added to LD_LIBRARY_PATH
          # variable available to nvim runtime
          sharedLibraries = { core = with pkgs; [ libgit2 sqlite ]; };

          # environmentVariables:
          # this section is for environmentVariables that should be available
          # at RUN TIME for plugins. Will be available to path within neovim terminal
          environmentVariables = {
            profile.NVIM_PROFILE = "start";
            test = { CATTESTVAR = "It worked!"; };
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
          extraPython3Packages = { test = [ (_: [ ]) ]; };
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
            # your alias may not conflict with your other packages.
            aliases = [ "tuque" "vim" ];
            # neovim-unwrapped =
            #   inputs.neovim-nightly-overlay.packages.${pkgs.system}.neovim;

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
            debug = false;
            fugit = false;
            git = true;
            langs = true;
            utils = true;
            profile = false;

            # ui elements
            colorscheme = "dracula";
            bufferline = true;
            statusline = true;

            test = false;
          };
          extra = { };
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
            extra = { };
          };
        tu-profile = { pkgs, ... }:
          let tuque = tu { inherit pkgs; };
          in {
            settings = tuque.settings // { aliases = [ "tup" ]; };
            categories = tuque.categories // { profile = true; };
            extra = { };
          };
      };

      # In this section, the main thing you will need to do is change the default package name
      # to the name of the packageDefinitions entry you wish to use as the default.
      defaultPackageName = "tu";

      # see :help nixCats.flake.outputs.exports
    in forEachSystem (system:
      let
        # the builder function that makes it all work
        nixCatsBuilder = utils.baseBuilder luaPath {
          inherit nixpkgs system dependencyOverlays extra_pkg_config;
        } categoryDefinitions packageDefinitions;
        defaultPackage = nixCatsBuilder defaultPackageName;
        # this is just for using utils such as pkgs.mkShell
        # The one used to build neovim is resolved inside the builder
        # and is passed to our categoryDefinitions and packageDefinitions
        pkgs = import nixpkgs { inherit system; };
      in {
        # these outputs will be wrapped with ${system} by utils.eachSystem

        # this will make a package out of each of the packageDefinitions defined above
        # and set the default package to the one passed in here.
        packages = utils.mkAllWithDefault defaultPackage;

        # choose your package for devShell
        # and add whatever else you want in it.
        devShells = {
          default = pkgs.mkShell {
            name = defaultPackageName;
            packages = [ defaultPackage ];
            inputsFrom = [ ];
            shellHook = "";
          };
        };

      }) // (let
        # we also export a nixos module to allow reconfiguration from configuration.nix
        nixosModule = utils.mkNixosModules {
          moduleNamespace = [ defaultPackageName ];
          inherit defaultPackageName dependencyOverlays luaPath
            categoryDefinitions packageDefinitions extra_pkg_config nixpkgs;
        };
        # and the same for home manager
        homeModule = utils.mkHomeModules {
          moduleNamespace = [ defaultPackageName ];
          inherit defaultPackageName dependencyOverlays luaPath
            categoryDefinitions packageDefinitions extra_pkg_config nixpkgs;
        };
      in {

        # these outputs will be NOT wrapped with ${system}

        # this will make an overlay out of each of the packageDefinitions defined above
        # and set the default overlay to the one named here.
        overlays = utils.makeOverlays luaPath {
          inherit nixpkgs dependencyOverlays extra_pkg_config;
        } categoryDefinitions packageDefinitions defaultPackageName;

        nixosModules.default = nixosModule;
        homeModules.default = homeModule;

        inherit utils nixosModule homeModule;
        inherit (utils) templates;
      });
}
