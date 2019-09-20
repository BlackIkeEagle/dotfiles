#!/bin/bash
export PATH="$HOME/.bin:$PATH"

if [[ -e "$HOME/.config/autostart.sh/config" ]]; then
    readarray COMMANDS < "$HOME/.config/autostart.sh/config"
else
    COMMANDS=()
fi

function run {
    local connected=1
    while [[ 0 -ne $connected ]]; do
        ping -c1 herecura.eu
        connected=$?
        sleep 1
    done
    sleep 3
	oldIFS=$IFS
	IFS=$'\n'
	(
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

run &
