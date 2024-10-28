#!/bin/bash

SESSION_DIR=~/.config/ksession/sessions
BIN_PATH="$HOME/.bin/ksession"
COMPLETION_PATH="$HOME/.bash_completion/ksession"
CONFIG_DIR="$HOME/.config/ksession"
MAN_PAGE="$HOME/.local/share/man/man1/ksession.1"

mkdir -p "$SESSION_DIR"

# Save state function
save_state() {
	local session_name="$1"
	if [ -z "$session_name" ]; then
		echo "Error: Session name must be provided for saving."
		exit 1
	fi
	local state_file="$SESSION_DIR/${session_name}.txt"

	kitty @ ls | jq '[.[0].tabs[] | {title: .title, cwd: .windows[0].cwd}]' >"$state_file"
	echo "Kitty state saved to $state_file"
}

# Restore state function
restore_state() {
	local session_name="$1"
	if [ -z "$session_name" ]; then
		echo "Error: Session name must be provided for restoring."
		exit 1
	fi
	local state_file="$SESSION_DIR/${session_name}.txt"

	if [ ! -f "$state_file" ]; then
		echo "No state file found at $state_file"
		exit 1
	fi

	tab_number=0
	while IFS=' ' read -r title cwd; do
		numbered_title="$((tab_number + 1)). $title"

		if [ $tab_number -eq 0 ]; then
			kitty @ set-tab-title "$numbered_title"
			kitty @ send-text "cd \"$cwd\"\n"
		else
			kitty @ launch --type=tab --tab-title="$numbered_title" --cwd="$cwd"
		fi
		((tab_number++))
	done <"$state_file"

	echo "Kitty state restored from $state_file"
}

# Destroy tabs function
destroy_tabs() {
	tabs=$(kitty @ ls | jq '.[0].tabs[].id')

	if [ $(echo "$tabs" | wc -l) -le 1 ]; then
		echo "There is only one tab open, nothing to destroy."
		exit 0
	fi

	for tab in $(echo "$tabs" | tail -n +2); do
		kitty @ close-tab --match id:$tab
	done

	echo "All tabs except one have been destroyed."
}

# List sessions function
list_sessions() {
	echo "Available sessions:"
	ls -1 "$SESSION_DIR"/*.txt 2>/dev/null | sed 's|^.*/||' | sed 's/\.txt$//'
}

# View session function
view_session() {
	local session_name="$1"
	if [ -z "$session_name" ]; then
		echo "Error: Session name must be provided for viewing."
		exit 1
	fi

	local state_file="$SESSION_DIR/${session_name}.txt"

	if [ ! -f "$state_file" ]; then
		echo "No session file found with the name $session_name."
		exit 1
	fi

	echo "Session content for $session_name:"
	while IFS= read -r line; do
		title=$(echo "$line" | awk '{print $1}')
		cwd=$(echo "$line" | awk '{print $2}')
		echo "Title: $title, CWD: $cwd"
	done <"$state_file"
}

# Uninstall function
uninstall_ksession() {
	echo "Preparing to uninstall KSession..."

	# Prompt to confirm uninstallation
	if prompt_user "You are about to uninstall KSession. Are you sure?"; then
		# Ask if user wants to delete session files
		if prompt_user "Do you want to delete all saved session files in $SESSION_DIR?"; then
			rm -rf "$CONFIG_DIR"
			echo "Deleted $CONFIG_DIR"
		else
			echo "Preserved $CONFIG_DIR"
		fi

		# Remove binary, completion script, and man page
		rm -f "$BIN_PATH" "$COMPLETION_PATH" "$MAN_PAGE"
		mandb "$HOME/.local/share/man" 2>/dev/null || echo "Man database updated."

		echo "KSession uninstallation complete."
	else
		echo "Uninstallation aborted."
	fi

	exit 0
}

# Main argument handling
case "$1" in
save | -s)
	save_state "$2"
	;;
restore | -r)
	restore_state "$2"
	;;
destroy | -d)
	destroy_tabs
	;;
list | -l)
	list_sessions
	;;
view | -v)
	view_session "$2"
	;;
uninstall | -u)
	uninstall_ksession
	;;
*)
	echo "Usage: ksession {save|-s|restore|-r|destroy|-d|list|-l|view|-v|uninstall|-u}"
	exit 1
	;;
esac
