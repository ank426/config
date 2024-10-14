Dreams of autonomy arch install but:
skip the keyfile part as it negates encryption
mount esp to /efi (/boot/efi is deprecated)
no need for -C y in swap volume creation (it negates purpose of lvm)
make grub config to /boot/... only

if dual booting, install os-prober and enable it in grub
reconfigure grub after full install

Follow hyprland docs
Install gtk3

For dark theme install:
gnome-themes-extra
adwaita-qt5-git
adwaita-qt6-git
/etc/environment

Edit /etc/hosts for firefox to startup faster

Edit /etc/pacman.conf for Color and multilib (still used)

Install luarocks, ripgrep, npm, wl-clipboard for nvim

For audio:
install alsa-utils
alsamixer, then unmute master. should now work
For microphone, use internal mic and set all db gains to 0
install pipewire, lib32-pipewire, and wireplumber
install pipewire-audio, pipewire-alsa. systemctl --user enable --now pipewire
reboot once
install pipewire-pulse and systemctl --user enable --now pipewire-pulse.service for waybar

To update firmware, check arch wiki
you may need to set esp path in /etc/fwupd/fwupd.conf

Install otf-font-awesome for waybar icons
Install noto-font-cjk
Install ttf-liberation for steam (better acc to arch wiki)

Install bat for paru (aur pkg build highlighing)

Edit /etc/bluetooth/main.conf to allow experimental for seeing battery of bluetooth devices using upower

Install asus linux g14 repo and follow their guide


For xdg-ing gnupg:
export
use the systemd files (the dir comes from gpgconf --list-dirs socketdir)
make the dir and copy all files to it
chmod 700 gnupg
systemctl --user daemon-reload
systemctl restart --user gpg-agent.socket
systemctl restart --user gpg-agent.service
export sshauth stuff

In /etc/zsh/zshenv export for zshdotdir
In /etc/pulse/client.conf add cookie file


Steam:
Install steam with nvidia driver for vulkan when it asks
Install ttf-liberation
Fix DNS stuff
Steam -> Settings -> Compatibility -> Enable Steam Play for all other title -> true
For some reason it was using proton experimental so I changed it to latest

heroic:
install and use non experimental wine, wine-mono, wine-gecko
install lib32 gtk2 and gtk3
https://github.com/lutris/docs/blob/master/WineDependencies.md
https://github.com/Heroic-Games-Launcher/HeroicGamesLauncher/wiki

wine:
install wine, wine-mono, winetricks
you need to run winetricks sandbox for every wine prefix
install lutris, set it to game not Games in both storage and global config
heroic also in installation and wine prefix
sudo pacman -S --needed giflib lib32-giflib libpng lib32-libpng libldap lib32-libldap gnutls lib32-gnutls mpg123 lib32-mpg123 openal lib32-openal v4l-utils lib32-v4l-utils libpulse lib32-libpulse alsa-plugins lib32-alsa-plugins alsa-lib lib32-alsa-lib libjpeg-turbo lib32-libjpeg-turbo libxcomposite lib32-libxcomposite libxinerama lib32-libxinerama ncurses lib32-ncurses opencl-icd-loader lib32-opencl-icd-loader libxslt lib32-libxslt libva lib32-libva gtk3 lib32-gtk3 gst-plugins-base-libs lib32-gst-plugins-base-libs vulkan-icd-loader lib32-vulkan-icd-loader cups samba dosbox
sudo pacman -S --needed nvidia nvidia-utils lib32-nvidia-utils nvidia-settings vulkan-icd-loader lib32-vulkan-icd-loader

problems with taking time to boot/resume from suspend:
    fixed so ignore:
    NVIDIA ISSUE (I think):
    if 2 min boot up sucks, edit grub kernel boot parameters to add pcie_port_pm=off

    Sleep:
    sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
    then reboot (worked) or sudo systemctl restart systemd-logind.service (didn't)
    systemctl status sleep.target suspend.target hibernate.target hybrid-sleep.target
    unmask
    https://ostechnix.com/linux-tips-disable-suspend-and-hibernation/
    final: asus firmware advertises support for deep sleep but this is a scam, it only supports s2idle
    cat /sys/power/mem_sleep to see this
    edit /etc/systemd/sleep.conf and add SuspendState=freeze to fix this
    https://wiki.archlinux.org/title/Power_management/Suspend_and_hibernate#Changing_suspend_method
    undo all above

    bios downgraded to 310 (apparently 316 also has the fix so try upgrading once it releases. but it may not allow you to downgrade from 316)
    do this using ezflash by putting the downloaded bios in esp (usb didn't work)

    final fix:
    disable microSD card slot (sd card reader) in bios (security->io interface security)

    final final fix:
    bios downgraded.
    system sdcard-pci-disable.service created in /etc/systemd/system/
    enable it
    This disables pci for the sd card reader

check arch wiki for mariadb. also autocompletion

ufw:
sudo ufw limit 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw enable

edit /etc/resolv.conf for dns

proton gui vpn needs nm-applet to be executed

edit /etc/makepkg.conf and set makeflag (idk if this makes a diff)

/etc/systemd/system/kmonad.service for kmonad

install iio-sensor-proxy for screen rotation

edit sudoers (using visudo) to add insults
