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
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    nix-neovim-plugins.url = "github:NixNeovim/NixNeovimPlugins";

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

    plugins-dracula.url = "github:redxtech/dracula.nvim";
    plugins-dracula.flake = false;

    plugins-any-jump.url = "github:pechorin/any-jump.vim";
    plugins-any-jump.flake = false;
    plugins-before.url = "github:bloznelis/before.nvim";
    plugins-before.flake = false;
    plugins-diagflow.url = "github:dgagn/diagflow.nvim";
    plugins-diagflow.flake = false;
    plugins-tiny-devicons-auto-color.url =
      "github:rachartier/tiny-devicons-auto-colors.nvim";
    plugins-tiny-devicons-auto-color.flake = false;
    plugins-neovim-project.url = "github:coffebar/neovim-project";
    plugins-neovim-project.flake = false;
    plugins-smart-open.url = "github:danielfalk/smart-open.nvim";
    plugins-smart-open.flake = false;
    plugins-telescope-repo.url = "github:cljoly/telescope-repo.nvim";
    plugins-telescope-repo.flake = false;
    plugins-fugit2.url = "github:SuperBo/fugit2.nvim";
    plugins-fugit2.flake = false;
    plugins-tinygit.url = "github:chrisgrieser/nvim-tinygit";
    plugins-tinygit.flake = false;
    plugins-numbertoggle.url = "github:sitiom/nvim-numbertoggle";
    plugins-numbertoggle.flake = false;
    plugins-moveline.url = "github:willothy/moveline.nvim";
    plugins-moveline.flake = false;
    plugins-profile.url = "github:stevearc/profile.nvim";
    plugins-profile.flake = false;
  };

  # see :help nixCats.flake.outputs
  outputs = { self, nixpkgs, nixCats, ... }@inputs:
    let
      inherit (nixCats) utils;
      luaPath = "${./.}";
      forEachSystem = utils.eachSystem nixpkgs.lib.platforms.all;
      # the following extra_pkg_config contains any values
      # which you want to pass to the config set of nixpkgs
      # import nixpkgs { config = extra_pkg_config; inherit system; }
      # will not apply to module imports
      # as that will have your system values
      extra_pkg_config = {
        # allowUnfree = true;
      };
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
        { pkgs, settings, categories, name, ... }@packageDef: {
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
              nix-doc
              sqlite
              stdenv.cc.cc
              tree-sitter
              wl-clipboard
              xclip
              zoxide
            ];
            format = with pkgs; [ biome efm-langserver prettierd stylua ];
            fugit = with pkgs; [ gpgme libgit2 lua5_1 lua51Packages.luarocks ];
            lint = with pkgs; [ markdownlint-cli eslint ];
            lsp = with pkgs; [
              lua-language-server
              nil # nix language server
              typescript
              typescript-language-server
              efm-langserver
            ];
            utils = with pkgs; [ glow ];
          };

          # This is for plugins that will load at startup without using packadd:
          startupPlugins = {
            core = with pkgs.vimExtraPlugins; [
              pkgs.vimPlugins.lz-n # lazy plugin loader
              lazy-nvim # lazy package manager
              pkgs.neovimPlugins.dracula # dracula theme
              # dracula-nvim # dracula theme
              dashboard-nvim # dashboard  TODO: move to lazy ?
              flatten-nvim # open nested nvim instances in current window
              tiny-devicons-auto-colors-nvim # colour devicons with theme colors
              nvim-web-devicons # file icons
            ];

            lsp = with pkgs.vimExtraPlugins; [
              nvim-lspconfig # lsp configs

              pkgs.neovimPlugins.any-jump # fallback goto when no lsp
              pkgs.neovimPlugins.before # go to previous edit
              pkgs.neovimPlugins.diagflow # show diagnostics in corner
              lazydev-nvim # load lua lsp faster
              lsp-lines-nvim # show lsp diagnostics as virtual text;
              inc-rename-nvim # visual rename variables with lsp
              none-ls-nvim # fallback lsp
              nui-nvim # ui library
              nvim-navic # breadcrumbs provider
            ];
            profile = with pkgs.neovimPlugins; [ profile ];
          };

          # not loaded automatically at startup.
          # use with packadd and an autocommand in config to achieve lazy loading
          optionalPlugins = {
            core = with pkgs.vimExtraPlugins; [
              # lazy
              Comment-nvim # commenting  TODO: is this needed?
              pkgs.vimPlugins.edgy-nvim # window management
              fidget-nvim # lsp status in bottom right
              flash-nvim # movement with s/S f/F
              gitsigns-nvim # git signs in gutter
              mini-nvim # a bunch of minimal plugins
              pkgs.vimPlugins.neogit # git integration
              neovim-project # project list
              neovim-session-manager # session management (dep for neovim-project)
              pkgs.neovimPlugins.smart-open # better file search
              nvim-numbertoggle # toggle line numbers automatically
              nvim-spectre # search and replace
              toggleterm-nvim # toggleable terminal
              pkgs.vimPlugins.nvim-treesitter.withAllGrammars # syntax highlighting
              plenary-nvim # lua helpers
              promise-async # async functions (dep for nvim-ufo)
              rainbow-delimiters-nvim # rainbow {}[]()
              sqlite-lua # sqlite bindings
              telescope-nvim # pickers
              pkgs.vimPlugins.telescope-fzy-native-nvim
              telescope-repo-nvim # repo picker
              telescope-zoxide # zoxide integration
              treesj # splits and joins
              trouble-nvim # quickfix and location list
              todo-comments-nvim # highlight TODOs, FIXMEs, etc.
              inc-rename-nvim # visual rename variables with lsp
            ];

            ai = [ pkgs.vimPlugins.supermaven-nvim ];
            blink = [
              inputs.blink-cmp.packages.${pkgs.system}.default
              inputs.blink-nvim.packages.${pkgs.system}.default
              # lazy
              pkgs.vimPlugins.nvim-snippets
              pkgs.vimExtraPlugins.friendly-snippets
            ];
            cmp = with pkgs.vimExtraPlugins; [
              nvim-cmp
              LuaSnip
              cmp-luasnip
              cmp-nvim-lsp
              cmp-path
            ];
            debug = [ ];
            format = with pkgs.vimExtraPlugins; [
              conform-nvim # format  TODO: setup
              efmls-configs-nvim # format tool
            ];
            fugit = with pkgs.vimExtraPlugins; [
              # lazy
              diffview-nvim # git diff viewer
              dressing-nvim # ui lib (dep for overseer-nvim)
              pkgs.neovimPlugins.fugit2 # git client
              nvim-tinygit # github issue integration
              nui-nvim # ui library
            ];
            lint = with pkgs.vimExtraPlugins; [ ];
            # lsp = with pkgs.vimExtraPlugins; [
            #   nvim-lspconfig # lsp configs
            #
            #   pkgs.neovimPlugins.any-jump # fallback goto when no lsp
            #   pkgs.neovimPlugins.before # go to previous edit
            #   pkgs.neovimPlugins.diagflow # show diagnostics in corner
            #   lazydev-nvim # load lua lsp faster
            #   lsp-lines-nvim # show lsp diagnostics as virtual text;
            #   inc-rename-nvim # visual rename variables with lsp
            #   none-ls-nvim # fallback lsp
            #   nui-nvim # ui library
            #   nvim-navic # breadcrumbs provider
            # ];
            statusline = with pkgs.vimExtraPlugins;
              [
                lualine-nvim # statusline
                # pkgs.vimPlugins.lualine-lsp-progress # lsp progress
              ];
            bufferline = with pkgs.vimExtraPlugins;
              [
                barbar-nvim # bufferline
              ];
            breadcrumb = with pkgs.vimExtraPlugins; [
              # lazy
              barbecue-nvim # bufferline breadcrumbs
              nvim-navic # breadcrumbs provider
            ];
            winbar = [ pkgs.vimPlugins.winbar-nvim ];
            extraUI = with pkgs.vimExtraPlugins; [
              # alternate themes
              onedark-nvim
              tokyonight-nvim

              # lazy
              diffview-nvim # git diff viewer
              noice-nvim # ui replacements
              nui-nvim # ui library
              nvim-lightbulb # show code actions
              nvim-navbuddy # navic based navigation
              nvim-navic # breadcrumbs provider
            ];
            utils = with pkgs.vimExtraPlugins; [
              # lazy
              better-escape-nvim # jk to escape insert mode
              dressing-nvim # ui lib (dep for overseer-nvim)
              glow-nvim # markdown preview
              goto-preview # preview definition in window
              moveline-nvim # move blocks of text
              numb-nvim # peek at line before jump
              nvim-colorizer-lua # colorize hex, rgb, etc. codes
              nvim-ufo # folds
              overseer-nvim # task runner integration
              promise-async # async functions (dep for nvim-ufo)
              url-open # open more urls
              pkgs.vimPlugins.vim-eunuch # unix tools
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
        tuque = { pkgs, ... }: {
          # they contain a settings set defined above
          # see :help nixCats.flake.outputs.settings
          settings = {
            wrapRc = true;
            # IMPORTANT:
            # you may not alias to nvim
            # your alias may not conflict with your other packages.
            aliases = [ "tu" "vim" ];
            # caution: this option must be the same for all packages.
            # or at least, all packages that are to be installed simultaneously.
            # neovim-unwrapped = inputs.neovim-nightly-overlay.packages.${pkgs.system}.neovim;

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
            format = true;
            fugit = true;
            lsp = true;
            statusline = true;
            bufferline = true;
            breadcrumb = true;
            winbar = false;
            extraUI = true;
            utils = true;
            colorscheme = "dracula";
            test = true;
            example = {
              youCan = "add more than just booleans";
              toThisSet = [
                "and the contents of this categories set"
                "will be accessible to your lua with"
                "nixCats('path.to.value')"
                "see :help nixCats"
              ];
            };
          };
        };
        tuque-dev = { pkgs, ... }:
          let tu = tuque { inherit pkgs; };
          in {
            inherit (tu) categories;
            settings = {
              wrapRc = false;
              aliases = [ "tdev" ];
              unwrappedCfgDir = "~/Code/nvim/tu";
            };
          };
        tuque-profile = { pkgs, ... }:
          let tu = tuque { inherit pkgs; };
          in {
            settings = tu.settings // { aliases = [ "tup" ]; };
            categories = tu.categories // { profile = true; };
          };
        tuque-liam = { pkgs, ... }:
          let tu = tuque { inherit pkgs; };
          in {
            settings = tu.settings // { aliases = [ "tl" ]; };
            categories = tu.categories // {
              statusline = false;
              bufferline = false;
              breadcrumb = false;
              extraUI = false;
              utils = false;
            };
          };
      };
      # In this section, the main thing you will need to do is change the default package name
      # to the name of the packageDefinitions entry you wish to use as the default.
      defaultPackageName = "tuque";

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
              "tuque-dev"
              "tuque-profile"
              "tuque-liam"
            ];
            inputsFrom = [ ];
            shellHook = "";
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
