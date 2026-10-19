# @file Home
# @brief The dashboard, displayed when Sh:erpa is called alone
# @description
#
#	To be used from anywhere.
#
#	It will:
#	  * Display a welcome screen with some evolving data
#	  * List the local and installed BashBoxes and Libs
#	  * Check for a new Sh:erpa at most once a day
#
#	The update check is cached, and it runs in a subshell: the old
#	version changed the caller's directory and hit the network on
#	every single invocation.
#
#  Usage: s, sherpa
#

# shellcheck disable=SC2034
# shellcheck disable=SC2154

# Direct sub-directory names of $1, one per line. Globbing rather
# than find, so this also works with BSD userland (macOS).
list_dirs() {
	local dir="$1"
	local entry

	[[ -d "$dir" ]] || return 0

	for entry in "$dir"/*/; do
		[[ -d "$entry" ]] || continue
		basename "$entry"
	done
}

# One dashboard section: directory + heading label.
dashboard_section() {
	local dir="$1"
	local label="$2"
	local with_exe="${3:-off}"

	local found="off" name exe

	h2 " ${label}"

	while IFS= read -r name; do
		found="on"
		if [[ "$with_exe" == "on" ]]; then
			exe="$(get_yaml_item "package.executable" "${dir}/${name}/Sherpa.yaml" 2>/dev/null || true)"
			[[ "$exe" == "null" ]] && exe=""
			p "* ${txtBlue}${name}${x}${exe:+: ${em}${exe}${x}}"
		else
			p "* ${txtBlue}${name}${x}"
		fi
	done < <(list_dirs "$dir")

	[[ "$found" == "off" ]] && p " ${btnWarning} Empty ${x} Nothing here yet."
	br
}

# Look for a newer Sh:erpa on the remote, at most once a day.
# Writes ${SDD}/.update-check as a timestamp, and appends
# .available when an update is actually waiting.
check_for_updates() {
	local cache="${SDD}/.update-check"
	local now last

	now="$(date +%s)"

	if [[ -f "$cache" ]]; then
		last="$(cat "$cache" 2>/dev/null || echo 0)"
		[[ "$last" =~ ^[0-9]+$ ]] || last=0
		((now - last < 86400)) && return 0
	fi

	printf "%s" "$now" >"$cache"

	# Subshell: never leaves the caller in another directory,
	# and a missing network is not an error.
	(
		cd "${SDD}" || exit 0
		git fetch origin -q 2>/dev/null || exit 0

		branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)" || exit 0
		[[ "$branch" == "HEAD" ]] && exit 0

		ahead="$(git rev-list "HEAD..origin/${branch}" --count 2>/dev/null || echo 0)"
		[[ "$ahead" -gt 0 ]] && printf "yes" >"${cache}.available"
	)

	return 0
}

cmd_home() {
	# Bootstrap the custom directory from the template when missing
	ensure_scd

	if [[ -t 1 ]]; then clear; fi

	h1 " Welcome to the Basecamp 👋"
	hr "Sh:erpa" "-"
	text-center "$(date "+%b %d - %H:%M")"

	dashboard_section "${SCD}/boxes" "Local BashBoxes" "on"
	dashboard_section "${SCD}/bbr/bin" "Installed BashBoxes" "on"
	dashboard_section "${SCD}/lib" "Local Libraries"
	dashboard_section "${SCD}/bbr/lib" "Installed Libraries"

	h3 "Join us, the coffee is still warm."
	p "Docs: ${link}https://sherpa-cli.netlify.app${x}"
	p "Github: ${link}https://github.com/SherpaCLI${x}"
	p "Discord: ${link}https://discord.gg/66bQJ6cuXG${x}"
	br

	check_for_updates

	if [[ -f "${SDD}/.update-check.available" ]]; then
		p "${btnWarning}!${x} A new Sh:erpa is available: ${em}sherpa self-update${x}"
		br
	fi
}

cmd_aliases() {
	# Edit the aliases in the Aliasman file
	aliasman -e
}
