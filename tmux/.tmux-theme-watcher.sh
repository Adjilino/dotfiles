#!/usr/bin/env bash
# Launch dark-notify watcher detached from tmux's run-shell parent.
# Triggered by ~/.tmux.conf via `run-shell -b`.

export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

pkill -x dark-notify 2>/dev/null

command -v dark-notify >/dev/null || exit 0

nohup bash -c '
  dark-notify | while IFS= read -r _; do
    tmux source-file ~/.tmux-theme.conf
    tmux refresh-client -S
  done
' </dev/null >/dev/null 2>&1 &

disown
