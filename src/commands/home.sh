# @file Home
# @brief The screen displayed when Sh:erpa is called alone
# @description
#
#    To be used from anywhere.
#
#    It will:
#      * Display a welcome screen with some evolving data
#
#  Usage: sherpa
#

# We declare the variables created elsewhere
# so that Shellcheck won't yell at us when using them.
declare -g txtGreen
declare -g x

# If the script is called with no arguments
if [[ "$#" == 0 ]]; then # Home Route

  clear

  h1 " Welcome to the Basecamp 👋"
  hr "= + =" "-" # -----------= + =-----------
  text-center "$(date +%T)"
  br
  br
  h2 "What that page might become?"
  br
  p "Eventually some sort of dashboard or old-school portal."
  p "${txtGreen}Sh:erpa${x} version (local & remote), latest news & links"
  br
  p "Time will tel, but anyway ...nice to have you with us ;)"
  br

fi # End Home Route
