#!/bin/bash

# Run the tests with: ./lib/bashunit from the Root
# https://bashunit.typeddevs.com/quickstart

source ~/.sherpa/basecamp.sh

function test_bashunit_is_working() {
  assert_same "bashunit is working" "bashunit is working"
}

function test_default_primaryColor() {
  assert_not_empty "primaryColor_default"
}
