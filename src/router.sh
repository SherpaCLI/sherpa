# @file Router
# @brief The single dispatch table: command word -> cmd_* function
# @description
#
#	Every command lives in src/commands/<name>.sh and exposes a
#	cmd_<name>() function. This router is the only place that maps a
#	command word (or its alias) to that function, so:
#
#	  * the command list has one source of truth (see sherpa_commands)
#	  * a typo is reported instead of silently doing nothing
#	  * two files can no longer shadow each other's command
#	  * each command gets a clean OPTIND, so its own flags parse
#
#	Concatenated before src/help/options.sh, so the help screen can
#	read the same table. The entry point that calls sherpa_main lives
#	in src/main.sh, concatenated last.
#
#	The cmd_* functions receive the command word as $1, exactly like
#	the old straight-line `if [[ "$1" == "cmd" ]]` blocks did. That
#	keeps each function's body untouched and makes aliases work.
#
#  Usage: (internal - see `sherpa help`)
#

# The command table: word|aliases|description
# Consumed by the router, the help screen and `sherpa list`.
sherpa_commands() {
	cat <<'COMMAND_TABLE'
home||The dashboard
help|h|Show the usage message
version|v|Show the Sh:erpa version
new||Scaffold a new BashBox or Lib
init||Scaffold a BashBox in the current directory
build|b|Combine the partials, generate the docs, link the executable
run|r|Build the package and run it
watch|w|Rebuild on every save in src/ and data/
doc|d|Generate the documentation only
test|t|Run the tests with BashUnit
compile||Compile the built script to a binary with SHC
edit|e|Open a key file in $EDITOR
links||List the symlinks in the bin directory
list|ls,boxes|List the local BashBoxes and Libs, as text or --json
localBox||Show the details of one local BashBox
rmBox||Remove a local BashBox
rmLib||Remove a local Lib
upBox||Update an installed BashBox
upLib||Update an installed Lib
install||Install a BashBox or Lib from a git repository
uninstall||Uninstall an installed BashBox or Lib
update||Update an installed BashBox or Lib
aliases||Edit the Aliases
self-update||Update Sh:erpa itself
self-test||Run Sh:erpa's own test suite
COMMAND_TABLE
}

# Print the version from the manifest, tolerating the old flat schema.
cmd_version() {
	local version
	version="$(get_yaml_item "package.version" "${SDD}/Sherpa.yaml" 2>/dev/null || true)"
	if [[ "$version" == "null" || -z "$version" ]]; then
		version="$(get_yaml_item "version" "${SDD}/Sherpa.yaml" 2>/dev/null || true)"
	fi
	printf "%s v%s\n" "Sh:erpa" "${version}"
}

sherpa_main() {
	local cmd="${1:-}"

	# Every command may touch the custom dir: make sure it is there
	ensure_scd

	case "$cmd" in
	"" | home) cmd_home "$@" ;;
	help | h) usage ;;
	version | v) cmd_version ;;
	new) cmd_new "$@" ;;
	init) cmd_init "$@" ;;
	build | b) cmd_build "$@" ;;
	run | r) cmd_run "$@" ;;
	watch | w) cmd_watch "$@" ;;
	doc | d) cmd_doc "$@" ;;
	test | t) cmd_test "$@" ;;
	compile) cmd_compile "$@" ;;
	edit | e) cmd_edit "$@" ;;
	links) cmd_links "$@" ;;
	list | ls | boxes) cmd_list "$@" ;;
	localBox | rmBox | rmLib | upLib) cmd_box "$@" ;;
	upBox) cmd_upBox "$@" ;;
	aliases) cmd_aliases ;;
	install) cmd_install "$@" ;;
	uninstall) cmd_uninstall "$@" ;;
	update) cmd_update "$@" ;;
	self-update | self-test) cmd_self_update "$@" ;;
	*)
		br
		p "${btnWarning} Oops! ${x} Unknown command: ${em}${cmd}${x}"
		p "Try ${em}sherpa help${x} for the list of commands."
		br
		exit 1
		;;
	esac
}
