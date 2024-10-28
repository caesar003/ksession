_ksession_completions() {
	local current prev opts
	current="${COMP_WORDS[COMP_CWORD]}"
	prev="${COMP_WORDS[COMP_CWORD - 1]}"
	opts="save restore destroy list -s -r -d -l"

	if [[ "$prev" == "-r" || "$prev" == "restore" ]]; then
		COMPREPLY=($(compgen -W "$(ls ~/.config/ksession/sessions/*.txt 2>/dev/null | xargs -n 1 basename | sed 's/\.txt$//')" -- "$current"))
	else
		COMPREPLY=($(compgen -W "$opts" -- "$current"))
	fi
}

# Register the completion function for the dev-session.sh script
complete -F _ksession_completions ksession
