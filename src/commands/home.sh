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

# Check if the SCD is installed, otherwise copy the template
[[ ! -d "$SCD" ]] && cp -r "${SDD}/templates/SCD" "${SCD}"

# Local BashBoxes
localBoxes="${SCD}/registers/localBoxes.yaml"
bbrBin="${SCD}/registers/bbrBin.yaml"

# If the script is called with no arguments
if [[ "$#" == 0 ]]; then # Home Route

  clear

  h1 " Welcome to the Basecamp 👋"
  hr "= + =" "-" # -----------= + =-----------
  text-center "$(date +%T)"

  #
  #  --- LocalBoxes List ---
  #

  # Create an array of first-level directories
  mapfile -t boxes < <(find "${SCD}/boxes" -maxdepth 1 -type d -not -path "${SCD}/boxes" -printf '%f\n')
  # Remove the trailing slash from directory names
  boxes=("${boxes[@]%/}")
  # Loop through the array
  h2 "Local BashBoxes & their executable name"
  if [[ -z "${boxes[*]}" ]]; then
    p "${btnWarning} Empty ${x} Try: ${em}sherpa new hello${x}"
  else
    for box in "${boxes[@]}"; do
      p "* ${txtBlue}$box${x}: ${em}$(get_yaml_item "package.executable" "${SCD}/boxes/${box}/Sherpa.yaml")${x}"
      # Add your desired actions here
    done
  fi

  #
  #  --- Installed Boxes ---
  #

  # Create an array of first-level directories
  mapfile -t dirs < <(find "${SCD}/bbr/bin" -maxdepth 1 -type d -not -path "${SCD}/bbr/bin" -printf '%f\n')
  # Remove the trailing slash from directory names
  dirs=("${dirs[@]%/}")
  # Loop through the array
  br
  h2 "Installed BashBoxes & their executable name"
  if [[ -z "${dirs[*]}" ]]; then
    p "${btnWarning} Empty ${x} Install something. See the Docs."
  else
    for dir in "${dirs[@]}"; do
      p "* ${txtBlue}$dir${x}: ${em}$(get_yaml_item "package.executable" "${SCD}/bbr/bin/${dir}/Sherpa.yaml")${x}"
      # Add your desired actions here
    done
  fi

  #
  #  --- Sh:erpa Links ---
  #

  br
  h3 "Join us, the coffee is still warm."
  p "Docs: ${link}http://sherpa-basecamp.netlify.app${x}"
  p "Github: ${link}http://github.com/SherpaBasecamp${x}"
  p "Discord: ${link}https://discord.gg/66bQJ6cuXG${x}"

fi # End Home Route
