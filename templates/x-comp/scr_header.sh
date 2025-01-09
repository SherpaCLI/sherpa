#!/usr/bin/env bash

# Just for local dev when .sherpa is installed
. ~/.sherpa/basecamp.sh
# ...otherwise we need to include in the script.

# Dynamic reference to the script root
readonly SCRIPT_DIR=$(
  cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P
)


