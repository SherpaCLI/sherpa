# --------------------------- #
#  Install a BashBox command  #
# --------------------------- #

# @file Install
# @brief Install a BeshBox from a remote repository
# @description
#
#    Can be used from anywhere.
#
#    It will:
#      * CD into ${SCD}/bbr, either exe/ or lib/ subdirectory
#      * Clone the repo in the right directory
#      * If exe/ run `sherpa build` inside
#      * If lib/ create symlink to ${SCD}/lib
#      * Update meta-data about installed packages
#
#  Usage: sherpa install bashBoxName (if published to the Registry)
#     or: sherpa install -u Https://url-of-the-repo (if not)
#

# For Variables declared in sourced files
# shellcheck disable=SC2154

use "tent/symlink"

if [[ "$1" == "install" ]]; then # Start Route

  # Shift the first argument so we can process flags
  shift

  # The name of the BashBox to be installed
  name=""
  # Direct url to a BashBox repository
  url=""
  # Optional way to enforece the type of BB
  # the type 'exe' are built, the 'lib' symlinked
  type=""

  while getopts "n:t:u:" opt; do
    case $opt in
    n) name=${OPTARG} ;;
    t) type=${OPTARG} ;;
    u) url=${OPTARG} ;;
    *) echo "Invalid flag" ;;
    esac
  done

  # Check directories existance, and create if not
  [[ ! -d "${SCD}/bbr" ]] && mkdir "${SCD}/bbr"
  [[ ! -d "${SCD}/bbr/exe" ]] && mkdir "${SCD}/bbr/exe"
  [[ ! -d "${SCD}/bbr/lib" ]] && mkdir "${SCD}/bbr/lib"

  # A second argument is needed
  # ...the project's name/folder.
  if [[ $# == 0 ]]; then
    br
    h1 "Install a BashBox from Git"
    hr "+" "-"
    p "Usage: ${em}sherpa install foobar${x}"
    p "   or: ${em}sherpa install -n='name' -t='bin' -u='url-to-repository'${x}"
    br
    p "If part of the BashBoxRegistry, the name is enough."
    p "If not, a full url to the repository is expected, with following flags:"
    p "-n name: Project's name... n=\"projName\""
    p "-t type: Either bin or lib"
    p "-u  url: Full url to the repository"

    exit 1
  fi

  # A repo url was provided
  # let's install that BashBox
  if [[ -n $url ]]; then # ifUrl

    p "name: $name"
    p "type: $type"
    p "url: $url"
    br

    # TODO: Check if the url is a real one
    if [[ -z $type ]]; then # typeCheck
      p "If the -u flag is used, -t must be also set."
      p "The -t flag must be either -t='bin' or -t='lib'"
      exit 1
    elif [[ $type != "bin" && $type != "lib" ]]; then
      p "The -t flag must be either -t='bin' or -t='lib'"
    fi # End typeCheck

    # Install a BB executable
    # - Clone the repo in ${SCD}/bbr/bin/repoName
    # - cd ${SCD}/bbr/bin/repoName
    # - sherpa build
    if [[ $type = "bin" ]]; then # installBin

      if [[ -z "$name" ]]; then
        p "The name can't be empty"
        p "use: sherpa install -n='name' -t='bin' -u='repoUrl'"
        exit 1
      fi

      # TODO: Get the project name from Sherpa.yaml
      # Or use the $name value from the -n flag
      git clone "$url" "${SCD}/bbr/bin/${name}"
      cd "${SCD}/bbr/bin/${name}" || return
      sherpa build

    fi # End installBin

    # Install a BB library
    # - Clone the repo in ${SCD}/bbr/lib/bbName
    # - Symlink that dir to {SCD}/lib/bbName
    # - Use with: use "bbName/someFileInside"
    if [[ $type = "lib" ]]; then # installLib
      # TODO: Get the project name from Sherpa.yaml
      # Or use the $name value from the -n flag
      git clone "$url" "${SCD}/bbr/lib/${name}"
      # Creating a symlink
      p "Creating a symlink into ${SCD}/lib"
      ln -s "${SCD}/bbr/lib/${name}" "${SCD}/lib/${name}"
    fi #End installLib

  fi # End ifUrl

  # The second argument is here
  # let's do something with it.
  if [[ -n $2 ]]; then # from BashBoxRegistry
    # bashbox=$2
    p "Arg no2: ${2}"
  fi #End from BashBoxRegistry

fi # End Route
