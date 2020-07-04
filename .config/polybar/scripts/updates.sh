#!/usr/bin/env bash

BAR_ICON=""

while true; do
    checkupdates=$(checkupdates)
    if [[ "" == "$checkupdates" ]]; then
        updates=0
    else
        updates=$(echo "$checkupdates" | wc -l)
    fi

    updatesinfo="$BAR_ICON $updates"

    if echo "$checkupdates" | grep "^linux\|^systemd" | grep -v 'linux-firmware' > /dev/null 2>&1; then
        echo "%{F#e53935}$updatesinfo%{F-}"
    elif [[ $updates -gt 100 ]]; then
        echo "%{F#fb8c00}$updatesinfo%{F-}"
    elif [[ $updates -gt 50 ]]; then
        echo "%{F#fdd835}$updatesinfo%{F-}"
    else
        echo "$updatesinfo"
    fi
    sleep 1800
done
