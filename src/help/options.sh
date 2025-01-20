# ------------------------------- #
#   Options -flags with GetOpts   #
# ------------------------------- #

# @file Flags with GetOpts
#
# @descripttion --- The Options file: src/_options.sh ---
#
#  To print text that will be ignored by -q || --quiet
#  or something only printed if -v || --verbose
#  [[ "$quiet" != "on" ]] && p "Normal log."
#  [[ "$verb" == "on" ]] && p "Verbose log."
#

# Declaring variables from std/src
#+used in this file.
declare -g strong
declare -g txtBlue
declare -g txtGreen
declare -g x

# For the -c demo flag
#+asigning a value via myScript -c purple
color="" # String

# @descripttion usage fn
# Printing the Help menu for the -h and --help flags
usage() {
  # Empty the terminal page
  clear
  # Print the actual content
  h1 " Welcome, I'm your Sh:erpa 👋"
  hr "sh:help" "-"
  br
  p "${strong}${txtBlue}Usage:${x}"" ${txtGreen}sherpa [option] <command> [arg]${x}"
  br
  p "${strong}${txtBlue}Options:${x}"
  echo "  -h | --help       Display the usage message."
  echo "  -v | --version    Display script Version."
  echo "  -V | --verbose    Enable Verbose mode."
  echo "  -q | --quiet      Continue force execution."
  br
  p "${strong}${txtBlue}Commands:${x}"
  p "  ${txtGreen}build${x}, ${txtGreen}b${x}    Compile the curent package"
  #p "  ${txtGreen}check${x}, ${txtGreen}c${x}    Analyse the current package"
  #p "  ${txtGreen}clean${x}       Remove the target directory"
  p "  ${txtGreen}doc${x}, ${txtGreen}d${x}      Build the package documentation"
  p "  ${txtGreen}edit${x}, ${txtGreen}e${x}     Open files in default Editor"
  p "  ${txtGreen}init${x}        Create package in existing dir"
  p "  ${txtGreen}links${x}        Show symlinks from .sherpa/bin"
  p "  ${txtGreen}new${x}         Create a new sherpa package"
  p "  ${txtGreen}run${x}, ${txtGreen}r${x}      Build and run a binary or script"
  p "  ${txtGreen}test${x}, ${txtGreen}t${x}     Run the tests from the tests dir"
  br
  p "For the detailed list, read the docs or come talk:"
  p "Docs&News: ${link}https://sherpa-cli.netlify.app${x}"
  p "Discord:   ${link}https://discord.gg/66bQJ6cuXG${x}"
  #p "See '${txtGreen}${strong}sherpa${x}${txtGreen} help <command>${x}' for more information on a specific command."
  br

}

# Using getopts for the portability
#+as it is a shell builtin instead of
#+an external program like "getopt".
while getopts ":hvc:Vq-:" opt; do
  # Avoid placing an argument expencting option
  #+before the "-:" mark, like ":hvVqc:-:"
  case $opt in
  h)
    # Display the help/usage text from above
    usage
    exit 0
    ;;
  v)
    # -v short flag for version.
    printf "%s v%s\n" "Sh:erpa" "$(get_yaml_item "version" "${SDD}/Sherpa.yaml")"
    exit 0
    ;;
  c)
    # Custom flag -c expecting a color name as argument,
    #+that will be placed into the color variable.
    # Usage: myScript -c purple
    # Inside the script: echo "True, $color is a great one."
    color=${OPTARG}
    ;;
  V)
    # -V flag activating vebose mode
    # [[ "$verbose" == 1 ]] && echo "Chatty stuff"
    verb="on"
    ;;
  q)
    # -q flag activating quiet mode
    # [[ "$quiet" != 1 ]] && echo "Reasonable stuff"
    quiet="on"
    ;;
  -)
    # Workaround to make GetOpts
    #+mimic the --longFlags usage,
    case "${OPTARG}" in
    # --help
    help)
      usage
      exit 0
      ;;
    # --version
    version)
      printf "%s v%s\n" "$SCRIPT_NAME" "$VERSION"
      [[ -n "$REPO" ]] && printf "Repo: %s\n" "$REPO"
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
# Removing the flags from the flow
shift $((OPTIND - 1))
