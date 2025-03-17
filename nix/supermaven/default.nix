{ stdenv, fetchurl }:

let
  platform = if stdenv.isDarwin then "darwin" else "linux-musl";
  arch = if stdenv.isAarch64 then "aarch64" else "x86_64";
  version = "2/8";
in stdenv.mkDerivation {
  pname = "supermaven-agent";
  version = "2024-11-12";

  src = fetchurl {
    url =
      "https://supermaven-public.s3.amazonaws.com/sm-agent/v${version}/${platform}/${arch}/sm-agent";
    hash = {
      "linux-musl" = {
        "x86_64" = "sha256-lsaS7IoNQUIkTL1Qo+UymeD8y4eX4mPR6XFC2qMlp4g=";
        "aarch64" = "sha256-FXot8/QnrInCiJP+a+SnMOOOmCv1BHEwP9T58bXqe98=";
      };
      "darwin" = {
        "x86_64" = "sha256-ZUK4h3oAp1KWXhhJDE502v1jlhGLzV452u2W1z+IXK0=";
        "aarch64" = "sha256-wocLx/s6h98HNDVmUH3HV/oZOb9WgiIeTteZ1FzG3rc=";
      };
    }.${platform}.${arch};
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin

    cp $src $out/bin/sm-agent
    chmod +x $out/bin/sm-agent
  '';
}
