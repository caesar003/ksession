_ksession_completions() {
	local current prev opts
	current="${COMP_WORDS[COMP_CWORD]}"
	prev="${COMP_WORDS[COMP_CWORD - 1]}"
	opts="save restore destroy list uninstall -s -r -d -l -u"

	if [[ -d ~/.config/ksession/sessions ]]; then
		if [[ "$prev" == "-r" || "$prev" == "restore" ]]; then
			COMPREPLY=($(compgen -W "$(ls ~/.config/ksession/sessions/*.txt 2>/dev/null | xargs -n 1 basename | sed 's/\.txt$//')" -- "$current"))
		else
			COMPREPLY=($(compgen -W "$opts" -- "$current"))
		fi
	else
		COMPREPLY=($(compgen -W "$opts" -- "$current"))
	fi
}

complete -F _ksession_completions ksession
