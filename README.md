# Non-Sudo Developer Tool Installer

A helper script designed for restricted work environments where you do not have `sudo` (administrator) privileges. This script installs **Homebrew**, **asdf**, **Ruby**, and **Node.js** entirely within your user home directory. GUI apps from Homebrew Cask are redirected to `~/Apps`.

---

## 🚀 Prerequisites

Before you begin, ensure your machine is connected to the internet. The script will automatically detect whether you are running `zsh` or `bash` and update your shell profile configuration (`.zshrc` or `.bash_profile`) accordingly.

---

## 🛠️ Installation Guide

### 1. Clone the Repository
Clone this repository to your local machine and navigate into the project directory:
```bash
git clone <your-repository-url>
cd install-developer-script-tools

```

### 2. Make the Script Executable

Give the installation script execution permissions:

```bash
chmod +x install.sh

```

### 3. Run the Script

Execute the script to start the non-sudo installation setup:

```bash
./install.sh

```

### 4. Refresh Your Shell

Once the installation finishes successfully, reload your shell configuration to apply the new environment paths:

```bash
# For Zsh users
source ~/.zshrc

# For Bash users
source ~/.bash_profile

```

---

## 📦 What this Script Installs

* **Oh My Zsh**: Installed unattended into `~/.oh-my-zsh` (requires `zsh`; skips changing the default shell).
* **Homebrew**: Installed locally at `~/homebrew` (prefix `~/homebrew`, Cellar `~/homebrew/Cellar`) without requiring root permissions.
* **Apps dir**: Creates `~/Apps` and sets `HOMEBREW_CASK_OPTS=--appdir=$HOME/Apps` for cask installs.
* **libyaml**: Standard library dependency required for Ruby compilation.
* **asdf**: Extensible version manager for managing runtimes.
* **Ruby (3.4.8)**: Evaluated and built using `libyaml`.
* **Node.js (Latest LTS/Current)**: Managed natively via `asdf`.

---

## 🔍 Troubleshooting

### Ruby Compilation Errors (`psych`)

If you previously encountered a compilation error stating `psych: Could not be configured`, the script has been updated to automatically install `libyaml` via your local Homebrew instance and export `RUBY_CONFIGURE_OPTS` to point directly to it before kicking off the `asdf install ruby` process.

```
brew install libyaml
```