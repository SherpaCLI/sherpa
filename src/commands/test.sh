# ----------------------- #
#  BashUnit Tests Command #
# ----------------------- #

# @file Tests
# @brief Running the tests from the ./tests dir with bashunit
# @description
#
#    To be used from the root of a Sherpa project,
#    created with "sherpa new myProject".
#
#    It will:
#      * Run the tests
#      * Display the results
#
#  Usage: sherpa [t]est
#

if [[ "$1" == "test" || "$1" == "t" ]]; then

  # Check if we are in a Sh:erpa project folder
  if [[ ! -f Sherpa.yaml ]]; then
    p "Ooops. You are probably not in a Sherpa project root."
    exit 1
  fi

  bashunit tests
fi
