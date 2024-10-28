#!/bin/bash

# Define target installation directories
BIN_DIR="$HOME/.bin"
COMPLETION_DIR="$HOME/.bash_completion"
CONFIG_DIR="$HOME/.config/ksession"
MAN_DIR="$HOME/.local/share/man/man1"

# Create necessary directories if they don't exist
mkdir -p "$BIN_DIR" "$COMPLETION_DIR" "$CONFIG_DIR/sessions" "$MAN_DIR"

# Copy binary to ~/.bin
cp bin/ksession.sh "$BIN_DIR/ksession"
chmod +x "$BIN_DIR/ksession" # Make sure it's executable

# Copy completion script to ~/.bash_completion
cp completion/ksession_completion.sh "$COMPLETION_DIR/ksession"

# Copy config files to ~/.config/ksession
cp config/sessions/sample.txt "$CONFIG_DIR/sessions/"

# Copy man page to ~/.local/share/man/man1 and update man database
cp man/ksession.1 "$MAN_DIR/"
mandb "$MAN_DIR" 2>/dev/null || echo "Man database updated."

echo "Installation complete."
echo "Make sure ~/.bin is in your PATH by adding the following line to your ~/.bashrc:"
echo "export PATH=\"\$HOME/.bin:\$PATH\""

# Reload shell completion if in an interactive session
if [ -n "$BASH_VERSION" ]; then
	source "$COMPLETION_DIR/ksession" 2>/dev/null || echo "Completion script sourced."
else
	echo "To enable auto-completion, restart your terminal or source the file manually."
fi
