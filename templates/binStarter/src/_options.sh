# @file My Sh:erpa package

# ------------------------------- #
#   Options -flags with GetOpts   #
# ------------------------------- #

# For the -c demo flag
#+asigning a value via myScript -c purple
# color="" # String

# Function to display help text
usage() {

  h1 "$(package "name")"
  hr "help" "-"
  if [[ -n "$(package "description")" ]]; then
    p "$(package "description")"
  fi
  br
  h2 "Usage"
  p "${em}$(package "executable") [option] <command> [argument]${x}"
  h2 "Options"
  p "  -h | --help       Display the usage message"
  p "  -v | --version    Display script Version."
  #p  "  -c                Custom color via -c color."
  p "  -V | --verbose    Enable Verbose mode, if available."
  p "  -q | --quiet      Enable Quiet mode, if available."
  br
  #h2 "Commands"
  #p " * command1:  Doing this"
  #p " * command2:  Doing that"
  #br
  if [[ -n "$(package "repo")" ]]; then
    p "Repo: ${link}$(package "repo")${x}"
  fi

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
    printf "%s v%s\n" "$(package "name")" "$(package "version")"
    [[ -n "$(package "repo")" ]] && printf "Repo: %s\n" "$(package "repo")"
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
      printf "%s v%s\n" "$(package "name")" "$(package "version")"
      [[ -n "$(package "repo")" ]] && printf "Repo: %s\n" "$(package "repo")"
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
