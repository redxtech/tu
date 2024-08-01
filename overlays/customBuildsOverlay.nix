# init this template into the overlays directory,
# rename it, then import it as directed it within overlays/default.nix
importName: inputs:
let
  overlay = self: super: {
    ${importName} = let
      inherit (super) vimUtils fetchFromGitHub;
      inherit (vimUtils) buildVimPlugin;
    in {
      # define your overlay derivations here

      any-jump-vim = buildVimPlugin {
        pname = "any-jump-vim";
        version = "0.1.0";
        src = fetchFromGitHub {
          owner = "pechorin";
          repo = "any-jump.vim";
          rev = "f95674d9a4251ac02f452d5f1861e4422f4652c7";
          hash = "sha256-US7/aKd+y2SebBEh5oEFNojKcAQrVlq9LaYbmsU9RzY=";
        };
      };

      before-nvim = buildVimPlugin {
        pname = "before-nvim";
        version = "0.1.0";
        src = fetchFromGitHub {
          owner = "bloznelis";
          repo = "before.nvim";
          rev = "42294a3ba5dc02d3f3a9fe4e9a033ef29da6dcc6";
          hash = "sha256-fAx8pBddOhdxbBlSteA5Y5f9rLSexp7czz3wWEzv+zs=";
        };
      };

      diagflow-nvim = buildVimPlugin {
        pname = "diagflow-nvim";
        version = "0.1.0";
        src = fetchFromGitHub {
          owner = "dgagn";
          repo = "diagflow.nvim";
          rev = "fc09d55d2e60edc8ed8f9939ba97b7b7e6488c99";
          hash = "sha256-2WNuaIEXcAgUl2Kb/cCHEOrtehw9alaoM96qb4MLArw=";
        };
      };

      fugit2-nvim = buildVimPlugin {
        pname = "fugit2-nvim";
        version = "0.1.0";
        src = fetchFromGitHub {
          owner = "SuperBo";
          repo = "fugit2.nvim";
          rev = "e8b262d3f974a301b9efae98a571e6c9e635ab16";
          hash = "sha256-U9Ve7mgJlQwArgDBOXC2ezaaG7zIOJalLEl5Hyw2jMA=";
        };
      };

      fzy-lua-native = let
        src = super.stdenv.mkDerivation {
          pname = "fzy-lua-native";
          version = "0.1.0";
          src = ./.;
          buildInputs = [ super.stdenv.cc.cc ];
          installPhase = "cp -r . $out";
        };
      in buildVimPlugin {
        pname = "fzy-lua-native";
        version = "0.1.0";
        inherit src;
      };

      luvit-meta = buildVimPlugin {
        pname = "luvit-meta";
        version = "0.1.0";
        src = fetchFromGitHub {
          owner = "Bilal2453";
          repo = "luvit-meta";
          rev = "ce76f6f6cdc9201523a5875a4471dcfe0186eb60";
          hash = "sha256-zAAptV/oLuLAAsa2zSB/6fxlElk4+jNZd/cPr9oxFig=";
        };
      };

      neovim-project = buildVimPlugin {
        pname = "neovim-project";
        version = "0.1.0";
        src = fetchFromGitHub {
          owner = "coffebar";
          repo = "neovim-project";
          rev = "16594823c2a3e2214ed8c7d676e5e5beefbe96fd";
          hash = "sha256-jPvqyjiOaQz8vR6Gp3oSXMz/gtkE5j7lLyXKc/CdBEs=";
        };
      };

      nvim-numbertoggle = buildVimPlugin {
        pname = "nvim-numbertoggle";
        version = "0.1.0";
        src = fetchFromGitHub {
          owner = "sitiom";
          repo = "nvim-numbertoggle";
          rev = "c5827153f8a955886f1b38eaea6998c067d2992f";
          hash = "sha256-IkJ9KRrikJZvijjfqgnJ2/QYAuF8KX2/zFX1oUbE3aI=";
        };
      };

      nvim-tinygit = buildVimPlugin {
        pname = "nvim-tinygit";
        version = "0.1.0";
        src = fetchFromGitHub {
          owner = "chrisgrieser";
          repo = "nvim-tinygit";
          rev = "a74ef2461770622daae2ab11c84af39aa818ea57";
          hash = "sha256-It/m0vSQWwIl+j/CMAmwuxr16UWW5s7nF93YPpqtIZc=";
        };
      };

      nvim-vtsls = buildVimPlugin {
        pname = "nvim-vtsls";
        version = "0.1.0";
        src = fetchFromGitHub {
          owner = "yioneko";
          repo = "nvim-vtsls";
          rev = "45c6dfea9f83a126e9bfc5dd63430562b3f8af16";
          hash = "sha256-/y1k7FHfzL1WQNGXcskexEIYCsQjHg03DrMFgZ4nuiI=";
        };
      };

      profile-nvim = buildVimPlugin {
        pname = "profile-nvim";
        version = "0.1.0";
        src = fetchFromGitHub {
          owner = "stevearc";
          repo = "profile.nvim";
          rev = "0ee32b7aba31d84b0ca76aaff2ffcb11f8f5449f";
          hash = "sha256-usyy1kST8hq/3j0sp7Tpf/1mld6RtcVABPo/ygeqzbU=";
        };
      };

      smart-open-nvim = buildVimPlugin {
        pname = "smart-open-nvim";
        version = "0.1.0";
        src = fetchFromGitHub {
          owner = "danielfalk";
          repo = "smart-open.nvim";
          rev = "f4e39e9a1b05a6b82b1182a013677acc44b27abb";
          hash = "sha256-bEo5p7tHeoE13P8QsjC8RqNA0NMogjdYzN0oatQaIJY=";
        };
      };

      telescope-repo-nvim = buildVimPlugin {
        pname = "telescope-repo-nvim";
        version = "0.1.0";
        src = fetchFromGitHub {
          owner = "cljoly";
          repo = "telescope-repo.nvim";
          rev = "36720ed0ac724fc7527a6a4cf920e13164039400";
          hash = "sha256-m9icWnwM4Wl1PW2dLaQne5PaKbjfVEEzWxbETJJSUxw=";
        };
      };

      tiny-devicons-auto-color-nvim = buildVimPlugin {
        pname = "tiny-devicons-auto-color-nvim";
        version = "0.1.0";
        src = fetchFromGitHub {
          owner = "rachartier";
          repo = "tiny-devicons-auto-colors.nvim";
          rev = "9be4af5b1bc1f26a11206ed7ce8bf44312e7941a";
          hash = "sha256-JGI9y5Y0AocTO2M1Lt28UxVP0rZv20ZHJw0wKurJsh8=";
        };
      };
    };
  };
in overlay
