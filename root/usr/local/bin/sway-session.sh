#! /bin/sh

# first import environment variables from the login manager
#systemctl --user import-environment

# shellcheck disable=SC1090
if [ -e "$HOME/.config/sway/envvars.sh" ]; then
    . "$HOME/.config/sway/envvars.sh"
fi

# then start the service
## DEBUG ##
#exec /usr/bin/sway -d > $HOME/sway.log 2>&1
exec /usr/bin/sway
