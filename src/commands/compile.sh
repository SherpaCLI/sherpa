# @file Compile
# @brief Compiles the script to a binary, using SHC.
# @description
#
#    To be used from the root of a Sherpa project,
#    created with "sherpa new myProject".
#
#    It will:
#      * Complain if you didn't first run: sherpa make
#      * Create if needed the target/bin folder
#      * Replace the shebang by "#!/bin/bash" (env not supported)
#      * Compile the script using generated C code
#      * Use the name from Sherpa.yaml -> .package.executable field
#      * Save the binary in target/bin
#      * Refresh or Update the symlink to .sherpa/bin
#
#  Usage: sherpa compile
#

#                     #
#   --- Compile ---   #
#                     #

if [[ "$1" == "compile" ]]; then # Compile

  executable="$(get_yaml_item "package.executable" Sherpa.yaml)"
  # TODO: Do something if executable is empty
  script="target/local/${executable}"
  scriptCopy="/tmp/${executable}-copy"

  # Chack if the built script is here in target/local
  if [[ ! -f "target/local/${executable}" ]]; then # IsFile
    p "${btnWarning} Oops! ${x} Run first: ${em}sherpa build${x}"
    exit 1
  else

    # Create the directory if necessary
    [[ ! -d "target/bin" ]] && mkdir target/bin

    # Replace SheBang, as SHC does not support /usr/bin/env
    # will look for other solution later, eventually...
    cp "$script" "$scriptCopy"
    sed -i 's|#!/usr/bin/env bash|#!/bin/bash|g' "$scriptCopy"

    p "Compiling to Binary via SHC..."
    export CC=gcc
    shc -vrf "$scriptCopy" -o "target/bin/${executable}"

    # Check the success of the execution
    if [[ "$?" == 0 ]]; then
      br
      p "${btnSuccess} Done! ${x} The binary is stored in target/bin"
      # Remove the temporary file
      rm ${scriptCopy}
      br

      # The eventualy existing symlink
      symlink="${SDD}/bin/${executable}"

      # Get the target of the symlink
      target=$(readlink -f "$symlink")

      # Check if the target doesn't contain "target/bin"
      if [[ "$target" != *"target/bin"* ]]; then
        # Remove the existing symlink
        rm "$symlink"

        # Create a new symlink
        ln -s "$(pwd)/target/bin/${executable}" "${SDD}/bin/${executable}"

        echo "Symlink updated successfully."
      else
        echo "bin/${executable} still Symlinked to ${SDD}/bin"
      fi

    else
      br
      p "Ooops! Command failed, with the ${?} exit code."
      br
    fi

  fi # End IsFile
fi   # End Compile
