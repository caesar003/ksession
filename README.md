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

- **Kitty Terminal**: KSession is specifically designed to communicate with the Kitty terminal API. You must have Kitty running for this tool to work effectively. Dowload it [here](https://sw.kovidgoyal.net/kitty/) if you don't have it yet. Trust me you wont regret it. 

- **Credits**: Special thanks to [Kovid Goyal](https://kovidgoyal.net) for creating the Kitty terminal and its awesome features that make `KSession` possible.


## Installation

1. **Using the installation script.**

    - Clone the repository:

        ```bash
        git clone https://github.com/caesar003/ksession.git
        cd ksession
        ```

    - Make the installation script executable:

        ```bash
        chmod +x install.sh
        ```

    - Run the installation script:

        ```bash
        ./install.sh
        ```

        This will install `ksession` in `/usr/bin`, set up the completion script, and place the manual page in `/usr/share/man/man1`.

2. Using the `.deb` package (cleaner Option)

    - Alternatively, you download the `.deb` package from the [releases page](https://github.com/caesar003/ksession/releases) and install it normally:
        ```sh
        sudo dpkg -i ksession*.deb
        ```

3. Verify Installation:

    ```sh
    ksession --version
    ```

## Usage

After installation, you can use the following commands:

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

-   **Uninstall KSession:**
    ```bash
    ksession -u
    ```

## Uninstallation

To uninstall KSession, run the following command:

```bash
ksession -u
```

You will be prompted to confirm the uninstallation and choose whether to delete the session files in `~/.config/ksession`. This ensures that the process is not done accidentally.

## Configuration Files

KSession uses a configuration directory located at `~/.config/ksession/sessions`, where session files are stored. You can manually edit or remove these files as needed.

## Manual

You can access the manual page for KSession by running:

```bash
man ksession
```

## Contributing

Contributions are welcome! If you would like to contribute to KSession, please fork the repository and create a pull request.

## License

This project is licensed under the MIT License. See the LICENSE file for details.
