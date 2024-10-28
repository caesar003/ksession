# KSession

KSession is a utility script for managing sessions in the [Kitty terminal](https://sw.kovidgoyal.net/kitty/). It allows you to save, restore, view, and destroy session states, preserving tabs and their working directories for future use.

## Installation

To install KSession, clone this repository and run the `install.sh` script:


```bash
git clone https://github.com/caesar003/ksession.git
cd ksession
./install.sh
```

### Install Locations

-   **Binary**: `~/.bin/ksession`
-   **Completion script**: `~/.bash_completion/ksession`
-   **Configuration files**: `~/.config/ksession/sessions`
-   **Manual page**: `~/.local/share/man/man1/ksession.1`

**Note**: Ensure `~/.bin` is in your PATH by adding the following line to your `~/.bashrc`:

```bash
export PATH="$HOME/.bin:$PATH"
```

After editing, reload your shell or run:

```bash
source ~/.bashrc
```

## Usage

```bash
ksession {save|-s|restore|-r|destroy|-d|list|-l|view|-v}
```

### Commands

-   `save [session_name]` | `-s [session_name]`
    Saves the current Kitty session with the specified name.

    **Example**: `ksession save my_session`

-   `restore [session_name]` | `-r [session_name]`
    Restores a saved session by its name.

    **Example**: `ksession restore my_session`

-   `destroy` | `-d`
    Closes all but one of the open Kitty tabs.

-   `list` | `-l`
    Lists all saved sessions.

-   `view [session_name]` | `-v [session_name]`
    Displays the contents of a saved session.

### Examples

-   **Save a session**:
    ```bash
    ksession save my_session
    ```
-   **Restore a session**:

    ```bash
    ksession restore my_session
    ```

-   **Destroy all but one tab**:

    ```bash
    ksession destroy
    ```

-   **List all saved sessions**:

    ```bash
    ksession list
    ```

-   **View a session's contents**:
    ```bash
    ksession view my_session
    ```

## Shell Completion

Command completion for `ksession` is installed by default to `~/.bash_completion/ksession`. This provides auto-completion for commands and session names. To enable it immediately after installation, source the file manually:

```bash
source ~/.bash_completion/ksession
```

Or restart your terminal.

## Manual Page

The manual page is installed to `~/.local/share/man/man1/ksession.1`. You can access it using:

```bash
man ksession
```

## Uninstallation

To uninstall KSession, run the `uninstall.sh` script:

```bash
./uninstall.sh
```

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.

## Author

Created by [caesar003](https://github.com/caesar003).

```
This README includes:

1. **Overview** of KSession.
2. **Installation instructions**.
3. **Usage guide** for each command.
4. **Examples** for command usage.
5. **Shell completion** and **manual page** information.
6. **Uninstallation** and **license** information.
```
