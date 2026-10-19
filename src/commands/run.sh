# @file Run
# @brief Build the package and run it
# @description
#
#	To be used from the root of a BashBox, created with
#	"sherpa new myProject".
#
#	It will:
#	  * Build the package, exactly like `sherpa build`
#	  * Execute the freshly built script
#	  * Forward any extra argument to that script
#
#	The build is the same code path as `sherpa build`, so the two can
#	no longer drift apart. The script is executed from target/local,
#	not through the symlink, so it is always the build you just made.
#
#  Usage: sherpa r, run [args...]
#

# shellcheck disable=SC2154

cmd_run() {
	# Drop the command word: what is left goes to the script
	if [[ $# -gt 0 ]]; then shift; fi

	local finalScript

	build_package "off"

	finalScript="$(get_yaml_item "package.executable" "Sherpa.yaml")"
	if [[ "$finalScript" == "null" || -z "$finalScript" ]]; then
		p "${btnWarning} Oops! ${x} ${em}package.executable${x} is missing from Sherpa.yaml"
		exit 1
	fi

	./"target/local/${finalScript}" "$@"
}
