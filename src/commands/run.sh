# @file Run
# @brief Basically will build the project and run in with no args
# @description
#
#    To be used from the root of a Sherpa project,
#    created with "sherpa new myProject".
#
#    It will:
#      * Build the script with Make
#      * Execute the maing thing, no args
#      * Have a beer
#
#  Usage: sherpa [r]un
#

if [[ "$1" == "run" || "$1" == "r" ]]; then

  shebang="src/_header.sh"
  sourceOrder="src/__paths.txt"
  combinedScript="scriptAlmost.sh"
  # TODO: safe checks and default value "just in case"
  finalScript="$(get_yaml_item "package.executable" "Sherpa.yaml")"

  # Creating directories if necessary
  [[ ! -d target ]] && mkdir target
  [[ ! -d target/local ]] && mkdir target/local

  # Generating partials files paths...
  # Call use2path script from .sherpa/bin
  use2path

  # Combining files listed in ${sourceOrder}...
  # Read the file paths into an array
  mapfile -t files <"$sourceOrder"

  # Concatenate the contents of each file into combinedScript
  cat "${files[@]}" >"$combinedScript"

  if [[ -f "$combinedScript" ]]; then

    # Done run. Combined into ${combinedScript}!
    # Generating documentation from that file
    [[ ! -d docs ]] && mkdir docs

    # Using shdoc for the File and global docs
    shdoc <"$combinedScript" >"docs/${finalScript}.md"
    echo -e "--- Commands/Routes & nonFunctions ---\n" >>"docs/${finalScript}.md"
    # Additional parsing with bashdoc
    bashdoc "$combinedScript" >>"docs/${finalScript}.md"

    # - Removing comments and empty lines...
    sed -i '/^\s*#/d; /^\s*$/d' "$combinedScript"

    # - Removing trailing spaces...
    sed -i 's/[[:space:]]*$//' "$combinedScript"

    # - Removing the leading spaces...
    sed -i 's/^[[:space:]]*//' "$combinedScript"

    # - Adding the /usr/bin/env bash Shebang...
    cat "$shebang" "$combinedScript" >"target/local/$finalScript"
    rm "$combinedScript"

    # - Making it executable...
    chmod +x "target/local/$finalScript"

    #
    # --- Symlink ---
    #
    # The eventualy existing symlink
    executable=$(get_yaml_item "package.executable" "Sherpa.yaml")
    symlink="${SDD}/bin/${executable}"

    # Get the target of the symlink
    target=$(readlink -f "$symlink")

    if [[ ! -L "$symlink" ]]; then
      # Create a new symlink
      ln -s "$(pwd)/target/local/${executable}" "${SDD}/bin/${executable}"
    fi

    # Check if the target doesn't contain "target/bin"
    if [[ "$target" != *"target/local"* ]]; then
      # Remove the existing symlink
      rm "$symlink"

      # Create a new symlink
      ln -s "$(pwd)/target/local/${executable}" "${SDD}/bin/${executable}"

      # Finally ...run the Script :)
      "$executable"

    else

      # echo "local/${executable} still Symlinked to ${SDD}/bin"
      "$executable"

    fi

  else
    echo "Quelque chose à merdé!"
    exit 1
  fi
fi
