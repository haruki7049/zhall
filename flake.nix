{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      treefmt-nix,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pname = "zhall";
        pkgs = import nixpkgs { inherit system; };
        treefmtEval = treefmt-nix.lib.evalModule pkgs ./treefmt.nix;
        zhall = pkgs.stdenv.mkDerivation {
          inherit pname;
          version = "0.1.0";
          src = ./.;

          nativeBuildInputs = [ pkgs.zig_0_13.hook ];
        };
      in
      {
        # Use `nix fmt`
        formatter = treefmtEval.config.build.wrapper;

        # Use `nix flake check`
        checks = {
          inherit zhall;
          formatting = treefmtEval.config.build.check self;
        };

        # nix build .
        # nix build .#default
        packages = {
          inherit zhall;
          default = zhall;
        };

        devShells.default = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            zig_0_13
            zls
            nil
          ];

          shellHook = ''
            export PS1="\n[nix-shell:\w]$ "
          '';
        };
      }
    );
}
