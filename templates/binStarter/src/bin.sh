use "std/fmt"

# @description Main function
# Content for when the script is called
#+with no Arguments or Flags.
main() {

  h1 " --= $(package "name") =--"
  hr "=+=" "-"
  text-center "v$(package "version")"
  br
  p "I mean ...${txtBlue}Hello People!${x}"
  br

}

# Calling the main() function
if [[ "$#" == 0 ]]; then
  main
  exit 0
fi
