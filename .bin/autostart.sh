#!/bin/bash
export PATH="$HOME/.bin:$PATH"

config="config"
if [[ -n $XDG_SESSION_DESKTOP ]]; then
    config="config-$XDG_SESSION_DESKTOP"
fi

if [[ -e "$HOME/.config/autostart.sh/$config" ]]; then
    readarray COMMANDS < "$HOME/.config/autostart.sh/$config"
else
    COMMANDS=()
fi

function run {
    local connected=1
    while [[ 0 -ne $connected ]]; do
        ping -c1 -W1 herecura.eu
        connected=$?
        sleep 1
    done
    sleep 3
	oldIFS=$IFS
	IFS=$'\n'
	(
        # shellcheck disable=SC2068
		for cmd in ${COMMANDS[@]}; do
            if [[ $cmd == sleep* ]]; then
                eval "${cmd}"
            else
                sleep 0.5
                eval "${cmd} &"
            fi
		done
	)
	IFS=$oldIFS
}

cd "$HOME" || exit 1
run
