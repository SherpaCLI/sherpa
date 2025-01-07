#!/usr/bin/env bash

#
#  Testing things out with fake install destination.
#  Do not use that script for real Sh:erpa install yet.
#

source "../lib/std/fmt.sh"

# TODO: Import basecamp & std/fmt
# TODO: Use colors & Icons for output
# TODO: !More safety checks per install

_install_cli_tools() {
  # Check if webi is installed
  if ! command -v webi &>/dev/null; then
    p "${txtRed}${strong}x${x} Webi not found, installing..."
    curl -sS https://webinstall.dev/webi | bash
  else
    p "${txtRed}${strong}v${x} Webi is already installed."
  fi

  # Check if Git is installed
  if ! command -v git &>/dev/null; then
    echo "x Git not found, installing..."
    webi git@stable
  else
    echo "v Git is already installed."
  fi

  # Check if Cargo is installed
  if ! command -v cargo &>/dev/null; then
    echo "x Cargo not found, installing..."
    curl -sS https://webi.sh/rustlang | sh
    source "$HOME/.config/envman/PATH.env"
  else
    echo "v Cargo is already installed."
  fi

  # Check if Pathman is installed
  if ! command -v pathman &>/dev/null; then
    echo "x Pathman not found, installing..."
    webi pathman@stable
  else
    echo "v Pathman is already installed."
  fi

  # Check if Aliasman is installed
  if ! command -v aliasman &>/dev/null; then
    echo "x Aliasman not found, installing..."
    webi aliasman@stable
  else
    echo "v Aliasman is already installed."
  fi

  # Check if Shellcheck is installed
  if ! command -v shellcheck &>/dev/null; then
    echo "x Shellcheck not found, installing..."
    webi shellcheck@stable
  else
    echo "v Shellcheck is already installed."
  fi

  # Check if shfmt is installed
  if ! command -v shfmt &>/dev/null; then
    echo "x Shfmt not found, installing..."
    webi shfmt@stable
  else
    echo "v Shfmt is already installed."
  fi

  # Check if Pandoc is installed
  if ! command -v pandoc &>/dev/null; then
    echo "x Pandoc not found, installing..."
    webi pandoc@stable
  else
    echo "v Pandoc is already installed."
  fi

  # Check if yq is installed
  if ! command -v yq &>/dev/null; then
    echo "x Yq not found, installing..."
    webi yq@stable
  else
    echo "v Yq is already installed."
  fi

  # Check if jq is installed
  if ! command -v jq &>/dev/null; then
    echo "x Jq not found, installing..."
    webi jq@stable
  else
    echo "v Jq is already installed."
  fi

  # Check if bashunit is installed
  if ! command -v bashunit &>/dev/null; then
    echo "x Bashunit not found, installing..."
    curl -s https://bashunit.typeddevs.com/install.sh | bash
  else
    echo "x Bashunit is already installed."
  fi

  # Check if shdoc is installed
  if ! command -v shdoc &>/dev/null; then
    echo "x Shdoc not found, installing..."
    git clone --recursive https://github.com/reconquest/shdoc /tmp/shdoc
    cd /tmp/shdoc || return
    sudo make install
    rm -rf /tmp/shdoc
  else
    echo "v Shdoc is already installed."
  fi

  # Check if bashdoc is installed
  if ! command -v bashdoc &>/dev/null; then
    echo "x Bashdoc not found, installing..."
    cargo install bashdoc
  else
    echo "v Bashdoc is already installed."
  fi

  # Do the same for:
  # - viu
  # - autoexec
}

_clone_repo() {
  # Clone the repository into ~/.sherpa

  # Backup existing .sherpa
  if [[ -d "$HOME/.sherpa" ]]; then
    # Rename it to .sherpa-bkp
    # maybe add the date in the name, or something
    mv "$HOME/.sherpa" "$HOME/.sherpa-bkp"
  fi

  echo ""
  echo "Setup SherpaDotDir to ~/.sherpa"
  echo ""
  git clone -q https://github.com/SherpaBasecamp/sherpa.git "${HOME}/.sherpa"
  [[ -d "$HOME/.sherpa" ]] && echo "SDD Installed!"

  echo ""
  echo "Setup SherpaCustomDir to ~/sherpa"
  echo ""
  [[ -d "${HOME}/sherpa" ]] && mv "${HOME}/sherpa" "${HOME}/sherpa-bkp"
  cp -r "${HOME}/.sherpa/templates/SCD" "${HOME}/sherpa"
  [[ -d "${HOME}/.sherpa" ]] && echo "SCD Installed!"

}

_add_to_path() {

  # Check if ~/.zherpa directory exists and add it to the PATH using pathman
  if [ -d "$HOME/.sherpa/bin" ]; then
    echo "$HOME/.sherpa/bin directory exists, adding to PATH..."
    pathman add "$HOME/.sherpa/bin"
  else
    echo "$HOME/.sherpa/bin directory does not exist."
  fi
}

_install_cli_tools
_clone_repo
_add_to_path
