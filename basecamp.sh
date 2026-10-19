#!/usr/bin/env bash

# ----------=+=---------- #
#    Sh:erpa's Basecamp   #
# ----------------------- #

# -------------- #
#    Constants   #
# -------------- #

# Paths are overridable, so a dev checkout or a temporary
# sandbox can be used without touching the real installation.
readonly SDD="${SHERPA_DOT_DIR:-$HOME/.sherpa}"    # Sherpa Dot-Dir
readonly SCD="${SHERPA_CUSTOM_DIR:-$HOME/sherpa}"  # Sherpa Custom-Dir
readonly BIN="${SDD}/bin"                          # Symlinks and bundled tools
readonly EDITOR="${SHERPA_EDITOR:-${EDITOR:-vim}}" # Default Editor

# TODO: More explicit documentation on set -eo pipefail
set -eo pipefail

# ------------------- #
#      Functions      #
# ------------------- #

# Make sure the custom directory exists, seeded from the template.
# A fresh install has no ${SCD} until the first command that needs it,
# which used to make `sherpa new` fail with a missing boxes/ directory.
ensure_scd() {
	[[ -d "${SCD}" ]] && return 0
	[[ -d "${SDD}/templates/SCD" ]] || return 0

	mkdir -p "$(dirname "${SCD}")" 2>/dev/null || return 0
	cp -r "${SDD}/templates/SCD" "${SCD}" 2>/dev/null || return 0

	return 0
}

# Portable in-place sed. GNU sed accepts `sed -i`, BSD sed (macOS)
# insists on a backup suffix. The suffix form works on both.
sed_inplace() {
	local file="$1"
	shift
	sed -i.bak "$@" "$file" && rm -f "${file}.bak"
}

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

is_key() {
	local key=$1
	local file=$2
	yq e "has(\"$key\")" "$file" | grep -q "true"
}

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
#     Get env data from ${SCD}/env.yaml
#
env() {
	local key="$1"
	local env_file="${SCD}/env.yaml"

	if [ -z "$key" ]; then
		p "${btnWarning} MissingKey! ${x} Usage: ${em}env \"<key>\"${x}"
		exit 1
	fi

	if [[ -n "$key" && ! $(is_key "$key" "${env_file}") ]]; then
		p "${btnWarning} Oops! ${x} $key is not a valid key in ${env_file}"
		exit 1
	fi

	get_yaml_item "${key}" "${env_file}"
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
