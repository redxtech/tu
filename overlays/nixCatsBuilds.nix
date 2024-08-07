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
          installPhase = "cp -r . $out";
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
    };
  };
in overlay
