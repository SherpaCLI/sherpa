# @file self-update.sh
# @brief Updating Sh:erpa itself
# @description
#
#    Usage `sherpa self-update`
#

# ------------------------- #
#  Updating Sh:erpa itself  #
# ------------------------- #

if [[ "$1" == "self-update" ]]; then # SelfUpdate

  # Check the arguments number
  if [[ "$#" -gt 1 ]]; then
    br
    p "${btnWarning} Too many arguments! ${x} Usage: ${em}sherpa self-update${x}"
    br
    exit 1
  fi

  confirm "Do you want to update Sh:erpa?"

  br
  h2 " Ok, let's go..."
  br

  # Get inside
  p "${txtGreen}-${x} Moving into the Directory"
  cd "${SDD}" || return

  # Pull
  p "${txtGreen}-${x} Pulling latest content"
  git fetch origin
  git reset --hard origin/master

  # Re-Build
  p "${txtGreen}-${x} Re-building the executable"
  cd src
  ./Make.sh
  br
  p "${btnSuccess} Done! ${x}"

fi # End SelfUpdate
