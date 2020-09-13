#!/usr/bin/env bash

# refresh (fwupdmgr will limit by itself)
fwupdmgr refresh > /dev/null 2>&1

fwupdates=$(
    fwupdmgr get-updates 2>&1 \
        | grep -civ 'has no available\|has the latest\|no updatable devices'
)
if [[ $fwupdates -eq 0 ]]; then
    output="No"
    class="none"
else
    output="Yes"
    class="available"
fi
echo "{\"text\": \"$output\", \"class\": \"$class\"}"
