{ config, inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      checks.gitignore = import ../tests {
        inherit inputs pkgs;
        module = config.flake.flakeModules.default;
      };
    };
}
