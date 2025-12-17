#!/bin/sh

set -e

if [ "$6" -ge 4 ]; then
    set -x
fi

multiple="$1"
directory="$2"
save="$3"
path="$4"
out="$5"

if [ "$save" = 1 ]; then
    echo "$XDG_DOWNLOAD_DIR/$(basename "$path")" > "$out"
else
    if [ "$directory" = 0 ] && [ "$multiple" = 0 ]; then
        type=f
        m=--no-multi
        prompt='Single File > '
    elif [ "$directory" = 0 ] && [ "$multiple" = 1 ]; then
        type=f
        m=--multi
        prompt='Multiple Files > '
    elif [ "$directory" = 1 ] && [ "$multiple" = 0 ]; then
        type=d
        m=--no-multi
        prompt='Single Directory > '
    elif [ "$directory" = 1 ] && [ "$multiple" = 1 ]; then
        type=d
        m=--multi
        prompt='Multiple Directories > '
    else
        exit 1
    fi
    search="command bfs -color -type $type -mindepth 1 -printf '%P\n'"
    select="fzf $m --scheme=path --prompt '$prompt' --preview='$XDG_CONFIG_HOME/fzf/preview_command.sh {}'"
    $TERMCMD sh -c "$search 2>/dev/null | $select | sed 's|^|$HOME/|' > '$out'"
fi

# firefox
# (sleep 1 && [ -d ~/Downloads ] && [ -z "$(ls -A ~/Downloads)" ] && rmdir ~/Downloads) &
