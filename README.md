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

1. **Using the installation script:**

    ```bash
    git clone https://github.com/caesar003/ksession.git
    cd ksession
    chmod +x install.sh
    ./install.sh
    ```

    This installs `ksession` in `/usr/bin`, sets up bash completion, and places the manual page in `/usr/share/man/man1`.

2. **Using the `.deb` package (cleaner option):**

    Download the `.deb` package from the [releases page](https://github.com/caesar003/ksession/releases) and install it:

    ```bash
    sudo dpkg -i ksession*.deb
    ```

3. **Verify installation:**

    ```bash
    ksession --version
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

## Uninstallation

To uninstall KSession, run:

```bash
ksession -u
```

You will be prompted to confirm the uninstallation and whether to delete session files in `~/.config/ksession`.

> _(Note: This feature requires a corresponding `-u` flag implementation in the script.)_

## Configuration Files

KSession uses the following configuration directory:

-   **Session storage:**
    `~/.config/ksession/sessions/` — where saved session files are stored as `.txt`.

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
