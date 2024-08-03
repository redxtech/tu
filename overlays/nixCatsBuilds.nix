# init this template into the overlays directory,
# rename it, then import it as directed it within overlays/default.nix
importName: inputs:
let
  overlay = self: super: {
    ${importName} = let
      inherit (super) lib vimUtils fetchFromGitHub;
      inherit (vimUtils) buildVimPlugin;
    in {
      # define your overlay derivations here

      any-jump-vim = buildVimPlugin {
        pname = "any-jump-vim";
        version = "2024-03-22";
        src = fetchFromGitHub {
          owner = "pechorin";
          repo = "any-jump.vim";
          rev = "f95674d9a4251ac02f452d5f1861e4422f4652c7";
          hash = "sha256-US7/aKd+y2SebBEh5oEFNojKcAQrVlq9LaYbmsU9RzY=";
        };
      };

      before-nvim = buildVimPlugin {
        pname = "before-nvim";
        version = "2024-03-19";
        src = fetchFromGitHub {
          owner = "bloznelis";
          repo = "before.nvim";
          rev = "42294a3ba5dc02d3f3a9fe4e9a033ef29da6dcc6";
          hash = "sha256-fAx8pBddOhdxbBlSteA5Y5f9rLSexp7czz3wWEzv+zs=";
        };
      };

      diagflow-nvim = buildVimPlugin {
        pname = "diagflow-nvim";
        version = "2024-07-18";
        src = fetchFromGitHub {
          owner = "dgagn";
          repo = "diagflow.nvim";
          rev = "fc09d55d2e60edc8ed8f9939ba97b7b7e6488c99";
          hash = "sha256-2WNuaIEXcAgUl2Kb/cCHEOrtehw9alaoM96qb4MLArw=";
        };
      };

      fugit2-nvim = buildVimPlugin rec {
        pname = "fugit2-nvim";
        version = "0.2.1";
        src = fetchFromGitHub {
          owner = "SuperBo";
          repo = "fugit2.nvim";
          rev = "v${version}";
          hash = "sha256-U9Ve7mgJlQwArgDBOXC2ezaaG7zIOJalLEl5Hyw2jMA=";
        };
      };

      fzy-lua-native = let
        version = "2023-07-08";
        src = super.stdenv.mkDerivation {
          inherit version;
          pname = "fzy-lua-native";
          src = ./.;
          buildInputs = [ super.stdenv.cc.cc ];
          installPhase = "cp -r . $out";
        };
      in buildVimPlugin {
        pname = "fzy-lua-native";
        inherit src version;
      };

      lazy-nvim = buildVimPlugin rec {
        pname = "lazy-nvim";
        version = "11.14.1";
        src = fetchFromGitHub {
          owner = "folke";
          repo = "lazy.nvim";
          rev = "v${version}";
          hash = "sha256-Rd5r7AcdXYJ+gIsvh0N3WIAgg7xXqEVo+62VzIT5QHo=";
        };
      };

      luvit-meta = buildVimPlugin {
        pname = "luvit-meta";
        version = "2024-01-20";
        src = fetchFromGitHub {
          owner = "Bilal2453";
          repo = "luvit-meta";
          rev = "ce76f6f6cdc9201523a5875a4471dcfe0186eb60";
          hash = "sha256-zAAptV/oLuLAAsa2zSB/6fxlElk4+jNZd/cPr9oxFig=";
        };
      };

      markview-nvim = buildVimPlugin rec {
        pname = "markview-nvim";
        version = "1.0.0";
        src = fetchFromGitHub {
          owner = "OXY2DEV";
          repo = "markview.nvim";
          rev = "v${version}";
          hash = "sha256-V0AXILgdgP8M6I4Cy0IjuVnzivLGPa5ZBHw+gSgVllY=";
          fetchSubmodules = true;
        };
      };

      neovim-project = buildVimPlugin {
        pname = "neovim-project";
        version = "2024-07-08";
        src = fetchFromGitHub {
          owner = "coffebar";
          repo = "neovim-project";
          rev = "16594823c2a3e2214ed8c7d676e5e5beefbe96fd";
          hash = "sha256-jPvqyjiOaQz8vR6Gp3oSXMz/gtkE5j7lLyXKc/CdBEs=";
        };
      };

      nix-reaver-nvim = buildVimPlugin {
        pname = "nix-reaver-nvim";
        version = "2024-08-02";
        src = fetchFromGitHub {
          owner = "redxtech";
          repo = "nix-reaver.nvim";
          rev = "22b7cc7e34f8c9b5eec314a74a3bdab842b12c7e";
          hash = "sha256-CUuyBsthZTQed4FwpRRkrcIGE5GUunSsl7H/b2x4RAc=";
        };
      };

      nvim-numbertoggle = buildVimPlugin {
        pname = "nvim-numbertoggle";
        version = "2024-03-29";
        src = fetchFromGitHub {
          owner = "sitiom";
          repo = "nvim-numbertoggle";
          rev = "c5827153f8a955886f1b38eaea6998c067d2992f";
          hash = "sha256-IkJ9KRrikJZvijjfqgnJ2/QYAuF8KX2/zFX1oUbE3aI=";
        };
      };

      nvim-tinygit = buildVimPlugin {
        pname = "nvim-tinygit";
        version = "2024-07-25";
        src = fetchFromGitHub {
          owner = "chrisgrieser";
          repo = "nvim-tinygit";
          rev = "a74ef2461770622daae2ab11c84af39aa818ea57";
          hash = "sha256-It/m0vSQWwIl+j/CMAmwuxr16UWW5s7nF93YPpqtIZc=";
        };
      };

      nvim-vtsls = buildVimPlugin {
        pname = "nvim-vtsls";
        version = "2024-06-27";
        src = fetchFromGitHub {
          owner = "yioneko";
          repo = "nvim-vtsls";
          rev = "45c6dfea9f83a126e9bfc5dd63430562b3f8af16";
          hash = "sha256-/y1k7FHfzL1WQNGXcskexEIYCsQjHg03DrMFgZ4nuiI=";
        };
      };

      profile-nvim = buildVimPlugin {
        pname = "profile-nvim";
        version = "2024-04-23";
        src = fetchFromGitHub {
          owner = "stevearc";
          repo = "profile.nvim";
          rev = "0ee32b7aba31d84b0ca76aaff2ffcb11f8f5449f";
          hash = "sha256-usyy1kST8hq/3j0sp7Tpf/1mld6RtcVABPo/ygeqzbU=";
        };
      };

      screenkey-nvim = buildVimPlugin rec {
        pname = "screenkey-nvim";
        version = "2.2.1";
        src = fetchFromGitHub {
          owner = "NStefan002";
          repo = "screenkey.nvim";
          rev = "v${version}";
          hash = "sha256-Lb/jpSKR5ehW2fBvWZ6Y4zJ7w6aNtXa2Apu4WDvs5ek=";
        };
      };

      silicon-nvim = let
        version = "0.5.0";
        silicon-lib = super.stdenv.mkDerivation {
          inherit version;
          pname = "silicon-lib";
          src = super.fetchzip {
            url =
              "https://github.com/krivahtoo/silicon.nvim/releases/download/v${version}/silicon-linux.tar.gz";
            hash = "sha256-83+8y1uunrolygycUEgNK0ff40a2P8kOIJk/6doE2wI=";
          };
          nativeBuildInputs = with super; [ autoPatchelfHook ];
          buildInputs = with super; [ stdenv.cc.cc.lib fontconfig.lib ];
          installPhase = ''
            mkdir -p $out/lib
            cp -r silicon.so $out/lib/silicon.so
            patchelf $out/lib/silicon.so --add-needed libfontconfig.so.1
          '';
        };
      in buildVimPlugin {
        inherit version;
        pname = "silicon-nvim";
        src = fetchFromGitHub {
          owner = "krivahtoo";
          repo = "silicon.nvim";
          rev = "v${version}";
          hash = "sha256-7YSke9HBnKXvWx9+FrzKUY5Q+ITibSbbNb4Oebb10OE=";
        };
        preInstall = ''
          ln -s ${silicon-lib}/lib/silicon.so lua/silicon.so
        '';
      };

      smart-open-nvim = buildVimPlugin {
        pname = "smart-open-nvim";
        version = "2024-06-12";
        src = fetchFromGitHub {
          owner = "danielfalk";
          repo = "smart-open.nvim";
          rev = "f4e39e9a1b05a6b82b1182a013677acc44b27abb";
          hash = "sha256-bEo5p7tHeoE13P8QsjC8RqNA0NMogjdYzN0oatQaIJY=";
        };
      };

      telescope-repo-nvim = buildVimPlugin {
        pname = "telescope-repo-nvim";
        version = "2024-04-25";
        src = fetchFromGitHub {
          owner = "cljoly";
          repo = "telescope-repo.nvim";
          rev = "36720ed0ac724fc7527a6a4cf920e13164039400";
          hash = "sha256-m9icWnwM4Wl1PW2dLaQne5PaKbjfVEEzWxbETJJSUxw=";
        };
      };

      tiny-devicons-auto-color-nvim = buildVimPlugin {
        pname = "tiny-devicons-auto-color-nvim";
        version = "2024-06-16";
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
