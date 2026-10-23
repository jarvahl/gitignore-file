# gitignore-file

Generate `.gitignore` from Nix.

## Use

```nix
{
  inputs.gitignore-file.url = "github:jarvahl/gitignore-file";

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ inputs.gitignore-file.flakeModules.default ];

      gitignore.patterns = [
        ".direnv/"
        "result"
        "result-*"
        "*.log"
        ".env"
      ];
    };
}
```

Generate or update `.gitignore`:

```sh
nix run .#gitignore
```

The command writes to the current Git repository's root, including when run from a subdirectory. Existing unmanaged files are not overwritten: move their patterns into Nix and move the original file aside before generating.

If `mightyiam/files` is imported, `.gitignore` is automatically included in `nix run .#write-files`. That writer uses its own overwrite behavior; the standalone `gitignore` command refuses unmanaged files.

See [examples/flake.nix](examples/flake.nix) for a complete flake.

## Options

- `gitignore.enable`: defaults to `true`. Set to `false` to disable generation without deleting the existing file.
- `gitignore.patterns`: list of single-line patterns, defaulting to `[]`.

Patterns preserve Git syntax, including negation (`!pattern`). They are neither sorted nor deduplicated. Use `lib.mkBefore` and `lib.mkAfter` to control ordering across modules.

## Multiple modules

Independent modules contribute to the same `.gitignore`:

```nix
# modules/development.nix
{
  gitignore.patterns = [ ".direnv/" "result" ];
}
```

```nix
# modules/secrets.nix
{
  gitignore.patterns = [ ".env" "*.key" ];
}
```

With the Dendritic Pattern, import the flake-parts module once alongside these modules:

```nix
# modules/gitignore.nix
{ inputs, ... }:
{
  imports = [ inputs.gitignore-file.flakeModules.default ];
}
```

## Checks

```sh
nix flake check
```
