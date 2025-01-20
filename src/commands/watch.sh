# @file Watch
# @brief Auto-building on sources save
# @description
#
#    - Usage: sherpa w, watch
#

# ------------------------------- #
#  Watch for changes and ReBuild  #
# ------------------------------- #

if [[ "$1" == "watch" || "$1" == "w" ]]; then # watch

  if [[ ! -f "Sherpa.yaml" ]]; then
     p "${btnWarning} Oops! ${x} You are maybe not in a BashBox root."
     exit 1
  fi

  watchexec -c -w ./src -w ./data -- sherpa build

fi # End watch
