#!/usr/bin/env bash

confirm_uninstall() {
  read -p "Are you sure you want to uninstall? This will remove ~/.sherpa and its entry from PATH (y/n): " choice
  case "$choice" in
  y | Y) return 0 ;;
  n | N)
    echo "Uninstall cancelled."
    exit 0
    ;;
  *)
    echo "Invalid input. Uninstall cancelled."
    exit 1
    ;;
  esac
}

detect_shell() {
  local current_shell=$(basename "$SHELL")
  echo "$current_shell"
}

remove_from_path() {
  local shell=$1
  local config_file=""

  case $shell in
  bash)
    config_file="$HOME/.bashrc"
    ;;
  zsh)
    config_file="$HOME/.zshrc"
    ;;
  fish)
    config_file="$HOME/.config/fish/config.fish"
    ;;
  *)
    echo "Unsupported shell: $shell"
    return 1
    ;;
  esac

  if [ -f "$config_file" ]; then
    sed -i '/# Add ~\/.sherpa\/bin to PATH/d' "$config_file"
    sed -i '/PATH.*\.sherpa\/bin/d' "$config_file"
    echo "Removed ~/.sherpa/bin from PATH in $config_file"
  else
    echo "Configuration file $config_file not found"
  fi
}

remove_sherpa_directory() {
  if [ -d "$HOME/.sherpa" ]; then
    rm -rf "$HOME/.sherpa"
    echo "Removed ~/.sherpa directory"
  else
    echo "~/.sherpa directory not found"
  fi
}

# Main execution
confirm_uninstall

shell=$(detect_shell)
remove_from_path "$shell"
remove_sherpa_directory

echo "Uninstall completed. Please restart your shell or source your configuration file for the changes to take effect."
