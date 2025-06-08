#!/bin/sh

[ $# -eq 1 ] || (echo "Must have 1 argument" && exit 1)

prev=$(niri msg --json workspaces | jq '.[] | select(.is_focused == true) | .idx')
niri msg action focus-workspace 255

case $1 in
  down)
    niri msg action move-workspace-to-index $(($prev + 1))
    ;;
  up)
    niri msg action move-workspace-to-index $prev
    ;;
  *)
    echo "Argument must be 'up' or 'down'"
    ;;
esac
