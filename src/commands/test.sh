# @file Test
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
#  Usage: sherpa t, test
#

# ----------------------- #
#  BashUnit Tests Command #
# ----------------------- #

if [[ "$1" == "test" || "$1" == "t" ]]; then # test

  # Check if we are in a Sh:erpa project folder
  if [[ ! -f Sherpa.yaml ]]; then
    br
    p "${btnWarning} Oops! ${x} Probably not in a Sherpa project root."
    br
    exit 1
  fi

  # Check if registers are here, or create them
  [[ ! -d "${SCD}/registers" ]] && mkdir "${SCD}/registers"
  [[ ! -f "${SCD}/registers/" ]] && touch "${SCD}/registers/tests.yaml"

  key=$(date "+%s")
  value="$(pwd)/tests"
  file="${SCD}/registers/tests.yaml"

  # Save a log into the tests registers
  # in ${SCD}/registers/tests.yaml
  # 2025-jan-21: /path/to/tests/dir
  add_yaml_item "$key" "$value" "$file"

  bashunit tests
fi # End test
