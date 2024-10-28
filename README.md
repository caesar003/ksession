# KSession

KSession is a command-line tool designed to save and restore Kitty terminal sessions. It allows users to manage their terminal sessions easily by saving the state of open tabs and their working directories for future restoration.

## Table of Contents
- [Installation](#installation)
- [Usage](#usage)
- [Uninstallation](#uninstallation)
- [Configuration Files](#configuration-files)
- [Manual](#manual)
- [Contributing](#contributing)
- [License](#license)

## Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/caesar003/ksession.git
   cd ksession
   ```

2. Make the installation script executable:

   ```bash
   chmod +x install.sh
   ```

3. Run the installation script:

   ```bash
   ./install.sh
   ```

   This will install `ksession` in `~/.bin`, set up the completion script, and place the manual page in `~/.local/share/man/man1`. Make sure to add `~/.bin` to your PATH by adding the following line to your `~/.bashrc`:

   ```bash
   export PATH="$HOME/.bin:$PATH"
   ```

## Usage

After installation, you can use the following commands:

- **Save a session:**
  ```bash
  ksession save <session_name>
  ```

- **Restore a session:**
  ```bash
  ksession restore <session_name>
  ```

- **Destroy all but one tab:**
  ```bash
  ksession destroy
  ```

- **List all saved sessions:**
  ```bash
  ksession list
  ```

- **View a session's contents:**
  ```bash
  ksession view <session_name>
  ```

- **Uninstall KSession:**
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

