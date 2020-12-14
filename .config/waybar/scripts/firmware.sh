#!/usr/bin/env bash

# refresh (fwupdmgr will limit by itself)
fwupdmgr refresh > /dev/null 2>&1

fwupdates=$(
    fwupdmgr get-updates 2>&1 \
        | grep -ci 'No updates available for remaining devices'
)
if [[ $fwupdates -eq 1 ]]; then
    output="No"
    class="none"
else
    output="Yes"
    class="available"
fi
echo "{\"text\": \"$output\", \"class\": \"$class\"}"
