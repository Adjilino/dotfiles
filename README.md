# Dotfiles

This repo is organized as GNU Stow packages so a fresh clone can bootstrap itself.

## Quick start

```sh
bash -c "$(curl -fsSL https://raw.githubusercontent.com/rui-ad-monte/dotfiles/main/scripts/install.sh)"
```

The installer clones this repo into `~/dotfiles` and runs `scripts/bootstrap.sh`.
It stops with an error if `~/dotfiles` already exists and is not empty.

The bootstrap script will:

- install Homebrew if it is missing
- install shared packages from `Brewfile.common`
- install platform packages from `Brewfile.darwin` or `Brewfile.linux`
- stow the dotfiles into `$HOME`
- install TPM for tmux plugins
- create `~/.config/zsh/local.zsh` from the example file if it does not exist yet

## Layout

- `shell/` manages `~/.zshenv`
- `tmux/` manages `~/.tmux.conf`
- `xdg/` manages shared `~/.config/*` files like zsh, nvim, zed, ghostty, starship, and opencode
- `macos/` manages macOS-only config like Karabiner

## Shell config and secrets

Tracked zsh config lives in `xdg/.config/zsh/`.

- `shell/.zshenv` points zsh to `~/.config/zsh`
- `xdg/.config/zsh/.zshrc` loads modular files from `xdg/.config/zsh/rc.d/`
- `xdg/.config/zsh/.zshrc` also sources local `~/.zshrc` at the end for CLI installers that append there
- `~/.config/zsh/local.zsh` is for machine-local env vars, secrets, and overrides

Keep secrets out of git by editing `~/.config/zsh/local.zsh`, not the tracked files. If a CLI installer appends to `~/.zshrc`, those lines will still run after the tracked config loads.

## Manual restow

If you change the repo layout later, run:

```sh
./scripts/stow.sh
```

If you intentionally changed a managed file in `$HOME` and want to bring that version back into the repo before re-stowing, use:

```sh
./scripts/stow.sh --adopt
```

`--adopt` makes the existing managed file under `$HOME` become the repo version, so review the resulting `git diff` before committing.

## Notes

- `opencode.json` stays tracked in git; only local runtime files under `xdg/.config/opencode/` are ignored
- `Brewfile.darwin` installs GUI apps like Ghostty, Karabiner-Elements, and Rectangle
- Node version management uses `fnm`; the shell keeps an `nvm` compatibility function that forwards common commands to `fnm`
- `scripts/bootstrap.sh` migrates `~/.nvm/alias/default` into `fnm` when that file exists
- Ghostty uses `MesloLGS Nerd Font Mono`; install it manually if you want the exact same font locally
- Neovim plugins bootstrap themselves on first launch through LazyVim
