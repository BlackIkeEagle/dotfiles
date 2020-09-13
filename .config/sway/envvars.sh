#!/bin/sh

#export GDK_BACKEND=x11
export QT_QPA_PLATFORMTHEME=gtk3
export QT_QPA_PLATFORM=wayland
export SSH_ASKPASS=/usr/lib/seahorse/ssh-askpass
export GRIM_DEFAULT_DIR="$HOME/Downloads/screenshots"

# shellcheck disable=SC2046
export $(/usr/bin/gnome-keyring-daemon --start --components=ssh,secrets,pkcs11)

if [ -d "$HOME/.bin" ]; then
    if ! grep "$HOME/.bin" <<< "$PATH"; then
        export PATH="$HOME/.bin:$PATH"
    fi
fi
