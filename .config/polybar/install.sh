#!/usr/bin/env bash

if [[ -d ~/.config/polybar ]]; then
    mv ~/.config/polybar ~/.config/polybar-"$(date +%Y%m%d%H%M%S)"
fi

mkdir -p ~/.config/polybar

if [[ ! -d ~/.local/share/fonts ]]; then
    mkdir -p ~/.local/share/fonts
fi

cp -a {*.ini,launch*.sh,scripts} ~/.config/polybar/
cp -a fonts/* ~/.local/share/fonts/
