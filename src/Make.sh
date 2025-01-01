#!/usr/bin/env bash
. ~/.sherpa/basecamp.sh

# Sourcing libs from ~/.sherpa/lib
use "std/fmt"

#
# ------- Build the Script --------
#

if [[ "$#" == 0 ]]; then

  shebang="shebang.sh"
  # sourceOrder="src/SourceOrder.txt"
  sourceOrder="__paths.txt"
  combinedScript="scriptAlmost.sh"
  finalScript="sherpa"

  p "Generating partials files paths..."
  br

  # --- End Local use2paths ---------------------------------- #

  # Initialise variables from arguments
  #input_file="bin.sh"       # src/bin.sh
  output_file="__paths.txt" # src/__paths.txt

  # Main files paths
  #globals="${SDD}/src/_globals.sh"
  basecamp="${SDD}/basecamp.sh"
  options="${SDD}/src/help/options.sh"
  fmt="${SDD}/lib/std/fmt.sh"
  symlink="${SDD}/lib/tent/symlink.sh"
  # Commands
  build="${SDD}/src/commands/build.sh"
  home="${SDD}/src/commands/home.sh"
  bashdoc="${SDD}/src/commands/bashdoc.sh"
  compile="${SDD}/src/commands/compile.sh"
  edit="${SDD}/src/commands/edit.sh"
  link="${SDD}/src/commands/link.sh"
  links="${SDD}/src/commands/links.sh"
  new="${SDD}/src/commands/new.sh"
  init="${SDD}/src/commands/init.sh"
  run="${SDD}/src/commands/run.sh"
  doc="${SDD}/src/commands/doc.sh"
  test="${SDD}/src/commands/test.sh"
  install="${SDD}/src/commands/install.sh"

  # Empty the file, prior to re-fill it
  : >$output_file

  # Add the top standard paths
  #echo "$globals" >>$output_file
  #p "Added ${globals}"

  echo "$basecamp" >>$output_file
  p "Added ${basecamp}"

  echo "$fmt" >>$output_file
  p "Added ${fmt}"

  echo "$symlink" >>$output_file
  p "Added ${symlink}"

  # Add the bottom standard paths
  echo "$options" >>$output_file
  p "Added ${options}"

  # --- Commands:

  echo "$home" >>$output_file
  p "Added ${home}"

  echo "$bashdoc" >>$output_file
  p "Added ${bashdoc}"

  echo "$compile" >>$output_file
  p "Added ${compile}"

  echo "$edit" >>$output_file
  p "Added ${edit}"

  echo "$link" >>$output_file
  p "Added ${link}"

  echo "$links" >>$output_file
  p "Added ${links}"

  echo "$build" >>$output_file
  p "Added ${build}"

  echo "$new" >>$output_file
  p "Added ${new}"

  echo "$init" >>$output_file
  p "Added ${init}"

  echo "$run" >>$output_file
  p "Added ${run}"

  echo "$doc" >>$output_file
  p "Added ${doc}"

  echo "$test" >>$output_file
  p "Added ${test}"

  echo "$install" >>$output_file
  p "Added ${install}"

  p "...to ${output_file}"

  # --- End Local use2paths ---------------------------------- #

  #
  #  Generating Commands Docs
  #

  p "Generating docs in ../docs/commands ..."
  for file in ${SDD}/src/commands/*; do
    filename=$(basename "$file")
    shdoc <"$file" >"${SDD}/docs/commands/${filename%.sh}.md"
  done

  br
  echo "Combining files listed in ${sourceOrder}..."

  cat $(<"$sourceOrder") >"$combinedScript"
  if [[ -f "$combinedScript" ]]; then
    echo
    echo "Done. Combined into ${combinedScript}!"
    echo

    # echo "Generating documentation from that file"
    # [[ ! -d docs ]] && mkdir docs
    # shdoc <"$combinedScript" >"../docs/${finalScript}.md"
    # if [[ -f "../docs/${finalScript}.md" ]]; then
    #   p "Check ../docs/${finalScript}.md"
    #   br
    # fi

    echo "- Removing comments and empty lines..."
    sed -i '/^\s*#/d; /^\s*$/d' "$combinedScript"

    echo "- Removing trailing spaces..."
    sed -i 's/[[:space:]]*$//' "$combinedScript"

    echo "- Removing the leading spaces..."
    sed -i 's/^[[:space:]]*//' "$combinedScript"

    echo "- Adding the /usr/bin/env bash Shebang..."
    # [[ $# != 2 ]] && echo "Usage: sherpa Make scriptName"
    cat "$shebang" "$combinedScript" >"../bin/$finalScript"
    rm "$combinedScript"

    # echo "Check with GREP if # lines exist"
    echo "- Making it executable..."
    chmod +x "../bin/$finalScript"
    echo
    p "${btnSuccess} Done! ${x} Execute it with just ${txtGreen}${em}${finalScript}${x}"
    br

    #/bin/${executable}"
    # fi

    # # Check if the target doesn't contain "target/bin"
    # if [[ "$target" != *"target/local"* ]]; then
    #   # Remove the existing symlink
    #   rm "$symlink"

    #   # Create a new symlink
    #   ln -s "$(pwd)/target/local/${executable}" "${SDD}/bin/${executable}"

    #   echo "Symlink updated successfully."
    # else
    #   echo "local/${executable} still Symlinked to ${SDD}/bin"
    # fi

  else
    echo "Quelque chose à merdé!"
    exit 1
  fi
fi

#
# @description Compile Command
#

if [[ "$1" == "compile" ]]; then # Compile

  executable="$(get_yaml_item "package.executable" Sherpa.yaml)"
  # TODO: Do something if executable is empty
  script="target/local/${executable}"
  scriptCopy="/tmp/${executable}-copy"

  # Chack if the built script is here in target/local
  if [[ ! -f "target/local/${executable}" ]]; then # IsFile
    p "Oops! Run first: ${em}sherpa make${x}"
    exit 1
  else
    [[ ! -d "target/bin" ]] && mkdir target/bin

    # Replace SheBang, as SHC does not support /usr/bin/env
    # will look for other solution along the way...
    cp "$script" "$scriptCopy"
    sed -i 's|#!/usr/bin/env bash|#!/bin/bash|g' "$scriptCopy"

    echo "Compiling to Binary via SHC..."
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
