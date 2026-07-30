# dotfiles

My cross-platform development environment, declared in [`.dot.toml`](.dot.toml)
and applied by [`dot`](https://github.com/yslib/dot).

This repository is primarily my personal environment configuration. It is also
a concrete example of using `dot` with explicit platform targets, a small
profile inheritance tree, external package providers, actions, and native
configuration links.

## Environments

| Environment | Binary architecture | Manifest selection |
| --- | --- | --- |
| Arch Linux | x86-64 | `arch-linux` |
| macOS | Apple Silicon | `macos` |
| Windows | x86-64 | `windows` |

## Bootstrap a fresh environment

These commands intentionally target a new environment. They install the latest
`dot` binary into the user executable directory, clone this repository to
`~/.dotfiles`, and immediately apply its manifest.

### Arch Linux x86-64

Minimum requirements:

- `curl` for downloading `dot`;
- `git` for cloning this repository;
- `pacman` and `sudo` for the declared providers.

Base command-line environment:

```sh
mkdir -p ~/.local/bin
curl -fL https://github.com/yslib/dot/releases/latest/download/dot-linux-x86_64 -o ~/.local/bin/dot
chmod +x ~/.local/bin/dot
git clone https://github.com/yslib/dotfiles.git ~/.dotfiles
~/.local/bin/dot --config ~/.dotfiles/.dot.toml apply
```

Hyprland environment:

```sh
mkdir -p ~/.local/bin
curl -fL https://github.com/yslib/dot/releases/latest/download/dot-linux-x86_64 -o ~/.local/bin/dot
chmod +x ~/.local/bin/dot
git clone https://github.com/yslib/dotfiles.git ~/.dotfiles
~/.local/bin/dot --config ~/.dotfiles/.dot.toml apply --profile hyprland
```

Laptop environment, inheriting the Hyprland profile:

```sh
mkdir -p ~/.local/bin
curl -fL https://github.com/yslib/dot/releases/latest/download/dot-linux-x86_64 -o ~/.local/bin/dot
chmod +x ~/.local/bin/dot
git clone https://github.com/yslib/dotfiles.git ~/.dotfiles
~/.local/bin/dot --config ~/.dotfiles/.dot.toml apply --profile laptop
```

### macOS Apple Silicon

Minimum requirements:

- `curl` for downloading `dot`;
- `git`, normally provided by the Xcode Command Line Tools, for cloning this
  repository.

```sh
mkdir -p ~/.local/bin
curl -fL https://github.com/yslib/dot/releases/latest/download/dot-macos-aarch64 -o ~/.local/bin/dot
chmod +x ~/.local/bin/dot
git clone https://github.com/yslib/dotfiles.git ~/.dotfiles
~/.local/bin/dot --config ~/.dotfiles/.dot.toml apply
```

### Windows x86-64

Prepare the platform prerequisites before running `dot`. Scoop's
[official installer](https://github.com/ScoopInstaller/Install#installation)
supports Windows PowerShell 5.1 and PowerShell 7 and should normally be run from
a non-admin PowerShell.

First, allow locally installed PowerShell scripts and install Scoop:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
```

Install Git from Scoop's default `main` bucket:

```powershell
scoop install git
```

Windows Developer Mode or an elevated shell is also required when `dot` creates
symbolic links.

With Scoop and Git ready, run the Windows bootstrap:

```powershell
irm https://raw.githubusercontent.com/yslib/dotfiles/master/bootstrap.ps1 | iex
```

The script downloads `dot.exe` to `$HOME\.local\bin`, adds that directory to
the user `PATH`, clones this repository to `$HOME\.dotfiles`, and applies
`.dot.toml`. On the first apply, the Scoop provider's `ensure` action adds the
`extras` and `nerd-fonts` buckets before the declared packages are installed.

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
