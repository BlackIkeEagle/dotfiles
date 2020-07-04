#!/usr/bin/env bash

BAR_ICON=""

while true; do
    # refresh (fwupdmgr will limit by itself)
    fwupdmgr refresh > /dev/null 2>&1

    fwupdates=$(
        fwupdmgr get-updates 2>&1 \
            | grep -civ 'has no available\|has the latest\|no updatable devices'
    )
    if [[ $fwupdates -eq 0 ]]; then
        output="$BAR_ICON No"
    else
        output="%{F#e53935}$BAR_ICON Yes%{F-}"
    fi
    echo "$output"
    sleep 1800
done
