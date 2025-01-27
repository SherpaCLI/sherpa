#!/usr/bin/env bash

#
# --- Symlinks ---
#

_is_command() {

  local link_name=$1

  # Check if the name is already a command
  if command -v "$link_name" &>/dev/null; then
    echo "Error: A command with the name '$link_name' already exists."
    exit 1
  fi
}

_sl_exists() {

  local target_dir=$1
  local link_name=$2

  # Check if a symlink already exists
  if [ -L "$target_dir/$link_name" ]; then
    echo "Error: A symlink named '$link_name' already exists in $target_dir."
    exit 1
  fi

}

_sl_create() {

  file_path=$1
  target_dir=$2
  link_name=$3

  # Create the symlink
  ln -s "$file_path" "$target_dir/$link_name"
}

# --- End Symlinks Helpers ------------------

symlink_add() {

  local file_path=$1
  local target_dir=$2
  local link_name=$3
  local link=${target_dir}/${link_name}

  # Check if the name is already a command
  #_is_command "$link_name"

  # Check if a symlink already exists
  _sl_exists "$target_dir" "$link_name"

  # Create the symlink
  _sl_create "$file_path" "$target_dir" "$link_name"

  if [[ $? == 0 ]]; then
    p "Symlink created successfully."
  else
    p "Error creating symlink."
    exit 1
  fi
}

symlink_remove() {

  # TODO: Check if it exists, confirm, etc

  link=$1

  rm -i $link
  [[ ! -L $link ]] && echo "'cause now I'm freeeee"
}

symlinks_list() {
  local dir="${1:-$HOME/.sherpa/bin}"

  while IFS= read -r -d '' file; do
    if [ -L "$file" ]; then
      echo "$(basename "$file") -> $(readlink -f "$file")"
    fi
  done < <(find "$dir" -type l -print0)
}
