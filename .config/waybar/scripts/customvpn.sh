#!/usr/bin/env bash

ICON_DISCONNECTED=""
ICON_CONNECTED=""

VPN_PREFIX="ovpn-"

vpninterface="$1"
name="${vpninterface##$VPN_PREFIX}"
class="disconnected"

if [[ "" == "$vpninterface" ]]; then
    output="$ICON_DISCONNECTED none"
    class="error"
else
    if ip a | grep -q "$vpninterface" ; then
        output="$ICON_CONNECTED $name"
        class="connected"
    else
        output="$ICON_DISCONNECTED $name"
        class="disconnected"
    fi
fi

echo "{\"text\": \"$output\", \"class\": \"$class\"}"
