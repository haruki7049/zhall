{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    zig.url = "github:mitchellh/zig-overlay";
    flake-utils.url = "github:numtide/flake-utils";
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs = { self, nixpkgs, systems, flake-utils, zig, treefmt-nix }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays =
          [ (final: prev: { zigpkgs = zig.packages.${prev.system}; }) ];
        pkgs = import nixpkgs { inherit system overlays; };
        treefmtEval = treefmt-nix.lib.evalModule pkgs ./treefmt.nix;
      in
      {
        # Use `nix fmt`
        formatter = treefmtEval.config.build.wrapper;

        # Use `nix flake check`
        checks.formatting = treefmtEval.config.build.check self;

        devShells.default = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            zigpkgs."0.13.0"
            zls
          ];

          shellHook = ''
            export PS1="\n[nix-shell:\w]$ "
          '';
        };
      });
}
