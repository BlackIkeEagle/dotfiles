#!/bin/sh

export QT_QPA_PLATFORMTHEME=gtk2
export QT_QPA_PLATFORM=wayland
export SSH_ASKPASS=/usr/lib/seahorse/ssh-askpass

export $(/usr/bin/gnome-keyring-daemon --start --components=ssh,secrets,pkcs11)

if [ -d $HOME/.bin ]; then
    if ! grep "$HOME/.bin" <<< $PATH; then
        export PATH=$HOME/.bin:$PATH
    fi
fi
