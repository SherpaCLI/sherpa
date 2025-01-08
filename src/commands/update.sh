# @file Update
# @brief Update a remote BashBox
# @description
#
#    - Usage: sherpa update <boxName>
#

# ------------------------ #
#  Updating a BashBox      #
# ------------------------ #

if [[ "$1" == "update" ]]; then # update

  # Like in ${SCD}/boxes/<boxName>
  boxName="$2"

  # Warning if Directory not found
  if [[ ! -d "${SCD}/bbr/bin/${boxName}" ]]; then
    br
    p "${btnWarning} Oops! ${x} There is no ${txtBlue}${boxName}${x} directory in bbr/bin/"
    br

    exit 1
  fi

  #
  #   --- Output ---
  #

  confirm "Do you want to update ${boxName}?"

  br
  h2 " No problem, let's go..."
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

fi # End update
