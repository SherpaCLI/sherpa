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
#  Delete a local BashBox  #
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

# ------------------------ #
#  Updating a BashBox      #
# ------------------------ #

if [[ "$1" == "upBox" ]]; then # Link

  # Most of times, the same as the directory name
  # in ${SCD}/boxes/<boxName>
  boxName="$2"

  # Check if exists
  if [[ ! -d "${SCD}/bbr/bin/${boxName}" ]]; then
    br
    p "${btnWarning} Oops! ${x} There is no ${txtBlue}${boxName}${x} directory in bbr/bin/"
    br

    exit 1
  fi

  confirm "Do you want to update ${boxName}?"

  br
  p " No problem, let's go..."
  br

  # Get inside
  p "- Moving into the Directory"
  cd "${SCD}/bbr/bin/${boxName}" || return

  # Pull
  p "- Pulling latest content"
  git pull

  # Re-Build
  p "- Build again..."
  sherpa build
  br

fi # End link
