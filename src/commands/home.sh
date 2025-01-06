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

# Local BashBoxes
localBoxes="${SCD}/registers/localBoxes.yaml"
bbrBin="${SCD}/registers/bbrBin.yaml"

# If the script is called with no arguments
if [[ "$#" == 0 ]]; then # Home Route

  clear

  h1 " Welcome to the Basecamp 👋"
  hr "= + =" "-" # -----------= + =-----------
  text-center "$(date +%T)"
  br
  h2 " Local BashBoxes"
  p "$(yq 'keys | join(", ")' "$localBoxes")"
  br
  h2 " Installed Ones"
  p "$(yq 'keys | join(", ")' "$bbrBin")"
  br
  p "Create : sherpa new <boxName>"
  p "Details: sherpa box <boxName>"
  br
  p "Docs: ${link}http://sherpa-basecamp.vercel.app${x}"
  br

fi # End Home Route
