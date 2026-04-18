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
  outputs =
    {
      self,
      nixpkgs,
      nixCats,
      ...
    }@inputs:
    let
      inherit (nixCats) utils;
      luaPath = "${./.}";
      forEachSystem = utils.eachSystem nixpkgs.lib.platforms.all;
      extra_pkg_config.allowUnfree = true;
      # management of the system variable is one of the harder parts of using flakes.

      # so I have done it here in an interesting way to keep it out of the way.
      # It gets resolved within the builder itself, and then passed to your
      # categoryDefinitions and packageDefinitions.

      # this allows you to use ${stdenv.hostPlatform.system} whenever you want in those sections
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
        {
          pkgs,
          settings,
          categories,
          extra,
          name,
          ...
        }@packageDef:
        let
          inherit (pkgs) vimPlugins vimExtraPlugins nixCatsBuilds;
          mkNamed = name: plugin: { inherit plugin name; };
          system = pkgs.stdenv.hostPlatform.system;
        in
        {
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

              lua51Packages.luarocks # use jit ?
              lua51Packages.jsregexp # do i need this?
            ];

            ai =
              let
                supermaven-agent = pkgs.callPackage ./nix/supermaven { };
              in
              [ supermaven-agent ];
            debug = with pkgs; [
              gdb
              lldb
            ];
            git = with pkgs; [
              git
              libgit2
            ];
            langs = with pkgs; [
              # general
              dprint # formatter for many languages
              efm-langserver # formatter for many languages
              treefmt # multui-language format tool
              vscode-langservers-extracted # a bunch of language servers

              # elixir
              elixir
              beamPackages.expert

              # go
              go
              gopls

              # lua
              emmylua-ls
              lua-language-server
              stylua

              # markdown
              markdownlint-cli
              marksman
              proselint

              # nix
              alejandra # very opinionated nix formatter
              nil
              nixfmt

              # python
              basedpyright # fork of pyright
              ruff
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
              bash-language-server
              fish

              # terraform
              terraform
              terraform-ls
              tflint

              # yaml
              yaml-language-server
              kubectl
              helm-ls

              # web
              biome
              eslint
              eslint_d
              fixjson
              graphql-language-service-cli
              prettier
              svelte-language-server
              typescript-language-server
              prettierd
              tailwindcss-language-server
              typescript
              vscode-extensions.vue.volar
              vtsls
              vue-language-server

              # misc
              taplo # toml toolkit
            ];
          };

          # startupPlugins = with pkgs.vimPlugins; {
          startupPlugins = with vimExtraPlugins; {
            core = [
              (mkNamed "lazy.nvim" lazy-nvim-folke)
              (mkNamed "dracula.nvim" inputs.dracula.packages.${system}.default)
              (mkNamed "flatten.nvim" flatten-nvim-willothy) # open nested nvim instances in current window
              (mkNamed "dashboard-nvim" dashboard-nvim-nvimdev) # dashboard
            ];

            profile = [ (mkNamed "profile.nvim" profile-stevearc-stevearc) ];
          };

          optionalPlugins = with vimExtraPlugins; {
            core = [
              (mkNamed "any-jump.vim" any-jump-vim-pechorin) # fallback goto when no lsp
              (mkNamed "blink.cmp" inputs.blink-cmp.packages.${system}.default)
              (mkNamed "blink.indent" nixCatsBuilds.blink-indent) # better indentation
              (mkNamed "blink.nvim" inputs.blink-nvim.packages.${system}.default)
              (mkNamed "blink.pairs" inputs.blink-pairs.packages.${system}.default)
              (mkNamed "crates.nvim" vimPlugins.crates-nvim)
              (mkNamed "diagflow.nvim" diagflow-nvim-dgagn) # show diagnostics in corner
              (mkNamed "edgy.nvim" edgy-nvim-folke) # window management
              (mkNamed "fastaction.nvim" nixCatsBuilds.fastaction-nvim) # fast code actions picker
              (mkNamed "fidget.nvim" fidget-nvim-j-hui) # lsp status in bottom right
              (mkNamed "filler-begone.nvim" nixCatsBuilds.filler-begone-nvim) # remove empty filler lines
              (mkNamed "flash.nvim" flash-nvim-folke) # movement with s/S f/F
              (mkNamed "friendly-snippets" friendly-snippets-rafamadriz) # snippets
              nixCatsBuilds.fzy-lua-native # native fzy
              (mkNamed "helpview.nvim" helpview-nvim-OXY2DEV) # vimdoc viewer
              (mkNamed "incline.nvim" incline-nvim-b0o) # alternative to winbar
              (mkNamed "instant.nvim" instant-nvim-jbyuki) # session sharing
              (mkNamed "lazydev.nvim" lazydev-nvim-folke) # load lua lsp faster
              (mkNamed "live-rename.nvim" vimPlugins.live-rename-nvim) # visual rename variables with lsp
              (mkNamed "lsp_lines.nvim" nixCatsBuilds.lsp-lines-nvim) # show lsp diagnostics as virtual text;
              (mkNamed "mason.nvim" mason-nvim-mason-org) # binary manager
              (mkNamed "mini.nvim" mini-nvim-nvim-mini) # a bunch of minimal plugins
              (mkNamed "neovim-project" neovim-project-coffebar) # project list
              (mkNamed "neovim-session-manager" neovim-session-manager-Shatur) # session management (dep for neovim-project)
              (mkNamed "noice.nvim" noice-nvim-folke) # ui replacements
              (mkNamed "nui.nvim" nui-nvim-MunifTanjim) # ui library
              (mkNamed "nvim-lspconfig" nvim-lspconfig-neovim) # lsp configs
              (mkNamed "nvim-navbuddy" nvim-navbuddy-SmiteshP) # navic based navigation
              (mkNamed "nvim-navic" nvim-navic-SmiteshP) # breadcrumbs provider
              (mkNamed "nvim-notify" nvim-notify-rcarriga) # notifications
              (mkNamed "nvim-numbertoggle" nvim-numbertoggle-sitiom) # toggle line numbers automatically
              (mkNamed "nvim-snippets" nvim-snippets-garymjr)
              (mkNamed "nvim-spectre" nvim-spectre-nvim-pack) # search and replace
              (mkNamed "nvim-spider" nvim-spider-chrisgrieser) # better motions for b, w, e
              vimPlugins.nvim-treesitter-textobjects
              vimPlugins.nvim-treesitter.withAllGrammars # syntax highlighting
              (mkNamed "nvim-web-devicons" nvim-web-devicons-nvim-tree) # file icons
              (mkNamed "plenary.nvim" plenary-nvim-nvim-lua) # lua helpers
              (mkNamed "promise-async" promise-async-kevinhwang91) # async functions (dep for nvim-ufo)
              (mkNamed "satellite.nvim" satellite-nvim-lewis6991) # scrollbar
              (mkNamed "scrollofffraction.nvim" scrollofffraction-nvim-nkakouros-original) # auto scrolloff size
              (mkNamed "sharing.nvim" nixCatsBuilds.sharing-nvim) # session sharing QoL
              (mkNamed "smart-open.nvim" smart-open-nvim-danielfalk) # better file search
              (mkNamed "sqlite.lua" sqlite-lua-kkharji) # sqlite bindings
              (mkNamed "telescope.nvim" telescope-nvim-nvim-telescope) # pickers
              (mkNamed "telescope-repo.nvim" telescope-repo-nvim-cljoly) # repo picker
              (mkNamed "telescope-fzy-native.nvim" telescope-fzy-native-nvim-nvim-telescope)
              (mkNamed "telescope-zoxide" telescope-zoxide-jvgrootveld) # zoxide integration
              (mkNamed "tiny-code-action.nvim" tiny-code-action-nvim-rachartier) # code actions picker
              (mkNamed "tiny-devicons-auto-colors.nvim" tiny-devicons-auto-colors-nvim-rachartier) # colour devicons with theme colors;
              (mkNamed "todo-comments.nvim" todo-comments-nvim-folke) # highlight TODOs, FIXMEs, etc.
              (mkNamed "toggleterm.nvim" toggleterm-nvim-akinsho) # toggleable terminal
              (mkNamed "treesj" treesj-Wansmer) # splits and joins
              (mkNamed "trouble.nvim" trouble-nvim-folke) # quickfix and location list
              (mkNamed "which-key.nvim" which-key-nvim-folke) # show keymaps

              # alternate themes
              (mkNamed "onedark.nvim" onedark-nvim-navarasu)
              (mkNamed "tokyonight.nvim" tokyonight-nvim-folke)
            ];

            ai = [ (mkNamed "supermaven-nvim" supermaven-nvim-supermaven-inc) ];
            debug = [
              (mkNamed "nvim-dap" nvim-dap-mfussenegger)
              (mkNamed "debugmaster.nvim" nixCatsBuilds.debugmaster-nvim)
            ];
            git = [
              (mkNamed "diffview.nvim" diffview-nvim-sindrets) # git diff viewer
              (mkNamed "gitlinker.nvim" gitlinker-linrongbin16-linrongbin16) # copy git file urls
              (mkNamed "gitsigns.nvim" gitsigns-nvim-lewis6991) # git signs in gutter
              nixCatsBuilds.neogit # git integration
            ];
            langs = [
              # general purpose formatting configs
              (mkNamed "efmls-configs-nvim" efmls-configs-nvim-creativenull)

              # async format on save
              (mkNamed "lsp-format.nvim" lsp-format-nvim-lukas-reineke)

              # lua
              (mkNamed "luvit-meta" luvit-meta-Bilal2453)

              # python
              (mkNamed "venv-selector.nvim" venv-selector-nvim-linux-cultist)

              # rust
              (mkNamed "rustaceanvim" rustaceanvim-mrcjkb)

              # yaml
              (mkNamed "vim-helm" vim-helm-towolf)

              # web
              (mkNamed "nvim-ts-autotag" nvim-ts-autotag-windwp)
              (mkNamed "nvim-vtsls" nvim-vtsls-yioneko)
              (mkNamed "tsc.nvim" tsc-nvim-dmmulroy)
            ];
            statusline = [
              (mkNamed "lualine.nvim" lualine-nvim-nvim-lualine) # statusline
              # vimPlugins.lualine-lsp-progress # lsp progress
            ];
            bufferline = [
              (mkNamed "bufferline.nvim" bufferline-nvim-akinsho) # bufferline
            ];
            utils = [
              (mkNamed "better-escape.nvim" better-escape-nvim-max397574) # jk to escape insert mode
              (mkNamed "dressing.nvim" dressing-nvim-stevearc) # ui lib (dep for overseer-nvim)
              (mkNamed "goto-preview" goto-preview-rmagatti) # preview definition in window
              (mkNamed "moveline.nvim" vimPlugins.moveline-nvim) # move blocks of text
              (mkNamed "nix-develop.nvim" nix-develop-nvim-figsoda) # run `nix develop` without restarting neovim
              (mkNamed "nix-reaver.nvim" nixCatsBuilds.nix-reaver-nvim) # update rev & hash of fetchFromGitHub
              (mkNamed "numb.nvim" numb-nvim-nacro90) # peek at line before jump
              (mkNamed "nvim-colorizer.lua" nvim-colorizer-catgoose-catgoose) # colorize hex, rgb, etc. codes
              (mkNamed "nvim-lightbulb" nvim-lightbulb-kosayoda) # show code actions
              (mkNamed "nvim-ufo" nvim-ufo-kevinhwang91) # folds
              (mkNamed "oil.nvim" oil-nvim-stevearc) # tree explorer
              (mkNamed "overseer.nvim" overseer-nvim-stevearc) # task runner integration
              (mkNamed "promise-async" promise-async-kevinhwang91) # async functions (dep for nvim-ufo)
              (mkNamed "screenkey.nvim" screenkey-nvim-NStefan002) # screenkey in neovim
              (mkNamed "silicon.nvim" nixCatsBuilds.silicon-nvim) # screenshot code
              (mkNamed "tabs-vs-spaces.nvim" nixCatsBuilds.tabs-vs-spaces-nvim) # smart tab/spaces
              (mkNamed "sort.nvim" sort-nvim-sQVe) # sort lines
              (mkNamed "url-open" url-open-sontungexpt) # open more urls
            ];
          };

          # shared libraries to be added to LD_LIBRARY_PATH
          # variable available to nvim runtime
          sharedLibraries = {
            core = with pkgs; [
              libgit2
              sqlite
            ];
          };

          # environmentVariables:
          # this section is for environmentVariables that should be available
          # at RUN TIME for plugins. Will be available to path within neovim terminal
          environmentVariables = {
            profile.NVIM_PROFILE = "start";
            test = {
              CATTESTVAR = "It worked!";
            };
          };

          # If you know what these are, you can provide custom ones by category here.
          # If you dont, check this link out:
          # https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/setup-hooks/make-wrapper.sh
          extraWrapperArgs = {
            # test = [ ''--set CATTESTVAR2 "It worked again!"'' ];
          };

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
        tu =
          { pkgs, name, ... }:
          {
            # they contain a settings set defined above
            # see :help nixCats.flake.outputs.settings
            settings = {
              wrapRc = true;
              # IMPORTANT:
              # your alias may not conflict with your other packages.
              aliases = [
                "tuque"
                "vim"
              ];
              # neovim-unwrapped =
              #   inputs.neovim-nightly-overlay.packages.${system}.neovim;

              configDirName = "tu";

              hosts = {
                node.enable = true;
                python3.enable = true;
                ruby.enable = true;

                neovide = {
                  enable = true;
                  path = {
                    value = with pkgs; lib.getExe pkgs.neovide;
                    args = [
                      "--add-flags"
                      "--neovim-bin ${name}"
                    ];
                  };
                };
              };
            };
            # and a set of categories that you want
            # (and other information to pass to lua)
            categories = {
              core = true;

              ai = true;
              debug = true;
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
        tu-dev =
          { pkgs, name, ... }:
          let
            tuque = tu { inherit pkgs name; };
          in
          {
            inherit (tuque) categories;
            settings = tuque.settings // {
              wrapRc = false;
              aliases = [ "tdev" ];
              unwrappedCfgDir = "~/Code/nvim/tu";
            };
            extra = { };
          };
        tu-profile =
          { pkgs, name, ... }:
          let
            tuque = tu { inherit pkgs name; };
          in
          {
            settings = tuque.settings // {
              aliases = [ "tup" ];
            };
            categories = tuque.categories // {
              profile = true;
            };
            extra = { };
          };
      };

      # In this section, the main thing you will need to do is change the default package name
      # to the name of the packageDefinitions entry you wish to use as the default.
      defaultPackageName = "tu";

      # see :help nixCats.flake.outputs.exports
    in
    forEachSystem (
      system:
      let
        # the builder function that makes it all work
        nixCatsBuilder = utils.baseBuilder luaPath {
          inherit
            nixpkgs
            system
            dependencyOverlays
            extra_pkg_config
            ;
        } categoryDefinitions packageDefinitions;
        defaultPackage = nixCatsBuilder defaultPackageName;
        # this is just for using utils such as pkgs.mkShell
        # The one used to build neovim is resolved inside the builder
        # and is passed to our categoryDefinitions and packageDefinitions
        pkgs = import nixpkgs { inherit system; };
      in
      {
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
      }
    )
    // (
      let
        # we also export a nixos module to allow reconfiguration from configuration.nix
        nixosModule = utils.mkNixosModules {
          moduleNamespace = [ defaultPackageName ];
          inherit
            defaultPackageName
            dependencyOverlays
            luaPath
            categoryDefinitions
            packageDefinitions
            extra_pkg_config
            nixpkgs
            ;
        };
        # and the same for home manager
        homeModule = utils.mkHomeModules {
          moduleNamespace = [ defaultPackageName ];
          inherit
            defaultPackageName
            dependencyOverlays
            luaPath
            categoryDefinitions
            packageDefinitions
            extra_pkg_config
            nixpkgs
            ;
        };
      in
      {
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
      }
    );
}
