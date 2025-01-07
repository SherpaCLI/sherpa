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

if [[ "$1" == "rmBox" ]]; then # Link

  # Most of times, the same as the directory name
  # in ${SCD}/boxes/<boxName>
  boxName="$2"

  # Check if exists
  if [[ ! -d "${SCD}/boxes/${boxName}" ]]; then
    br
    p "${btnWarning} Oops! ${x} There is no ${txtBlue}${boxName}${x} directory in boxes/"
    br

    exit 1
  fi

  root="${SCD}/boxes/${boxName}"
  exe="$(get_yaml_item "package.executable" "${root}/Sherpa.yaml")"
  link="${SDD}/bin/${exe}"
  localBoxes="${SCD}/registers/localBoxes.yaml"

  confirm "Do you really want to delete ${boxName}?"

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
  remove_yaml_item "$boxName" "$localBoxes"
  p "- Removed register entry: ${em}${boxName}${x}"
  br

  p "${btnSuccess} Done! ${x} ${strong}${boxName}${x} just left the camp"
  br

fi # End link
