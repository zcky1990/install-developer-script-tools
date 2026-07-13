#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "🚀 Starting non-sudo installation of Homebrew, asdf, Ruby, and Node.js..."

# 1. Define dynamic path based on $HOME
BREW_DIR="$HOME/homebrew"
export HOMEBREW_PREFIX="$BREW_DIR"

# 2. Clone Homebrew if it doesn't exist
if [ ! -d "$BREW_DIR" ]; then
    echo "📦 Cloning Homebrew into $BREW_DIR..."
    git clone https://github.com/Homebrew/brew.git "$BREW_DIR"
else
    echo "ℹ️ Homebrew directory already exists, skipping clone."
fi

# 3. Determine the user's shell configuration file
RC_FILE=""
if [ -n "$ZSH_VERSION" ] || [ "${SHELL##*/}" = "zsh" ]; then
    RC_FILE="$HOME/.zshrc"
elif [ -n "$BASH_VERSION" ] || [ "${SHELL##*/}" = "bash" ]; then
    RC_FILE="$HOME/.bash_profile"
    [ ! -f "$RC_FILE" ] && [ -f "$HOME/.bashrc" ] && RC_FILE="$HOME/.bashrc"
else
    echo "⚠️ Unknown shell. Defaulting config to $HOME/.bash_profile"
    RC_FILE="$HOME/.bash_profile"
fi

echo "📝 Configuring environment variables in $RC_FILE..."

# Create file if it doesn't exist
touch "$RC_FILE"

# 4. Helper function to append lines safely without duplicating
append_to_rc() {
    local line="$1"
    if ! grep -Fxq "$line" "$RC_FILE"; then
        echo "$line" >> "$RC_FILE"
    fi
}

# Add Homebrew and asdf paths dynamically to the detected RC file
append_to_rc "export HOMEBREW_PREFIX=\"$BREW_DIR\""
append_to_rc "eval \"\$($BREW_DIR/bin/brew shellenv)\""
append_to_rc "export PATH=\"$BREW_DIR/bin:\$PATH\""
append_to_rc "export PATH=\"\$HOME/.asdf/shims:\$PATH\""

# 5. Evaluate Homebrew for the current script session
eval "$($BREW_DIR/bin/brew shellenv)"
export PATH="$BREW_DIR/bin:$PATH"

# Update Homebrew formulae
echo "🔄 Updating Homebrew..."
brew update

# 6. Install asdf via Homebrew
echo "📥 Installing asdf via Homebrew..."
if ! brew list asdf &>/dev/null; then
    brew install asdf
else
    echo "ℹ️ asdf is already installed via Homebrew."
fi

# Load asdf shims into current session
export PATH="$HOME/.asdf/shims:$PATH"

# 7. Install libyaml and Ruby using asdf
echo "📦 Installing libyaml dependency..."
if ! brew list libyaml &>/dev/null; then
    brew install libyaml
else
    echo "ℹ️ libyaml is already installed via Homebrew."
fi

echo "💎 Installing Ruby 3.4.8..."
if ! asdf plugin list | grep -q "ruby"; then
    asdf plugin add ruby
fi

# Tell ruby-build exactly where to find the custom-installed libyaml
export RUBY_CONFIGURE_OPTS="--with-libyaml-dir=$(brew --prefix libyaml)"

asdf install ruby 3.4.8
asdf set ruby 3.4.8

# 8. Install Node.js using asdf
echo "🟢 Installing Node.js (latest)..."
if ! asdf plugin list | grep -q "nodejs"; then
    asdf plugin add nodejs
fi
asdf install nodejs latest
asdf set nodejs latest

echo "✅ Installation complete!"
echo "🔄 Please run: source $RC_FILE (or restart your terminal) to apply the changes."