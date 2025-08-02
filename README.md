# KSession

KSession is a command-line tool designed to save and restore Kitty terminal sessions. It allows users to manage their terminal sessions easily by saving the state of open tabs and their working directories for future restoration.

## Table of Contents

-   [Prerequisites](#prerequisites)
-   [Installation](#installation)
-   [Usage](#usage)
-   [Uninstallation](#uninstallation)
-   [Configuration Files](#configuration-files)
-   [Manual](#manual)
-   [Contributing](#contributing)
-   [License](#license)

## Prerequisites

-   **Kitty Terminal**: KSession is specifically designed to communicate with the Kitty terminal API. You must have Kitty running for this tool to work effectively. Download it [here](https://sw.kovidgoyal.net/kitty/) if you don't have it yet. Trust me — you won't regret it.

-   **Credits**: Special thanks to [Kovid Goyal](https://kovidgoyal.net) for creating the Kitty terminal and its awesome features that make `KSession` possible.

## Installation

1. **Manual Installation:**

    ```bash
    git clone https://github.com/caesar003/ksession.git
    cd ksession

    # Make executable and add to PATH
    chmod +x bin/ksession
    export PATH="$PWD/bin:$PATH"  # Add to ~/.bashrc for persistence

    # Optional: Enable bash completion
    source share/bash-completion/completions/ksession  # Add to ~/.bashrc

    # Optional: Add manual page to MANPATH
    export MANPATH="$PWD/share/man:$MANPATH"  # Add to ~/.bashrc
    ```

    This installs `ksession` in `/usr/bin`, sets up bash completion, and places the manual page in `/usr/share/man/man1`.

2. **Build and install from source**

    ```bash
    git clone https://github.com/caesar003/ksession.git
    cd ksession

    # Build and install
    make build      # This creates .deb package in `debian/ksession*.deb`
    sudo dpkg -i debian/ksession*.deb  # Installs system-wide

    # Verify installation
    ksession --version
    ```

3. **Using the `.deb` package:**

    Download the `.deb` package from the [releases page](https://github.com/caesar003/ksession/releases) and install it:

    ```bash
    sudo dpkg -i ksession*.deb
    ```

## Usage

After installation, use the following commands:

-   **Save a session:**

    ```bash
    ksession save <session_name>
    ```

-   **Restore a session:**

    ```bash
    ksession restore <session_name>
    ```

-   **Destroy all but one tab:**

    ```bash
    ksession destroy
    ```

-   **List all saved sessions:**

    ```bash
    ksession list
    ```

-   **View a session's contents:**

    ```bash
    ksession view <session_name>
    ```

-   **Edit a session file in your editor of choice:**

    ```bash
    ksession edit <session_name>
    ```
-   **View version number:**

    ```bash
    ksession version
    ```


## Uninstallation

1. For manual installation

    ```bash
    # Remove from PATH/MANPATH in your shell config
    rm -rf ~/path/to/ksession  # Remove cloned repo
    rm -rf ~/.config/ksession  # Optional: Remove config files
    ```

2. For Package installation or using `Makefile`
    ```bash
    sudo dpkg -r ksession

    # then you want to clean configuration file
    rm -rf ~/.config/ksession  # Optional: Remove config files
    ```

## Configuration Files

KSession uses the following configuration directory:

-   **Session storage:**
    `~/.config/ksession/sessions/` — where saved session files are stored as `.txt`.

    Example session:

    ```txt
    todo ~/projects/todo
    alarm-clock ~/projects/alarm-clock
    config ~/.config
    music ~/.music
    ```

-   **Editor config:**
    `~/.config/ksession/config` — allows you to set a preferred text editor.

    Example config:

    ```bash
    EDITOR_CMD=nvim
    ```

    If not specified, it defaults to `nvim`.

## Manual

You can access the manual page with:

```bash
man ksession
```

## Contributing

Contributions are welcome! If you’d like to contribute:

1. Fork the repository.
2. Create a feature branch.
3. Submit a pull request.

Bug reports, suggestions, and improvements are appreciated.

## License

This project is licensed under the MIT License. See the LICENSE file for details.
