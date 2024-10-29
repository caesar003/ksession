#!/bin/bash

# Define paths for system-wide installation
BIN_PATH="/usr/bin"
MAN_PATH="/usr/share/man/man1"
COMPLETION_PATH="/usr/share/bash-completion/completions"
CONFIG_PATH="$HOME/.config/ksession" # Still keeping user-specific sessions here for flexibility

# Copy the main script to /usr/bin
echo "Installing ksession script to $BIN_PATH..."
sudo install -m 755 bin/ksession.sh "$BIN_PATH/ksession"

# Copy the man page to /usr/share/man/man1
echo "Installing man page to $MAN_PATH..."
sudo install -m 644 man/ksession.1 "$MAN_PATH"

# Copy the bash completion script
echo "Installing bash completion script to $COMPLETION_PATH..."
sudo install -m 644 completion/ksession_completion.sh "$COMPLETION_PATH/ksession"

# Ensure the config directory exists for sessions
echo "Creating config directory at $CONFIG_PATH for session files..."
mkdir -p "$CONFIG_PATH/sessions"
cp -r config/sessions/* "$CONFIG_PATH/sessions/"

# Update the man database
echo "Updating man database..."
sudo mandb

echo "Installation complete! You can now use 'ksession' from anywhere."
