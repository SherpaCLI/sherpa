# @file Home
# @brief The screen displayed when Sh:erpa is called alone
# @description
#
#    To be used from anywhere.
#
#    It will:
#      * Display a welcome screen with some evolving data
#
#  Usage: s, sherpa
#

# shellcheck disable=SC2034
# shellcheck disable=SC2154

# Check if the SCD is installed, otherwise copy the template
[[ ! -d "$SCD" ]] && cp -r "${SDD}/templates/SCD" "${SCD}"

# Local BashBoxes
localBoxes="${SCD}/registers/localBoxes.yaml"
bbrBin="${SCD}/registers/bbrBin.yaml"

# If the script is called with no arguments
if [[ "$#" == 0 ]]; then # Home Route

  clear

  h1 " Welcome to the Basecamp 👋"
  hr "Sh:erpa" "-"
  text-center "$(date "+%b %d - %H:%M")"

  #
  #  --- LocalBoxes List ---
  #

  # Create an array of first-level directories
  mapfile -t boxes < <(find "${SCD}/boxes" -maxdepth 1 -type d -not -path "${SCD}/boxes" -printf '%f\n')
  # Remove the trailing slash from directory names
  boxes=("${boxes[@]%/}")
  # Loop through the array
  p "${txtGreen}Local BashBoxes: ${em}executable${x}"
  if [[ -z "${boxes[*]}" ]]; then
    p "${btnWarning} Empty ${x} Try: ${em}sherpa new hello${x}"
  else
    for box in "${boxes[@]}"; do
      # Print each dir name: executable
      p "* ${txtBlue}$box${x}: ${em}$(get_yaml_item "package.executable" "${SCD}/boxes/${box}/Sherpa.yaml")${x}"
    done
  fi
  br

  #
  #  --- Installed Boxes ---
  #

  # Create an array of first-level directories
  mapfile -t dirs < <(find "${SCD}/bbr/bin" -maxdepth 1 -type d -not -path "${SCD}/bbr/bin" -printf '%f\n')
  # Remove the trailing slash from directory names
  dirs=("${dirs[@]%/}")
  # Loop through the array
  p "${txtGreen}Installed BashBoxes: ${em}executable${x}"
  if [[ -z "${dirs[*]}" ]]; then
    p "${btnWarning} Empty ${x} Install something. See the Docs."
  else
    for dir in "${dirs[@]}"; do
      # Print out each dir name
      p "* ${txtBlue}$dir${x}: ${em}$(get_yaml_item "package.executable" "${SCD}/bbr/bin/${dir}/Sherpa.yaml")${x}"
    done
  fi
  br

  #
  #  --- LocalLibs List ---
  #

  # Create an array of first-level directories
  mapfile -t libs < <(find "${SCD}/lib" -maxdepth 1 -type d -not -path "${SCD}/lib" -printf '%f\n')
  # Remove the trailing slash from directory names
  libs=("${libs[@]%/}")
  # Loop through the array
  h2 " Local Libraries"
  if [[ -z "${libs[*]}" ]]; then
    p "${btnWarning} Empty ${x} Create one. Check the Docs."
  else
    for lib in "${libs[@]}"; do
      # Print out each dir name
      p "* ${txtBlue}$lib${x}"
    done
  fi
  br

  #
  #  --- Installed Libraries ---
  #

  # Create an array of first-level directories
  mapfile -t dirs < <(find "${SCD}/bbr/lib" -maxdepth 1 -type d -not -path "${SCD}/bbr/lib" -printf '%f\n')
  # Remove the trailing slash from directory names
  dirs=("${dirs[@]%/}")
  # Loop through the array
  h2 " Installed Libraries"
  if [[ -z "${dirs[*]}" ]]; then
    p "${btnWarning} Empty ${x} Install something. See the Docs."
  else
    for dir in "${dirs[@]}"; do
      # Print out each dir name
      p "* ${txtBlue}$dir${x}"
    done
  fi
  br

  # ---------------------- #
  #      Sh:erpa Links     #
  # ---------------------- #

  h3 "Join us, the coffee is still warm."
  p "Docs: ${link}http://sherpa-cli.netlify.app${x}"
  p "Github: ${link}http://github.com/SherpaCLI${x}"
  p "Discord: ${link}https://discord.gg/66bQJ6cuXG${x}"
  br

  # ---------------------- #
  #      Check Updates     #
  # ---------------------- #

  # Move inside ${SDD}
  cd "${SDD}" || exit 1

  # Fetch the latest changes from the remote
  git fetch origin

  # Check if the origin is ahead of the local branch
  if [ "$(git rev-list HEAD..origin/$(git branch --show-current) --count)" -gt 0 ]; then
    em "Updates are available. Run ${em}sherpa self-update${x} to update."
  fi

fi # End Home Route

# ----------- #
#   Aliases   #
# ----------- #

# This route is too tiny to deserve a file

if [[ "$1" == aliases ]]; then
  # Edit aliases in Aliasman file
  aliasman -e
fi
