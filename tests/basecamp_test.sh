#!/bin/bash

# Run the tests with: sherpa test OR sherpa t
# from the SherpaDotDir
# https://bashunit.typeddevs.com/quickstart

source ~/.sherpa/basecamp.sh

function test_SDD_is_a_Directory() {
  # Check if the SherpaCustomDir
  # is actually pointing to a dir.
  assert_is_directory "$SDD"
}

function test_SCD_is_a_Directory() {
  # Check if the SherpaCustomDir
  # is actually pointing to a dir.
  assert_is_directory "$SCD"
}

function test_EDITOR_is_in_EditorsArray() {

  # Check if a real edditor is specified
  # Let us know in Discord about yours
  assert_matches "^(vim|nvim|code)$" "$EDITOR"

}
