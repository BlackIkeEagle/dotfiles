#!/usr/bin/env bash

checkupdates=$(checkupdates)
if [[ "" == "$checkupdates" ]]; then
    updates=0
else
    updates=$(echo "$checkupdates" | wc -l)
fi

updateseverity='normal'

if echo "$checkupdates" | grep "^linux\|^systemd" | grep -v 'linux-firmware\|systemd-swap'  > /dev/null 2>&1; then
    updateseverity='critical'
elif [[ $updates -gt 100 ]]; then
    updateseverity='toomuch'
elif [[ $updates -gt 50 ]]; then
    updateseverity='many'
fi

echo "{\"text\": \"$updates\", \"class\": \"$updateseverity\"}"

