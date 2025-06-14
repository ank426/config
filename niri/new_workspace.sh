#!/bin/sh

[ $# -eq 2 ] || (echo "Must have 1 argument" && exit 1)

prev=$(niri msg --json workspaces | jq '.[] | select(.is_focused == true) | .idx')

case $1 in
  focus)
    niri msg action focus-workspace 255
    ;;
  move)
    niri msg action move-window-to-workspace 255
    ;;
  *)
    echo "First argument must be 'focus' or 'move'"
    ;;
esac

case $2 in
  down)
    niri msg action move-workspace-to-index $(($prev + 1))
    ;;
  up)
    niri msg action move-workspace-to-index $prev
    ;;
  *)
    echo "Second argument must be 'up' or 'down'"
    ;;
esac
