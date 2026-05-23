#!/opt/homebrew/bin/bash

declare -A working_dir
working_dir_path="$HOME/.local/share/tmux"
working_dir_file="${working_dir_path}/wd_file"

mkdir -p "${working_dir_path}"

if [[ -f "${working_dir_file}" ]]; then
	source "${working_dir_file}"
fi

function setwd() {
	name="${1}"
	path="${2}"
	
	if [[ -z "${name}" ]] || [[ -z "${path}" ]]; then
		echo "Cannot set empty alias or directory" >&2
		return 1;
	fi

	working_dir["${name}"]="${path}"
	echo "Working directory list updated: ${name} -- ${path}"
	declare -p working_dir > "${working_dir_file}"

	if [[ ! -z "${TMUX}" ]]; then
		srctmx
	fi
}

function srctmx() {
	current_session=$(tmux display-message -p '#{session_name}')
	echo "Sourcing $HOME/.bashrc to all panes in session." >&2
	tmux list-panes -a -F '#{pane_id}' | while read pane; do
			tmux send-keys -t "${pane}" 'source $HOME/.bashrc' C-m
	done
	echo "All panes updated."
}

# function cdwd() {}

# function lswd() {}



