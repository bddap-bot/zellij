# Dev/build shell for the forked zellij binary (sandboxed via run-untrusted).
# Reuses bothouse's pinned nixpkgs + oxalica rust-overlay (same toolchain the
# zellij-spiral plugin uses: rust 1.96 with wasm32-wasip1 std). zellij's default
# features build a vendored static curl + vendored openssl-sys, so the native
# build needs perl/cmake/make in addition to pkg-config; protobuf is for the
# prost build scripts in the dep tree.
let
  rustOverlay = import (builtins.fetchTarball
    "https://github.com/oxalica/rust-overlay/archive/master.tar.gz");
  sources = import /home/bot/repos/bddap/bothouse/nix/nix/sources.nix;
  pkgs = import sources.nixpkgs { overlays = [ rustOverlay ]; };
  rust = pkgs.rust-bin.stable.latest.default.override {
    targets = [ "wasm32-wasip1" ];
  };
in
pkgs.mkShell {
  buildInputs = [
    rust
    pkgs.gcc
    pkgs.pkg-config
    pkgs.protobuf
    pkgs.perl
    pkgs.cmake
    pkgs.gnumake
    pkgs.util-linux
  ];
}
