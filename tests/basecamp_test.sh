#!/bin/bash

# Run the tests with: sherpa test OR sherpa t
# from the SherpaDotDir
# https://bashunit.typeddevs.com/quickstart

source ~/.sherpa/basecamp.sh
source ~/.sherpa/lib/std/fmt.sh

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

function test_use_fn() {

  # Setup
  file="$SDD/lib/std/test.sh"
  [[ ! -f "$file" ]] && touch "$file"
  echo "color=\"Green\"" >"$file"

  # Test
  use "std/test"
  # Assert
  assert_same "$color" "Green"

  # Cleanup
  rm "$file"

}

function test_import_url_fn() {

  # Test
  import -u "https://codeberg.org/AndiKod/testo/raw/branch/master/greet.sh"
  # Assert
  assert_same "$(hey)" "Hello!"

}

function test_import_github_fn() {

  # Test
  import -r "AndiKod/testo" -f "greet.sh"
  # Assert
  assert_same "$(hey)" "Hello!"

}

function test_confirm() {

  # Test
  echo "y" | confirm "Really ready to go"
  sky="limit"

  # Assert
  assert_same "$sky" "limit"

}

function test_yaml_crud_operations() {

  # Setup
  dir="${SDD}/data"
  file="${dir}/data.yaml"
  [[ ! -d "$dir" ]] && mkdir "${SDD}/data"
  [[ ! -f "$file" ]] && touch "$file"

  # Test addParent, addIem, getItem
  add_yaml_parent "hiker" "$file"
  add_yaml_item "hiker.name" "Joe" "$file"
  add_yaml_item "hiker.age" "42" "$file"
  name="$(get_yaml_item "hiker.name" "$file")"
  age="$(get_yaml_item "hiker.age" "$file")"
  # Assert
  assert_same "$name" "Joe"
  assert_same "$age" "42"

  # Test updateItem
  update_yaml_item "hiker.name" "Bob" "$file"
  remove_yaml_item "hiker.age" "$file"
  newName="$(get_yaml_item "hiker.name" "$file")"
  newAge="$(get_yaml_item "hiker.age" "$file")"

  # Assert
  assert_same "$newName" "Bob"
  assert_same "$newAge" "null"

  # Cleanup
  [[ -d "$dir" ]] && rm -rf "$dir"

}
