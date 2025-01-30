# @file Box
# @brief Commands related to some Box Management
# @description
#
#    - localBox: details about a local BashBox
#    - rmBox : Removing a local BashBox
#    - upBox : Updating a remote BashBox
#

# ------------------------ #
#  Local BashBox Infos     #
# ------------------------ #

if [[ "$1" == "localBox" ]]; then # localBox

  # Like in ${SCD}/boxes/<boxName>
  boxName="$2"

  # Warning if Directory not found
  if [[ ! -d "${SCD}/boxes/${boxName}" ]]; then
    br
    p "There is no ${txtBlue}${boxName}${x} directory in boxes/"
    br

    exit 1
  fi

  # Data Variables
  yaml="${SCD}/boxes/${boxName}/Sherpa.yaml"
  exe="$(get_yaml_item "package.executable" "$yaml")"

  #
  #   --- Output ---
  #

  clear
  h1 " ${boxName}"
  hr "BashBox" "-"

  # Meta data
  # Add: description, author, licence, docs, repo
  p "- Root: ${SCD}/boxes/${boxName}"
  p "- Executable: ${em}${exe}${x}"
  br
  p "${txtDanger} Delete ${x} Usage: ${em}sherpa rmBox ${boxName}${x}"

fi # End localBox

# ------------------------ #
#  Delete a local BashBox  #
# ------------------------ #

if [[ "$1" == "rmBox" ]]; then # rmBox

  # Like in ${SCD}/boxes/<boxName>
  boxName="$2"

  # Warning if Directory not found
  if [[ ! -d "${SCD}/boxes/${boxName}" ]]; then
    br
    p "${btnWarning} Oops! ${x} There is no ${txtBlue}${boxName}${x} directory in boxes/"
    br

    exit 1
  fi

  # Data Variables
  root="${SCD}/boxes/${boxName}"
  exe="$(get_yaml_item "package.executable" "${root}/Sherpa.yaml")"
  link="${SDD}/bin/${exe}"
  localBoxes="${SCD}/registers/localBoxes.yaml"

  #
  #   --- Output ---
  #

  confirm "Do you really want to delete ${boxName}?"
  br
  h2 " Allright, let's clean a little..."
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

  exit 0

fi # End rmBox

# ---------------------------- #
#  Delete a local BashBox Lib  #
# ---------------------------- #

if [[ "$1" == "rmLib" ]]; then # rmLib

  # Like in ${SCD}/boxes/<boxName>
  libName="$2"

  # Warning if Directory not found
  if [[ ! -d "${SCD}/lib/${libName}" ]]; then
    br
    p "${btnWarning} Oops! ${x} There is no ${txtBlue}${libName}${x} directory in lib/"
    br

    exit 1
  fi

  # Data Variables
  root="${SCD}/lib/${libName}"
  localLibs="${SCD}/registers/localLibs.yaml"

  #
  #   --- Output ---
  #

  confirm "Do you really want to delete ${libName}?"
  br
  h2 " Allright, let's clean a little..."
  br

  # Delete root direcory
  rm -rf "$root"
  p "- Removed directory: ${em}${root}${x}"

  # Delete register entry
  remove_yaml_item "$libName" "$localLibs"
  p "- Removed register entry: ${em}${libName}${x}"
  br

  p "${btnSuccess} Done! ${x} ${strong}${libName}${x} just left the camp"
  br

  exit 0

fi # End rmLib

# ---------------------------- #
#  Update a local BashBox Lib  #
# ---------------------------- #

if [[ "$1" == "upLib" ]]; then # upLib

  # Like in ${SCD}/lib/<libName>
  libName="$2"

  # Warning if Directory not found
  if [[ ! -d "${SCD}/lib/${libName}" ]]; then
    br
    p "${btnWarning} Oops! ${x} There is no ${txtBlue}${libName}${x} directory in lib/"
    br

    exit 1
  fi

  #
  #   --- Output ---
  #

  confirm "Do you want to update ${libName}?"

  br
  h2 " No problem, let's go..."
  br

  # Get inside
  p "- Moving into the Directory"
  cd "${SCD}/lib/${libName}" || return

  # Pull
  branch="$(git remote show origin | sed -n '/HEAD branch/s/.*: //p')"
  p "- Reset from origin/${branch}"
  br
  git fetch origin "$branch"

  if git reset --hard origin/"$branch"; then
    br
    p "${btnSuccess} Done! ${x} ${libName} is updated."
    br
  else
    br
    p "${btnWarning} Oops! ${x} Command exited with code ${?}"
    br
  fi

fi # End upLib
