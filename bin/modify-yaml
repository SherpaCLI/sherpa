#!/bin/bash

# Developed by Burak Tungut
# https://buraktungut.com
# This script aims to modify yaml files using the specified yaml path syntax without removing new lines or changing the order of fields, which yq does not support!
# Example: ./modify-yaml.sh "chart/values.yaml" ".image.tag" "my-new-tag-stable" "optional comment"

# 1st parameter : path of yaml file
# 2nd parameter : selector as yaml path syntax
# 3rd parameter : new value
# 4th parameter : (optional) line comment

set -euo pipefail

if [ $# -lt 3 ]
  then
    echo "One or more required arg(s) are empty!"
    exit 1;
fi

[ -f "$1" ] || { echo "$1 does not exist"; exit 1; }

LINE_NO=$(yq "$2 | line" "$1")
FIELD_VAL=$(yq "$2" "$1")

# Get line, remove comment, trim end
LINE_VAL=$(sed "${LINE_NO}q;d" "$1" | sed -e 's/#.*//' | sed 's/ *$//g')

# If value is empty (like; FIELD: "")
PASSED_VAL=$(echo "$3" | sed -e 's@/@\/@')                          # escape forward slash
NEW_LINE_VAL=$(echo "$LINE_VAL" | sed "s@:.*@: $PASSED_VAL@")       # replace value after colon
NEW_LINE_VAL=$(echo "$NEW_LINE_VAL" | sed 's@""@"@g')               # replace double quotes with single quotes

# If line comment is passed
if [ $# -eq 4 ]; then
    NEW_LINE_VAL="${NEW_LINE_VAL} #$4"
fi

# Update the content of related line
sed -i "${LINE_NO}s@.*@${NEW_LINE_VAL}@" "$1"
