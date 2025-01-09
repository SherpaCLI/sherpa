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
if [[ "$1" == "uninstall" ]]; then

  box_name="$2"

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

fi
