{
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    gitignore-file.url = "github:jarvahl/gitignore-file";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ inputs.gitignore-file.flakeModules.default ];

      gitignore.patterns = [
        ".direnv/"
        "result"
        "result-*"
        "*.log"
        ".env"
      ];

      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
    };
}
