#!/usr/bin/env bash

# ----------=+=---------- #
#   Custom properties     #
# ----------------------- #

#
# Basic font-style tags
# p "Some ${strong}bold text${end} here."
#
strong="\033[1m"   # Make it Bold
disabled="\033[2m" # Make it Dimmed
em="\033[3m"       # Make it Italic
u="\033[4m"        # Make it Underlined

#
# Ending the formating sequence
# Sort of </closing> tag.
#
x="\033[0m" # Make it </end> but shorter

#
# Text Colors
# p "Here some ${txtRed}red text${end}!"
#
txtBlack="\033[30m"   # .text-red
txtRed="\033[31m"     # .text-red
txtGreen="\033[32m"   # .text-green
txtYellow="\033[33m"  # .text-yellow
txtBlue="\033[34m"    # .text-blue
txtMagenta="\033[35m" # .text-magenta
txtCyan="\033[36m"    # .text-cyan
txtWhite="\033[37m"   # .text-white

#
# Background Colors
# p "${bgGreen}Success!${end} You made it."
#
bgBlack="\033[40m"     # .bg-black
bgRed="\033[41m"       # .bg-red
bgGreen="\033[42m"     # .bg-green
bgYellow="\033[43m"    # .bg-yellow
bgBlue="\033[44m"      # .bg-blue
bgMagenta="\033[45m"   # .bg-magenta
bgCyan="\033[46m"      # .bg-cyan
bgLightGray="\033[37m" # .bg-lightGray

#
#  NerdFont Icons
#  - For personnal use to avoid portability hell.
#  Do it in your own scripts, see what's working.
#
icoLeaf="\ue22f"
icoDocker="\uf21f"

#
# Setting the txtPrimary to the user defined color
#

# TODO: Get the value from the yaml
#       or set it to Green
#primaryColor="Green"

# Chech if a string is a valid Color
is_color() {
  local color="$1"
  local valid_colors=("Black" "Red" "Green" "Yellow" "Blue" "Magenta" "Cyan" "White")

  for valid_color in "${valid_colors[@]}"; do
    if [ "$color" = "$valid_color" ]; then
      return 0
    fi
  done

  return 1
}

# Custom Primary Color for all Projects
scdYaml="${SCD}/Sherpa.yaml"
customColor="$(get_yaml_item "primaryColor" "$scdYaml")"
# Per project primaryColor:
# define something like mainColor="Magenta"
# before calling: use "std/fmt"

if is_color "$mainColor"; then
  primaryColor="$mainColor"
elif is_color "$customColor"; then
  primaryColor="$customColor"
else
  primaryColor="Green"
fi

case $primaryColor in
Black)
  txtPrimary=${txtBlack}
  ;;
Red)
  txtPrimary=${txtRed}
  ;;
Green)
  txtPrimary=${txtGreen}
  ;;
Yellow)
  txtPrimary=${txtYellow}
  ;;
Blue)
  txtPrimary=${txtBlue}
  ;;
Magenta)
  txtPrimary=${txtMagenta}
  ;;
Cyan)
  txtPrimary=${txtCyan}
  ;;
White)
  txtPrimary=${txtWhite}
  ;;
*)
  txtPrimary=""
  ;;
esac

# ----------=+=---------- #
#   Minimal Styling       #
# ----------------------- #

# Sort of CSS classes
# Usage exemple:
# p "${btnSuccess} Yes! ${x} You did it."

# shellcheck disable=SC2034
export btnSuccess="${bgGreen}${txtBlack}"
export btnWarning="${bgYellow}${txtBlack}"
export btnDanger="${bgRed}${txtWhite}"

# shellcheck disable=SC2034
export link="${u}${em}${txtBlue}"

# Just that. Some raw centered text.
# It substracts the lenth of the text
# from the total available columns,
# center it and fill the rest w/ spaces.
# https://gist.github.com/TrinityCoder/911059c83e5f7a351b785921cf7ecdaa
text-center() {

  # Declare typed variables
  local -i TERM_COLS
  local -i str_len
  local -i filler_len
  local filler

  TERM_COLS=$(tput cols)
  str_len=${#1}
  filler_len=$(((TERM_COLS - str_len) / 2))
  filler=$(printf '%*s' "$filler_len" '' | tr ' ' ' ')
  printf "%s%s\n" "$filler" "$1"
}

# ----------=+=---------- #
#   Utility Functions     #
# ----------------------- #

# Fetching API and query the JSON results with jq

# weather="https://api.weatherapi.com/v1/current.json?key=xxxHereTheKeyxxx&q=London&aqi=no"
# ---
# h1 "$(fetch $weather | jq .location.name)"
# p "Temp: $(fetch $weather | jq .current.temp_c) °C"
fetch() {
  local endpoint="$1"
  local response

  response=$(curl -s -X GET "$endpoint")
  echo "$response"
}

# ----------------=+=---------------- #
#   Semantic formating & Styling      #
# ----------------------------------- #

# H1 Heading.
# font-weight:bold;color:var(--txtPrimary);display:block
# h1 "Awesome bold and colorful title"
h1() {
  printf "\n%b%b%s%b\n" "$strong" "$txtPrimary" "$1" "$x"
}

# H2 Heading.
# display:block;font-weight:normal;color:var(--primaryColor)
h2() {
  printf "%b%s%b\n" "$txtPrimary" "$1" "$x"
}

# H3 Heading.
# color:var(--primaryColor);font-style:italic;display:block
h3() {
  printf "%b%b%s%b\n" "$txtPrimary" "$em" "$1" "$x"
}

# A line of text, aka <p> paragraph
# Got a line break like a block element
p() {
  echo -e " $1"
}

# Some inline text, with no linebreak
# span "Hi, say something: "
# reads answer
# p "${answer}? Good to know."
span() {
  printf "%s" "$1"
}

# A line break emulating <br>
# Additional spacing when needed
# avoid placing empty: echo ""
# some semantics never hurts.
br() {
  printf "\n"
}

# The <em> empthase, for Italic text
# no default linebreak
em() {
  printf "%b%s%b" "$em" "$1" "$x"
}

# Making text turn Bold!
strong() {
  printf "%b%s%b" "$strong" "$1" "$x"
}

# A simple <hr> HorizontalLine for separation
# Takes 2 arguments, The center character + fillers
# hr "+" "-" will fill the console with:
# --------+--------
hr() {
  [[ $# == 0 ]] && return 1

  # Declare typed vars
  declare -i TERM_COLS
  declare -i str_len

  TERM_COLS="$(tput cols)"
  str_len="((${#1} + 2))"
  [[ $str_len -ge $TERM_COLS ]] && {
    echo "$1"
    return 0
  }

  declare -i filler_len="$(((TERM_COLS - str_len) / 2))"
  [[ $# -ge 2 ]] && ch="${2:0:1}" || ch=" "
  filler=""
  for ((i = 0; i < filler_len; i++)); do
    filler="${filler}${ch}"
  done

  printf "%s %s %s" "$filler" "$1" "$filler"
  [[ $(((TERM_COLS - str_len) % 2)) -ne 0 ]] && printf "%s" "${ch}"
  printf "\n"

  return 0
}

# Visually style a link, underlined, italic & blue.
a() {
  echo -e "${u}${em}${txtBlue}$1${x}"
}

flex-between() {
  # Define your texts
  left_text=$1
  right_text=$2

  # Get the width of the terminal
  width=$(tput cols)

  # Calculate the position for right text
  right_position=$((width - ${#right_text}))

  # Print the left text and spaces followed by the right text
  printf "%s%*s\n" "$left_text" $((right_position - ${#left_text})) ""
  printf "%s\n" "$right_text"
}

# -------------------------

#
# Old stuff
# ...will be removed.
#
modify_value() {
  local key="$1"
  local new_value="$2"
  local filename="$3"

  # Use sed to find the key and modify its value
  sed -i -E "s/^(${key}\s*=\s*).*/\1${new_value}/" "$filename"
}
