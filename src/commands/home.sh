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

declare -g em
declare -g x

# If the script is called with no arguments
if [[ "$#" == 0 ]]; then # Home Route

  clear

  h1 " Welcome to 👋 Sh:erpa"
  hr "= + =" "-" # -----------= + =-----------
  text-center "$(date +%T)"
  br
  br
  h2 "A glimpse of what we can do so far:"
  br
  p "* Modular structure instead of all-in"
  p "* GetOpt short & long Flags pre-configured"
  p "* Fetch remote Json API data"
  p "* CRUD on local .yaml data files"
  p "* Cargo'like projects management"
  p "* Pug'like semantic text output"
  p "* Custom CSS'like formating"
  p "* CDN'like loading external libs"
  p "* Oh-MyBash'like Custom directory"
  p "* Source libs with ${em}'use \"std/fmt\"'${x}"
  p "* Docs generations via Shdoc & Bashdoc"
  p "* Check syntax with ShellCheck"
  p "* Integrated Tests suite via BashUnit"
  p "* Final script minimization after docs gen'"
  p "* Compile to a binary via SHC"
  p "* Included external programs in .sherpa/bin"
  p "* Next: Somehow dependencies management & publishing"
  br
  p "$(strong "TODO:")"
  br

fi # End Home Route
