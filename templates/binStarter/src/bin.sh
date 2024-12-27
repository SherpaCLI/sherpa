# @description The main file.

# Sourcing lib/std/fmt.sh from Custom or DotDir
use "std/fmt"

# ------- Functions creating Content ------ #

# @description Main function
# Content for when the script is called
#+with no Arguments or Flags.
main() {

  h1 "--= ${PKG_NAME} =--"
  hr "=+=" "-"
  text-center "v${PKG_VERS}"
  p "Repository: ${PKG_REPO}"
  br
  p "I mean ...${txtBlue}Hello People!${x}"
  br

}

# -------- Routes & Functions Calls -------- #

# @description Main Route
# Calling the main() function
#+from the defaut route

if [[ "$#" == 0 ]]; then
  main
  exit 0
fi
