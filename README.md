# dotfiles

My cross-platform development environment, declared in [`.dot.toml`](.dot.toml)
and applied by [`dot`](https://github.com/yslib/dot).

This repository is primarily my personal environment configuration. It is also
a concrete example of using `dot` with explicit platform targets, a small
profile inheritance tree, external package providers, actions, and native
configuration links.


## Command Generator

Please see the [Web interface](https://yslib.github.io/dot-web) for a command generator that helps you select a platform and profile, and generates the
commands to apply your configuration

## Daily use

Once the repository has been cloned, run `dot` from its root so it finds
`./.dot.toml` automatically:

```sh
cd ~/.dotfiles
dot apply
```

Select an Arch profile explicitly:

```sh
dot apply --profile hyprland
dot apply --profile laptop
```

Inspect the resolved plan without executing it:

```sh
dot dry-run --profile laptop
```

Check the selected providers without ensuring or installing them:

```sh
dot check providers --profile laptop
```

Profiles are never inferred. Running `dot apply` without `--profile` applies
only the selected target root.

## Environment model

The Arch Linux configuration is intentionally structured as one inheritance
path:

```text
arch-linux
└── hyprland
    └── laptop
```

- `arch-linux` contains the shared command-line environment.
- `hyprland` adds graphical workstation packages and Hyprland configuration.
- `laptop` inherits both levels and adds laptop power-management packages.

The macOS and Windows targets are complete declarations without profiles. All
package providers, external actions, and native configuration links are defined
in `.dot.toml`.
