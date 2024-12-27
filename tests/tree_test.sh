#!/bin/bash

# Run the tests with: ./lib/bashunit from the Root
# https://bashunit.typeddevs.com/quickstart

root="~/.bashrc"

# Chech if the pieces are in place

function test_bin_dir_exists() {
    local bin="~/.sherpa/bin"
    assert_is_directory "bin"
}

function test_lib_dir_exists() {
    local lib="~/.sherpa/lib"
    assert_is_directory "lib"
}

function test_tests_dir_exists() {
    local tests="~/.sherpa/tests"
    assert_is_directory "tests"
}

# Checking for required files

function test_basecamp_file_exists() {
  local file_path="$HOME/.sherpa/basecamp.sh"
  assert_is_file $file_path
}

function test_basecamp_is_bash_script() {
  local file="$HOME/.sherpa/basecamp.sh"
  assert_file_contains "$file" "#!/usr/bin/env bash"
}
