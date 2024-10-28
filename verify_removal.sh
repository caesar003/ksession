#!/bin/bash

BIN_PATH="$HOME/.bin/ksession"
COMPLETION_PATH="$HOME/.bash_completion/ksession"
CONFIG_DIR="$HOME/.config/ksession"
MAN_PAGE="$HOME/.local/share/man/man1/ksession.1"

check_file() {
	if [ -e "$1" ]; then
		echo "❌ File or directory still exists: $1"
	else
		echo "✅ File or directory removed: $1"
	fi
}

echo "Checking for remaining ksession files..."

check_file "$BIN_PATH"
check_file "$COMPLETION_PATH"
check_file "$CONFIG_DIR"
check_file "$MAN_PAGE"
