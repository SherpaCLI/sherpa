# ------------------------------- #
#   Options -flags with GetOpts   #
# ------------------------------- #

# @file Flags with GetOpts
#
# @description --- The Options file: src/help/options.sh ---
#
#	Parses the global flags, then shifts them away so $@ holds the
#	command word and its arguments. The command table itself lives in
#	src/router.sh and is the only place a command is declared.
#
#	To print text that will be ignored by -q || --quiet
#	or something only printed if -v || --verbose
#	[[ "$quiet" != "on" ]] && p "Normal log."
#	[[ "$verb" == "on" ]] && p "Verbose log."
#

# Declaring variables from std/src used in this file.
declare -g strong
declare -g txtBlue
declare -g txtGreen
declare -g x

# Flag defaults, overridden by the getopts loop below.
# Declared here rather than in a command, so a command can never
# reset them after the flags were parsed.
verb="off"
quiet="off"

# For the -c demo flag, assigning a value via myScript -c purple
color="" # String

# @description usage fn
# Printing the Help menu for -h, --help and `sherpa help`.
# The command list is read from the table in src/router.sh, so it
# can never fall out of sync with what is actually routable.
usage() {
	if [[ -t 1 ]]; then clear; fi

	h1 " Welcome, I'm your Sh:erpa 👋"
	hr "sh:help" "-"
	br
	p "${strong}${txtBlue}Usage:${x} ${txtGreen}sherpa [options] <command> [arg]${x}"
	br
	p "${strong}${txtBlue}Options:${x}"
	p "  -h | --help       Display the usage message"
	p "  -v | --version    Display the version"
	p "  -V | --verbose    Enable the verbose mode"
	p "  -q | --quiet      Continue force execution"
	br
	p "${strong}${txtBlue}Commands:${x}"

	local word aliases description
	while IFS='|' read -r word aliases description; do
		[[ -z "$word" ]] && continue
		p "  ${txtGreen}${word}${x}${aliases:+ (${aliases})} ${em}${description}${x}"
	done < <(sherpa_commands)

	br
	p "Docs & News: ${link}https://sherpa-cli.netlify.app${x}"
	p "Discord:     ${link}https://discord.gg/66bQJ6cuXG${x}"
	br
}

# Using getopts for portability, as it is a shell builtin instead of
# an external program like "getopt".
while getopts ":hvc:Vq-:" opt; do
	# Avoid placing an argument expecting option
	# before the "-:" mark, like ":hvVqc:-:"
	case $opt in
	h)
		usage
		exit 0
		;;
	v)
		cmd_version
		exit 0
		;;
	c)
		# Custom flag -c expecting a color name as argument.
		# Usage: sherpa -c purple
		color=${OPTARG}
		;;
	V)
		verb="on"
		;;
	q)
		quiet="on"
		;;
	-)
		case "${OPTARG}" in
		# --help
		help)
			usage
			exit 0
			;;
		# --version
		version)
			cmd_version
			exit 0
			;;
		# --verbose
		verbose)
			verb="on"
			;;
		# --quiet
		quiet)
			quiet="on"
			;;
		*)
			# Long flags Error handling
			echo "Unknown option --${OPTARG}" >&2
			exit 1
			;;
		esac
		;;
	\?)
		# Short flags Error handling
		echo "Invalid option: -$OPTARG" >&2
		exit 1
		;;
	:)
		# Missing required argument Error handling
		echo "Option -$OPTARG requires an argument." >&2
		exit 1
		;;
	esac
done

# Removing the global flags from the flow
shift $((OPTIND - 1))
OPTIND=1
