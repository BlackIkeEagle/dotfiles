#
# bash_profile for servers
#

[[ $- != *i* ]] && return

if which tmux > /dev/null 2>&1 && [[ -z ${TMUX} ]]; then
	tmux has-session -t default
	if [[ $? -ne 0 ]]; then
		exec tmux new -s default
	else
		exec tmux a -t default
	fi
fi
