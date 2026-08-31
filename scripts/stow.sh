#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

log() {
  printf '==> %s\n' "$*"
}

usage() {
  printf '%s\n' \
    "Usage: ./scripts/stow.sh [--adopt]" \
    "" \
    "Options:" \
    "  --adopt  Import existing managed files from \$HOME into the repo before stowing" \
    "  -h, --help  Show this help message"
}

detect_brew_bin() {
  if [[ -x "/opt/homebrew/bin/brew" ]]; then
    printf '/opt/homebrew/bin/brew\n'
    return
  fi

  if [[ -x "/home/linuxbrew/.linuxbrew/bin/brew" ]]; then
    printf '/home/linuxbrew/.linuxbrew/bin/brew\n'
    return
  fi

  if command -v brew >/dev/null 2>&1; then
    command -v brew
    return
  fi

  return 1
}

activate_homebrew_if_available() {
  local brew_bin

  if ! brew_bin="$(detect_brew_bin 2>/dev/null)"; then
    return
  fi

  eval "$("$brew_bin" shellenv)"
}

resolve_path() {
  python3 - "$1" <<'PY'
import os
import sys

print(os.path.realpath(sys.argv[1]))
PY
}

remove_repo_link() {
  local target_path="$1"
  local resolved_target

  if [[ ! -L "$target_path" ]]; then
    return
  fi

  resolved_target="$(resolve_path "$target_path")"

  case "$resolved_target" in
    "$REPO_ROOT"/*)
      log "Removing stale link $target_path"
      rm "$target_path"
      ;;
  esac
}

cleanup_legacy_layout() {
  local legacy_path
  local legacy_paths=(
    "$HOME/.aerospace.toml"
    "$HOME/.config"
    "$HOME/.zshrc"
    "$HOME/.tmux.conf"
    "$HOME/.config/aerospace"
    "$HOME/.config/ghostty"
    "$HOME/.config/karabiner"
    "$HOME/.config/nvim"
    "$HOME/.config/opencode"
    "$HOME/.config/starship.toml"
  )

  for legacy_path in "${legacy_paths[@]}"; do
    remove_repo_link "$legacy_path"
  done
}

package_names() {
  case "$(uname -s)" in
    Darwin)
      printf 'shell\ntmux\nxdg\npi\nmacos\n'
      ;;
    Linux)
      printf 'shell\ntmux\nxdg\npi\n'
      ;;
    *)
      printf 'Unsupported platform: %s\n' "$(uname -s)" >&2
      exit 1
      ;;
  esac
}

main() {
  local adopt_mode=0
  local packages=()
  local stow_args=(--no-folding --restow)

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --adopt)
        adopt_mode=1
        stow_args+=(--adopt)
        ;;
      -h|--help)
        usage
        return 0
        ;;
      *)
        printf 'Unknown argument: %s\n\n' "$1" >&2
        usage >&2
        return 1
        ;;
    esac

    shift
  done

  activate_homebrew_if_available

  if ! command -v stow >/dev/null 2>&1; then
    printf 'stow is required but is not available on PATH. Install it with Homebrew or run scripts/bootstrap.sh.\n' >&2
    exit 1
  fi

  cleanup_legacy_layout

  while IFS= read -r package_name; do
    packages+=("$package_name")
  done < <(package_names)

  if [[ "$adopt_mode" -eq 1 ]]; then
    log "Stowing packages with --adopt: ${packages[*]}"
  else
    log "Stowing packages: ${packages[*]}"
  fi

  mkdir -p "$HOME/.config" "$HOME/.config/zsh"
  stow --dir="$REPO_ROOT" --target="$HOME" "${stow_args[@]}" "${packages[@]}"
}

main "$@"
