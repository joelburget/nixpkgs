{ stdenv, lib, fetchzip, makeWrapper }:

let
  src =
    if stdenv.system == "i686-linux" then fetchzip {
      url = "https://cache.agilebits.com/dist/1P/op/pkg/v0.4/op_linux_386_v0.4.zip";
      sha256 = "0mhlqvd3az50gnfil0xlq10855v3bg7yb05j6ndg4h2c551jrq41";
      stripRoot = false;
    } else fetchzip {
      url = "https://cache.agilebits.com/dist/1P/op/pkg/v0.4/op_linux_amd64_v0.4.zip";
      sha256 = "15cv8xi4slid9jicdmc5xx2r9ag63wcx1mn7hcgzxbxbhyrvwhyf";
      stripRoot = false;
    };
in stdenv.mkDerivation {
  name = "1password-0.4";
  inherit src;
  nativeBuildInputs = [ makeWrapper ];
  installPhase = ''
    mkdir -p $out/bin
    install -D op $out/share/1password/op

    # https://github.com/NixOS/patchelf/issues/66#issuecomment-267743051
    makeWrapper $(cat $NIX_CC/nix-support/dynamic-linker) $out/bin/op \
      --argv0 op \
      --add-flags $out/share/1password/op
  '';
  meta = with lib; {
    description = "1Password command-line tool";
    homepage    = "https://blog.agilebits.com/2017/09/06/announcing-the-1password-command-line-tool-public-beta/";
    maintainers = with maintainers; [ joelburget ];
    license     = licenses.unfree;
    platforms   = [ "i686-linux" "x86_64-linux" ];
  };
}
