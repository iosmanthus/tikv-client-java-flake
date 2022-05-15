{
  description = "Java Client for TiKV";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/master";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem
      (
        system:
        let
          repo = "client-java";
          pkgs = import nixpkgs {
            inherit system;
          };
          fork = "git@github.com:iosmanthus/${repo}.git";
          upstream = "git@github.com:tikv/${repo}.git";
        in
        {
          devShell = pkgs.mkShell {
            hardeningDisable = [ "all" ];
            buildInputs = with pkgs;[ git jdk8 maven gcc protobuf ];
            PROTOC = "${pkgs.protobuf3_8}/bin/protoc";
            shellHook = ''
              if [ ! -d "${repo}" ]; then
                git clone ${fork}
                git -C ${repo} remote add upstream ${upstream}
              fi
            '';
          };
        }
      );
}
