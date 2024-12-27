#!/usr/bin/env bash

# Sourcing the basecamp
. ~/.sherpa/basecamp.sh

# Source the Options definition module
readonly SCRIPT_DIR=$(
    cd "$(dirname "${BASH_SOURCE[0]}")" \
    &>/dev/null && pwd -P
)


