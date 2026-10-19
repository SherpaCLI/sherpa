# @file List
# @brief List the local BashBoxes and Libs, for humans or for machines
# @description
#
#	Reads each local manifest and reports what the package is and
#	when to reach for it. The --json form is the machine-readable
#	inventory: it is what lets an agent pick the right tool from the
#	description and interface block, without reading any source.
#
#	Works with the new schema and with older manifests that do not
#	have the interface block yet.
#
#  Usage: sherpa list [--json]
#

# Read one manifest key, returning a fallback for a missing key
# or for the "null" yq prints when the path does not exist.
pkg_field() {
	local file="$1"
	local key="$2"
	local fallback="${3:-}"
	local value

	value="$(get_yaml_item "$key" "$file" 2>/dev/null || true)"
	if [[ "$value" == "null" || -z "$value" ]]; then
		value="$fallback"
	fi

	printf "%s" "$value"
}

# Emit one JSON object per package found directly under $1.
collect_json() {
	local dir="$1"
	local type="$2"

	[[ -d "$dir" ]] || return 0

	local name manifest
	while IFS= read -r name; do
		manifest="${dir}/${name}/Sherpa.yaml"
		[[ -f "$manifest" ]] || continue

		jq -n \
			--arg name "$(pkg_field "$manifest" "package.name" "$name")" \
			--arg type "$type" \
			--arg executable "$(pkg_field "$manifest" "package.executable" "")" \
			--arg root "${dir}/${name}" \
			--arg description "$(pkg_field "$manifest" "package.description" "")" \
			--arg when "$(pkg_field "$manifest" "interface.when" "")" \
			--arg usage "$(pkg_field "$manifest" "interface.usage" "")" \
			'{name: $name, type: $type, executable: $executable, root: $root,
        description: $description, when: $when, usage: $usage}'
	done < <(list_dirs "$dir")
}

# Text output for one section: directory + heading label.
list_section() {
	local dir="$1"
	local label="$2"
	local with_exe="${3:-off}"

	h2 " ${label}"

	local found="off" name exe
	while IFS= read -r name; do
		found="on"
		if [[ "$with_exe" == "on" ]]; then
			exe="$(pkg_field "${dir}/${name}/Sherpa.yaml" "package.executable" "")"
			p "* ${txtBlue}${name}${x}${exe:+: ${em}${exe}${x}}"
		else
			p "* ${txtBlue}${name}${x}"
		fi
	done < <(list_dirs "$dir")

	[[ "$found" == "off" ]] && p " ${btnWarning} Empty ${x} Nothing here yet."
	br
}

cmd_list() {
	local json="off"

	# Drop the command word, so the flags below actually parse
	if [[ $# -gt 0 ]]; then shift; fi

	while getopts ":j-:" opt; do
		case $opt in
		j) json="on" ;;
		-)
			case "${OPTARG}" in
			json) json="on" ;;
			*)
				p "${btnWarning} Oops! ${x} Unknown flag: --${OPTARG}"
				exit 1
				;;
			esac
			;;
		*)
			echo "Invalid option: -$OPTARG" >&2
			exit 1
			;;
		esac
	done
	OPTIND=1

	# The machine-readable form: one array of objects, sorted by name.
	if [[ "$json" == "on" ]]; then
		{
			collect_json "${SCD}/boxes" "bin"
			collect_json "${SCD}/lib" "lib"
		} | jq -s 'sort_by(.name)'
		return 0
	fi

	br
	h1 " Local packages"
	hr "Sh:erpa" "-"

	list_section "${SCD}/boxes" "BashBoxes" "on"
	list_section "${SCD}/lib" "Libs"
}
