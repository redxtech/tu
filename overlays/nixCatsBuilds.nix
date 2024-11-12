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
      fzy-lua-native = buildVimPlugin rec {
        pname = "fzy-lua-native";
        version = "2024-10-26";
        src = super.stdenv.mkDerivation {
          inherit version;
          pname = "fzy-lua-native";
          src = fetchFromGitHub {
            owner = "romgrk";
            repo = "fzy-lua-native";
            rev = "9d720745d5c2fb563c0d86c17d77612a3519c506";
            hash = "sha256-pBV5iGa1+5gtM9BcDk8I5SKoQ9sydOJHsmyoBcxAct0=";
          };
          buildInputs = [ super.stdenv.cc.cc ];
          installPhase = ''
            cp -r . $out

            # make plugin available in runtimepath/deps so that it can be loaded by
            # telescope-fzy-native.nvim
            mkdir -p $out/deps
            ln -s $out $out/deps/fzy-lua-native
          '';
        };
      };

      neogit = buildVimPlugin {
        pname = "neogit";
        version = "2024-11-07";
        src = fetchFromGitHub {
          owner = "NeogitOrg";
          repo = "neogit";
          rev = "8e1e301c2e33c60375850bcf22ba1fb77b684b97";
          hash = "sha256-CX42tQFBkXnhl8WkFTdsQXBss8fTb46k7tqEbxqdMPU=";
        };
      };

      markview-nvim = buildVimPlugin {
        pname = "markview-nvim";
        version = "2024-10-09";
        src = fetchFromGitHub {
          owner = "OXY2DEV";
          repo = "markview.nvim";
          rev = "67b69cdaf9055bebac3682a070d7e5c8eecba29c";
          hash = "sha256-ga7GI2td1mRR6J63+//9neaEnc09TGyMnZrLpP6HGd0=";
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

      sharing-nvim = buildVimPlugin {
        pname = "sharing-nvim";
        version = "2024-08-08";
        src = fetchFromGitHub {
          owner = "redxtech";
          repo = "sharing.nvim";
          rev = "e4b96343b0fadc7e87d13bd637551ab1d4b9db35";
          hash = "sha256-53HVnJUvm5aRb6iRATq/sbwhe1bo+6/5moPVnbyDwo8=";
        };
      };

      silicon-nvim = let
        version = "0.5.1";
        silicon-lib = super.stdenv.mkDerivation rec {
          inherit version;
          pname = "silicon-lib";
          src = super.fetchzip {
            url =
              "https://github.com/krivahtoo/silicon.nvim/releases/download/v${version}/silicon-linux.tar.gz";
            hash = "sha256-0rjsRiqtSQ3zhtMRtC5KNi78WRYl+3knjNiiA/Hv6RA=";
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
          hash = "sha256-I8Cq/L1i/3zL7Xok6//+v2P+vkFXwQeCt0pWpLGqCYY=";
        };
        preInstall = ''
          ln -s ${silicon-lib}/lib/silicon.so lua/silicon.so
        '';
      };

      smart-tab-nvim = buildVimPlugin {
        pname = "smart-tab-nvim";
        version = "2023-11-17";
        src = fetchFromGitHub {
          owner = "boltlessengineer";
          repo = "smart-tab.nvim";
          rev = "25b6686ddabd8503be1c24b578d7831e9ac8fb6c";
          hash = "sha256-H1Nx0jgCKnaorjCNEUckJP2GOFmspcQTnfNSPPLxTM4=";
        };
      };

      tabs-vs-spaces-nvim = buildVimPlugin {
        pname = "tabs-vs-spaces-nvim";
        version = "2024-09-22";
        src = fetchFromGitHub {
          owner = "tenxsoydev";
          repo = "tabs-vs-spaces.nvim";
          rev = "4fbc894fa11b282a0dd5d5a670922abd185ae527";
          hash = "sha256-w6Gc+dmdO5NDyyWM8rMqtVTgq1PIkNtVB0nOI7lHkfs=";
        };
      };

      telescope-fzy-native-nvim = buildVimPlugin {
        pname = "telescope-fzy-native-nvim";
        version = "2022-09-11";
        src = fetchFromGitHub {
          owner = "nvim-telescope";
          repo = "telescope-fzy-native.nvim";
          rev = "282f069504515eec762ab6d6c89903377252bf5b";
          hash = "sha256-ntSc/Z2KGwAPwBSgQ2m+Q9HgpGUwGbd+4fA/dtzOXY4=";
          fetchSubmodules = true;
        };
      };
    };
  };
in overlay
