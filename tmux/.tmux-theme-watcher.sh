#!/usr/bin/env bash
# Re-source ~/.tmux-theme.conf whenever system appearance changes.
# Launched detached from tmux's `run-shell -b` (see ~/.tmux.conf).

set -euo pipefail

export PATH="/opt/homebrew/bin:/usr/local/bin:/home/linuxbrew/.linuxbrew/bin:$PATH"

THEME_SCRIPT="$HOME/.tmux-theme-appearance.sh"

refresh_tmux_theme() {
  tmux source-file "$HOME/.tmux-theme.conf"
  tmux refresh-client -S
}

watch_with_dark_notify() {
  dark-notify | while IFS= read -r _; do
    refresh_tmux_theme
  done
}

watch_with_dbus_monitor() {
  dbus-monitor --session \
    "type=signal,interface=org.freedesktop.portal.Settings,member=SettingChanged,path=/org/freedesktop/portal/desktop,arg0='org.freedesktop.appearance',arg1='color-scheme'" | while IFS= read -r line; do
    [[ "$line" == *"uint32"* ]] || continue
    refresh_tmux_theme
  done
}

watch_with_polling() {
  local current_appearance
  local next_appearance

  current_appearance="$("$THEME_SCRIPT" detect)"

  while sleep 3; do
    next_appearance="$("$THEME_SCRIPT" detect)"

    if [[ "$next_appearance" == "$current_appearance" ]]; then
      continue
    fi

    current_appearance="$next_appearance"
    refresh_tmux_theme
  done
}

run_listener() {
  case "$(uname -s)" in
    Darwin)
      if command -v dark-notify >/dev/null 2>&1; then
        watch_with_dark_notify
        return
      fi
      ;;
    Linux)
      if command -v dbus-monitor >/dev/null 2>&1; then
        watch_with_dbus_monitor
        return
      fi
      ;;
  esac

  watch_with_polling
}

main() {
  if [[ "${1:-}" == "listen" ]]; then
    run_listener
    return
  fi

  pkill -f "$HOME/.tmux-theme-watcher.sh listen" 2>/dev/null || true
  nohup bash "$HOME/.tmux-theme-watcher.sh" listen </dev/null >/dev/null 2>&1 &
}

main "$@"
