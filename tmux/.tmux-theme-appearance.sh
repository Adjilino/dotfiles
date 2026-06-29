#!/usr/bin/env bash

set -euo pipefail

detect_appearance() {
  case "$(uname -s)" in
    Darwin)
      if defaults read -g AppleInterfaceStyle 2>/dev/null | grep -q Dark; then
        printf 'dark\n'
      else
        printf 'light\n'
      fi
      ;;
    Linux)
      local query_output

      if ! command -v dbus-send >/dev/null 2>&1; then
        printf 'dark\n'
        return
      fi

      if ! query_output="$({
        dbus-send \
          --session \
          --print-reply=literal \
          --reply-timeout=1000 \
          --dest=org.freedesktop.portal.Desktop \
          /org/freedesktop/portal/desktop \
          org.freedesktop.portal.Settings.Read \
          string:org.freedesktop.appearance \
          string:color-scheme
      } 2>/dev/null)"; then
        printf 'dark\n'
        return
      fi

      # XDG desktop portal: 0 = no preference, 1 = dark, 2 = light.
      case "$query_output" in
        *"uint32 1"*)
          printf 'dark\n'
          ;;
        *"uint32 0"*|*"uint32 2"*)
          printf 'light\n'
          ;;
        *)
          printf 'dark\n'
          ;;
      esac
      ;;
    *)
      printf 'dark\n'
      ;;
  esac
}

main() {
  case "${1:-detect}" in
    detect)
      detect_appearance
      ;;
    is-dark)
      [[ "$(detect_appearance)" == "dark" ]]
      ;;
    *)
      printf 'Unknown argument: %s\n' "$1" >&2
      return 1
      ;;
  esac
}

main "$@"
