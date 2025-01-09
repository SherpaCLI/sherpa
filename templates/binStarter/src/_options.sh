# @file My Sh:erpa package

# ------------------------------- #
#   Options -flags with GetOpts   #
# ------------------------------- #

# For the -c demo flag
#+asigning a value via myScript -c purple
color="" # String

# Function to display help text
usage() {
  echo "Usage: $0 [-h] [-v] [-V] [-q] [-c] <command>"
  echo "Options:"
  echo "  -h | --help       Display the usage message"
  echo "  -v | --version    Display script Version."
  echo "  -c                Custom color via -c color."
  echo "  -V | --verbose    Enable Verbose mode."
  echo "  -q | --quiet      Continue force execution."
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
    printf "%s v%s\n" "$(get_conf "name")" "$VERSION"
    [[ -n "$REPO" ]] && printf "Repo: %s\n" "$REPO"
    exit 0
    ;;
  c)
    # Custom flag -c expecting a color name as argument,
    #+that will be placed into the color variable.
    # Usage: myScript -c purple
    # Inside the script: echo "True, $color is a great one."
    color=${OPTARG}
    exit 0
    ;;
  V)
    # -V flag activating vebose mode
    # [[ "$verbose" == 1 ]] && echo "Chatty stuff"
    verbose=1
    exit 0
    ;;
  q)
    # -q flag activating quiet mode
    # [[ "$quiet" != 1 ]] && echo "Reasonable stuff"
    quiet=1
    exit 0
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
      verbose=1
      exit 0
      ;;
    # --quiet
    quiet)
      usage
      exit 0
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
