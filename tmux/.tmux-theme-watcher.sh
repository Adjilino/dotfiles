#!/usr/bin/env bash

set -u

export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

runtime_dir="${TMPDIR:-/tmp}/tmux-theme-watcher-${UID}"

if ! mkdir "$runtime_dir" 2>/dev/null; then
  if [[ -f "$runtime_dir/pid" ]] && kill -0 "$(<"$runtime_dir/pid")" 2>/dev/null; then
    exit 0
  fi

  rm -rf "$runtime_dir"
  mkdir "$runtime_dir" 2>/dev/null || exit 0
fi

printf '%s\n' "$$" >"$runtime_dir/pid"
trap 'rm -rf "$runtime_dir"' EXIT INT TERM

refresh_theme() {
  tmux source-file ~/.tmux-theme.conf 2>/dev/null
  tmux refresh-client -S 2>/dev/null || true
}

if command -v dark-notify >/dev/null 2>&1; then
  dark-notify | while IFS= read -r _; do
    refresh_theme || exit 0
  done
  exit 0
fi

# Fall back to polling so appearance changes still work without dark-notify.
appearance="$(defaults read -g AppleInterfaceStyle 2>/dev/null || printf 'Light\n')"
while tmux list-sessions >/dev/null 2>&1; do
  sleep 2
  next_appearance="$(defaults read -g AppleInterfaceStyle 2>/dev/null || printf 'Light\n')"

  if [[ "$next_appearance" != "$appearance" ]]; then
    appearance="$next_appearance"
    refresh_theme || exit 0
  fi
done
