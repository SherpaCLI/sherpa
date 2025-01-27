#!/usr/bin/env bash

# ----------=+=---------- #
#    Sh:erpa's Basecamp   #
# ----------------------- #

# -------------- #
#    Constants   #
# -------------- #

readonly SDD="$HOME/.sherpa" # Sherpa Dot-Dir
readonly SCD="$HOME/sherpa"  # Sherpa Custom-Dir
readonly EDITOR="vim"        # Default Editor
readonly BIN="${SDD}/bin"    # Default Editor

set -e  # Exit if a command ends with a non-zero status
set -u  # Threats unset variables as errors
set -o pipefail  # Hunt non-zero exits inside pipelines

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

# --- Some Helpers --- #

# confirm "Do you want to continue with this operation?"
# echo "Continuing with the script..."
confirm() {
  br
  read -r -p "$1 (y/n): " answer
  if [[ ! $answer =~ ^[Yy]$ ]]; then
    br
    p "${btnWarning} Canceled ${x} Ok, got it."
    br

    exit 1
  fi
}

# ----- YAML Manipulation ------- #

# Move those functions to tent/yaml.sh

add_yaml_parent() {
  local key="$1"
  local file="$2"

  yq eval ".$key = {}" -i "$file"
}

add_yaml_item() {
  local key="$1"
  local value="$2"
  local file="$3"

  yq eval ".$key = \"$value\"" -i "$file"
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
#       Get the Env Data
#
env() {
  local key="$1"
  get_yaml_item "${key}" "${SCD}/env.yaml"
}


#
#
#     Get the Package data
#    --- little helper ---
#
#

package() {
  local key="$1"
  get_yaml_item "package.${key}" "${ROOT}/Sherpa.yaml"
}


#
#
#    CRUD the data from data/
#     --- 11ty Inspired ---
#
#

dataGet() {
  local file="$1"
  local key="$2"
  get_yaml_item "${key}" "${ROOT}/data/${file}.yaml"
}

dataAdd() {
  local file="$1"
  local key="$2"
  local value="$3"
  add_yaml_item "${key}" "${value}" "${ROOT}/data/${file}.yaml"
}

dataAddParent() {
  local file="$1"
  local key="$2"
  get_yaml_parent "${key}" "${ROOT}/data/${file}.yaml"
}

dataUpdate() {
  local file="$1"
  local key="$2"
  local value="$3"
  add_yaml_item "${key}" "${value}" "${ROOT}/data/${file}.yaml"
}

dataDelete() {
  local file="$1"
  local key="$2"
  remove_yaml_item "${key}" "${ROOT}/data/${file}.yaml"
}




#
# --- To be Deprecated ----
# Check to see if it can be removed
#

#
# Reliquats of early versions
# before adding the generic
# verb_yaml_item() functions
#

# add_config() {
#   local key="$1"
#   local value="$2"
#   local file="$3"

#   yq -i ".$key = \"$value\"" "$file"
# }
# add_conf() {
#   local key="$1"
#   local value="$2"

#   yq -i ".$key = \"$value\"" ./Sherpa.yaml
# }

# get_config() {
#   local key="$1"

#   yq e ".$key" Sherpa.yaml
# }

# get_conf() {
#   local key="$1"
#   local file="$2"
#   yq e ".$key" "$file"
# }

# update_config() {
#   local key="$1"
#   local newValue="$2"

#   yq -i ".$key = \"$newValue\"" ./Sherpa.yaml
# }

# remove_config() {
#   local key="$1"
#   yq -i "del(.$key)" ./Sherpa.yaml
# }
