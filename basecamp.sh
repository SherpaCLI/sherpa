#!/usr/bin/env bash

# ----------=+=---------- #
#    Sh:erpa's Basecamp   #
# ----------------------- #

# -------------- #
#    Constants   #
# -------------- #

readonly SDD="$HOME/.sherpa"     # Sherpa Dot-Dir
readonly SCD="$HOME/code/sherpa" # Sherpa Custom-Dir
readonly EDITOR="vim"            # Default Editor
readonly BIN="${SDD}/bin"        # Default Editor

# TODO: More explicit documentation on set -eo pipefail
set -eo pipefail

# ------------------- #
#      Functions      #
# ------------------- #

# Sourcing an additional lib into the script
use() {

  local file="$1" # ex std/fmt
  local dotdir="${SDD}/lib"
  local custom="${SCD}/lib"

  if [ -f "${custom}/${file}.sh" ]; then

    source "${custom}/${file}.sh"

  elif [ -f "${dotdir}/${file}.sh" ]; then

    source "${dotdir}/${file}.sh"

  fi
}

# Github/Codeberg CDN-like, sourcing distant lib.sh files
# Default to Github, full url for anything else
import() {
  local url=""
  local repo=""
  local branch="master"
  local file=""

  while getopts "u:r:b:f:" opt; do
    case $opt in
    u) url=$OPTARG ;;
    r) repo=$OPTARG ;;
    b) branch=$OPTARG ;;
    f) file=$OPTARG ;;
    *) echo "Invalid flag" ;;
    esac
  done

  if [[ $url != "" ]]; then
    # Source the full url
    . <(curl -s "$url")
  elif [[ $repo != "" ]]; then
    # https://raw.githubusercontent.com/labbots/bash-utility/refs/heads/master/src/date.sh
    local fullUrl="https://raw.githubusercontent.com/${repo}/refs/heads/${branch}/${file}"
    # Source resulting url
    . <(curl -s "$fullUrl")
  else
    echo "Opps. Something went wrong."
    exit 1
  fi

}

# ----- YAML Manipulation ------- #

# Move those functions to tent/yaml.sh

add_yaml_item() {
  local key="$1"
  local value="$2"
  local file="$3"

  yq -i ".$key = \"$value\"" "$file"
}

get_yaml_item() {
  local key="$1"
  local file="$2"

  yq e ".$key" "$file"
}

update_yaml_item() {
  local key="$1"
  local newValue="$2"
  local file="$3"

  yq -i ".$key = \"$newValue\"" "$file"
}

remove_yaml_item() {
  local key="$1"
  local file="$2"

  yq -i "del(.$key)" "$file"
}

print_yaml_items() {
  local file="$1"

  yq eval "." "$file"
}

#
# --- To be Deprecated ----
# Check to see if it can be removed
#

#
# Get the Location of the Script
#

add_config() {
  local key="$1"
  local value="$2"
  local file="$3"

  yq -i ".$key = \"$value\"" "$file"
}
add_conf() {
  local key="$1"
  local value="$2"

  yq -i ".$key = \"$value\"" ./Sherpa.yaml
}

get_config() {
  local key="$1"

  yq e ".$key" Sherpa.yaml
}

get_conf() {
  local key="$1"
  local file="$2"
  yq e ".$key" "$file"
}

update_config() {
  local key="$1"
  local newValue="$2"

  yq -i ".$key = \"$newValue\"" ./Sherpa.yaml
}

remove_config() {
  local key="$1"
  yq -i "del(.$key)" ./Sherpa.yaml
}
