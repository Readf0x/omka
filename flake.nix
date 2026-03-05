rec {
  description = "Odin umka bindings";
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    umka-flake.url = "github:readf0x/umka-flake";
  };
  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux"];
      perSystem = {
        system,
        pkgs,
        ...
      }: let
        info = {
          projectName = "omka";
        };
      in
        ({
          projectName,
        }: rec {
          devShells.default = pkgs.mkShell {
            packages = with pkgs; [
              odin
              inputs.umka-flake.packages.${system}.umka
              packages.link-headers
            ];
          };
          packages = {
            ${projectName} = pkgs.stdenv.mkDerivation rec {
              name = projectName;
              pname = name;
              version = "0.1";
              src = ./.;
              nativeBuildInputs = [];
              buildInputs = [];
              meta = {
                inherit description;
                homepage = "https://github.com/readf0x/omka";
                license = pkgs.lib.licenses.bsd2;
              };
            };
            default = packages.${projectName};
            link-headers = pkgs.writeShellScriptBin "link-headers" ''
              ln -s ${inputs.umka-flake.packages.${system}.umka.dev}/include/umka_api.h umka_api.h
            '';
          };
        })
        info;
    };
}
