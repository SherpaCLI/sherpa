# @file Uninstall
# @brief Delete a remode BashBox and things tied to it
# @description
#
#    The `make` command is used to "put together" the
#    script _partials.sh files into an optimized output.
#

# ------------------------ #
#  Symlink to .sherpa/bin  #
# ------------------------ #

# Delete a local BashBox
if [[ "$1" == "uninstall" ]]; then # Uninstall

  # Shift the first argument so we can process flags
  shift

  # The name of the BashBox to be installed
  name=""
  # Optional way to enforece the type of BB
  # the type 'exe' are built, the 'lib' symlinked
  type="bin"

  while getopts "n:t:" opt; do
    case $opt in
    n) name=${OPTARG} ;;
    t) type=${OPTARG} ;;
    *) echo "Invalid flag" ;;
    esac
  done

  # A second argument is needed
  # ...the project's name/folder.
  if [[ $# == 0 ]]; then
    br
    h1 " Uninstall an Executable or Library"

    hr "+" "-"
    p " ${em}sherpa uninstall -n \"name\" -t \"bin\"${x}"
    br
    p "-n name: Project's name... n=\"projName\""
    p "-t type: Either bin or lib"

    exit 1
  fi

  # A Box or Lib name was provided
  if [[ -n "$name" ]]; then # We Have A Name

    p "name: $name"
    p "type: $type"
    br

    if [[ -z $type ]]; then # typeCheck
      p "If the -n flag is used, -t must be also set."
      p "The -t flag must be either -t='bin' or -t='lib'"
      exit 1
    elif [[ $type != "bin" && $type != "lib" ]]; then
      p "The -t flag must be either -t='bin' or -t='lib'"
    fi # End typeCheck

    #                             #
    # --- Uninstall a BashBox --- #
    #                             #

    if [[ "$type" == "bin" ]]; then # Uninstall Box

      box_name="$name"
      register="${SCD}/registers/bbrBin.yaml"

      # Get the symlink name from the argument
      root="${SCD}/bbr/bin/${box_name}"
      exe="$(get_yaml_item "package.executable" "${root}/Sherpa.yaml")"
      link="${SDD}/bin/${exe}"

      # Check if an argument is provided
      if [ "$#" -ne 2 ]; then
        echo "Usage: sherpa uninstall <boxName>"
        exit 1
      fi

      #                   #
      #  --- Output ----  #
      #                   #

      confirm "Do you really want to uninstall ${box_name}?"

      br
      h2 " Allright, let's clean a little..."
      br
      # Delete Symlink
      [[ -L "$link" ]] && rm "$HOME/.sherpa/bin/${exe}"
      p "${txtGreen}-${x} Removed symlink: ${em}${exe}${x}"

      # Delete root direcory
      rm -rf "$root"
      p "${txtGreen}-${x} Removed directory: ${em}${root}${x}"

      # Delete register entry
      remove_yaml_item "$box_name" "$register"
      p "${txtGreen}-${x} Removed register entry: ${em}${box_name}${x}"
      br

      p "${btnSuccess} Done! ${x} ${strong}${box_name}${x} just left the camp"
      br
    fi # end Uninstall Box

    #                             #
    # --- Uninstall a Library --- #
    #                             #

    if [[ "$type" == "lib" ]]; then # Uninstall Box

      lib_name="$name"
      register="${SCD}/registers/bbrLib.yaml"

      # Get the symlink name from the argument
      root="${SCD}/bbr/lib/${lib_name}"
      link="${SCD}/lib/${name}"

      # Check if an argument is provided
      # if [ "$#" -ne 2 ]; then
      #   echo "Usage: sherpa uninstall <boxName>"
      #   exit 1
      # fi

      #                   #
      #  --- Output ----  #
      #                   #

      confirm "Do you really want to uninstall ${lib_name}?"

      br
      h2 " Allright, let's clean a little..."
      br
      # Delete Symlink
      [[ -L "$link" ]] && rm "$link"
      p "${txtGreen}-${x} Removed symlink: ${em}${exe}${x}"

      # Delete root direcory
      rm -rf "$root"
      p "${txtGreen}-${x} Removed directory: ${em}${root}${x}"

      # Delete register entry
      remove_yaml_item "$lib_name" "$register"
      p "${txtGreen}-${x} Removed register entry: ${em}${lib_name}${x}"
      br

      p "${btnSuccess} Done! ${x} ${strong}${lib_name}${x} just left the camp"
      br
    fi # end Uninstall Box

  fi # end We Have A Name

fi # end Uninstall
