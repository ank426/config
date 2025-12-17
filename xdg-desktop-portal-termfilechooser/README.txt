defaults in /usr/share/xdg-desktop-portal-termfilechooser
default for fzf-wrapper has been deleted

`systemctl --user restart xdg-desktop-portal.service xdg-desktop-portal-termfilechooser.service`
not sure if this is necessary but it works

also `zenity --file-selection` is useful to test
