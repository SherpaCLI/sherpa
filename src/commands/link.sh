# @file Link
# @brief Was used to generate a symlink
# @description
#
#    Expected to become Obsolete, as the links are
#    generate on creation via `sherpa new myscript`.
#
#    The `make` command is used to "put together" the
#    script _partials.sh files into an optimized output.
#

# ------------------------ #
#  Symlink to .sherpa/bin  #
# ------------------------ #

if [[ "$1" == "box" ]]; then # Link

  box_name="$2"
  allPackages="${SCD}/registers/allPackages.yaml"
  [[ ! -f "$allPackages" ]] && touch "$allPackages"
  localBoxes="${SCD}/registers/localBoxes.yaml"
  bbrBin="${SCD}/registers/bbrBin.yaml"
  yq eval-all 'select(fileIndex == 0) * select(fileIndex == 1)' \
    "$localBoxes" "$bbrBin" >"$allPackages"
  register="$allPackages"

  # Get the symlink name from the argument
  root="$(get_yaml_item "${box_name}.root" "$register")"
  boxType="$(get_yaml_item "${box_name}.type" "$register")"
  exe="$(get_yaml_item "package.executable" "${root}/Sherpa.yaml")"
  link="${SDD}/bin/${exe}"

  # Local Bashbox infos
  if [[ -n "$2" && "$#" == 2 ]]; then # BoxInfos
    if [[ "$root" != null ]]; then
      clear
      h1 " -= ${box_name} =-"
      hr "bash-box" "-"
      p "Some infos about it."
      br
      p "RootDir: ${em}${root}${x}"
      p "Executable: ${em}${exe}${x}"
      br

      if [[ -n "$boxType" && "$boxType" == "bbr" ]]; then
        p "Uninstall: ${em} sherpa uninstall ${box_name} ${x}"
      else
        p "To delete it: ${em}sherpa box ${box_name} delete${x}"
      fi

      hr "-" "-"
      p "Other boxes: $(yq 'keys | join(", ")' "$register")"
    fi
  fi # End BoxInfos

  # Delete a local BashBox
  if [[ "$3" == "delete" ]]; then

    # Check if an argument is provided
    if [ "$#" -ne 3 ]; then
      echo "Usage: $0 <boxName> delete"
      exit 1
    fi

    # TODO: Check if suc a box exists
    # and list exixting ones if not

    confirm "Do you really want to delete ${box_name}?"

    br
    p " Allright, pal, let's clean a little..."
    br
    # Delete Symlink
    [[ -L "$link" ]] && rm "$HOME/.sherpa/bin/${exe}"
    p "- Removed symlink: ${em}${exe}${x}"

    # Delete root direcory
    rm -rf "$root"
    p "- Removed directory: ${em}${root}${x}"

    # Delete register entry
    remove_yaml_item "$box_name" "$localBoxes"
    p "- Removed register entry: ${em}${box_name}${x}"
    br

    p "${btnSuccess} Done! ${x} ${strong}${box_name}${x} just left the camp"

  fi

fi # End link
