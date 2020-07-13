#!/usr/bin/env bash

ICON_DISCONNECTED=""
ICON_CONNECTED=""

VPN_PREFIX="ovpn-"

vpninterface="$1"
name="${vpninterface##$VPN_PREFIX}"

while true; do
    if [[ "" == "$vpninterface" ]]; then
        echo "%{F#e53935}$ICON_DISCONNECTED%{F-} none"
    else
        if ip a | grep -q "$vpninterface" ; then
            echo "%{F#7cb342}$ICON_CONNECTED%{F-} $name"
        else
            echo "$ICON_DISCONNECTED $name"
        fi
    fi
    sleep 5
done
