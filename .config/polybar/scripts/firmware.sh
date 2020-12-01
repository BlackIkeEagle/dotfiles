#!/usr/bin/env bash

BAR_ICON=""

while true; do
    # refresh (fwupdmgr will limit by itself)
    fwupdmgr refresh > /dev/null 2>&1

    fwupdates=$(
        fwupdmgr get-updates 2>&1 \
            | grep -ci 'No updates available for remaining devices'
    )
    if [[ $fwupdates -eq 1 ]]; then
        output="$BAR_ICON No"
    else
        output="%{F#e53935}$BAR_ICON Yes%{F-}"
    fi
    echo "$output"
    sleep 1800
done
