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
        version = "2023-07-08";
        src = super.stdenv.mkDerivation {
          inherit version;
          pname = "fzy-lua-native";
          src = fetchFromGitHub {
            owner = "romgrk";
            repo = "fzy-lua-native";
            rev = "820f745b7c442176bcc243e8f38ef4b985febfaf";
            hash = "sha256-Ja4xNGruETSU1nq+r+hkJiFpnMbmL9m2JIKC6gHFGf4=";
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
        version = "2023-08-01";
        src = fetchFromGitHub {
          owner = "NeogitOrg";
          repo = "neogit";
          rev = "2b74a777b963dfdeeabfabf84d5ba611666adab4";
          hash = "sha256-K9KbLRrEPfKGSbLl/dMoUcILsMmpv3kyCALmgX7if80=";
        };
      };

      markview-nvim = buildVimPlugin {
        pname = "markview-nvim";
        version = "2024-08-21";
        src = fetchFromGitHub {
          owner = "OXY2DEV";
          repo = "markview.nvim";
          rev = "4695a699ebd87889c815de07e1408331e5c1df61";
          hash = "sha256-R1AsvatIvIcrD919wcQmXNQQ7T3D9PNnyswekmpdAzo=";
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

      telescope-fzy-native-nvim = buildVimPlugin {
        pname = "telescope-fzy-native-nvim";
        version = "2022-09-11";
        src = fetchFromGitHub {
          owner = "nvim-telescope";
          repo = "telescope-fzy-native.nvim";
          rev = "282f069504515eec762ab6d6c89903377252bf5b";
          sha256 = "1197jravq8li5xdmgh7zwvl91xbwm7l7abaw2vxgmaik4cf4vskh";
          fetchSubmodules = true;
        };
      };
    };
  };
in overlay
