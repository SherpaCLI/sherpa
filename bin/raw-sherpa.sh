#!/usr/bin/env bash
. ~/.sherpa/basecamp.sh

# Sourcing libs from ~/.sherpa/lib
use "std/fmt"
use "tent/symlink"

# Project directory path, when in the root
readonly PKG_DIR=$(
  cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P
)

# TODO: Potentially to be removed
# Theme
# ...looks like a old line
primaryColor=Green
defRoot="$HOME/.sherpa"

# ------------------------- #

# If the script is called with no arguments
if [[ "$#" == 0 ]]; then # Home Route

  h1 " Welcome to 👋 Sh:erpa"
  hr "= + =" "-" # -----------= + =-----------
  text-center "$(date +%T)"
  br
  h2 "Things to visit today"
  p "Minimal things to bring back:"
  br
  p "* List scripts"
  p "* Add script"
  p "* Rename script"
  p "* Remove script"
  br
  h3 "Things to add later"
  p "* Time module :to print clocks"
  p "* Date module :to print dates"
  br
  p "${strong}TODO:${x}"
  br

fi # End Home Route

# --------------------- #
#  Help & Options Menu  #
# --------------------- #

# Initialize variables
show_help=0
show_version=0

# Function to display help
_print_help() {
  br
  h1 "Sh:erpa Help"
  hr "=+=" "-"
  p "Usage: sherpa [options] <main_argument>"
  br
  em "..or alias [sherpa] to something like [sh]."
  br
  p "${txtGreen}Options:${x}"
  p "  ${strong}-h${x}, help     :Show this help message"
  p "  ${strong}-v${x}, version  :Show version information"
  br
  h2 "Available commands:"
  p " ${em}:noArgs:${x}                   :A generic Dashboard"
  p " ${strong}new${x}${em}myProject${x}  :Run the tests in /tests"
  br
}

# Parse options using getopts
while getopts ":hvVq-:" opt; do
  case "$opt" in
  h)
    show_help=1
    ;;
  v)
    verbose=1
    ;;
  V)
    show_version=1
    ;;
  q)
    quiet=1
    ;;
  -)
    case "${OPTARG}" in
    help)
      show_help=1
      ;;
    version)
      show_version=1
      ;;
    *)
      echo "Invalid option: --$OPTARG"
      ;;
    esac
    ;;
  \?)
    echo "Use short version instead of: -$OPTARG" >&2
    _print_help
    exit 1
    ;;
  esac
done

# Shift processed options away from positional parameters
shift $((OPTIND - 1))

# Display help if requested
if [ $show_help -eq 1 ]; then
  _print_help
  exit 0
fi

# Display version if requested (you can customize the version string)
if [ $show_version -eq 1 ]; then
  br
  p "${strong}${txtGreen}Sh:erpa${x} ${em}Version 0.2.0${x}"
  p "More on ${link}https://github.com/AndiKod/sherpa${x}"
  br
  exit 0
fi

# Define verbose helper
log_verbose() {
  [[ "$verbose" == 1 ]] && printf "\n${txtGreen}[verbose] ${x} %s" "$1"
}

# --------------------- #
#  New project command  #
# --------------------- #

if [[ "$1" == "new" ]]; then # Start Route

  # A second argument is needed
  # ...the project's name/folder.
  if [[ -z $2 ]]; then
    br
    p "${bgYellow}${txtBlack} Oops! ${x} Second argument needed."
    p "Usage: ${em}sherpa new foobar${x}"
    br
    p "It will be the directory's name, so no wild things."

    exit 1
  fi

  # The second argument is here
  # let's do something with it.
  if [[ -n $2 ]]; then # Creation

    project=$2
    project_dir="$(pwd)/$project"
    template="bin_starter"
    custom_template="${SCD}/templates/${template}"
    default_template="${SDD}/templates/${template}"

    if [[ -d ${custom_template} ]]; then
      template_files="${custom_template}"
    else
      template_files="${default_template}"
    fi

    # Create the project's root folder
    # and move inside for the follow-up
    mkdir $project && cd $project

    h1 " Welcome to the basecamp 👋 intrepid voyager."
    hr "= + =" "-"
    br
    p "Unloading template's files from the truck..."
    # Copy template's files
    cp -r ~/.sherpa/templates/bin_starter/* .
    # Initialize an empty Git repo
    git init
    br
    p "${btnSuccess} Done! ${x} Time to start climbing."
    p "ProjectDir is $project_dir"
    br
    p "You can follow the trail with: ${em}cd ${project}${x}"
    p "Then one of those signs:"
    p "* sherpa run         # Build and Run your project"
    p "* sherpa e bin       # Edit the main script content"
    p "* sherpa e opt       # Edit the Flags & Options"
    p "* sherpa e conf      # Edit the src/_config.sh file"
    p "* sherpa e basecamp  # Edit global data"
    br
    p "...more on ${link}https://github.com/AndiKod/sherpa${x}"
    br

    echo "readonly ROOT=\"$project_dir\"" >>"${project_dir}/src/_globals.sh"

    # TODO:: Replace update_config by update_yaml_item

    # Update the Sherpa.yaml file
    #+in the project root folder.
    update_config "package.name" "$project"
    update_yaml_item "package.executable" "$project" "${project_dir}/Sherpa.yaml"

    # --- Barbarisme à changer
    key="readonly PKG_NAME"
    new_value="${project}"
    filename="./src/_globals.sh"

    # Use sed to find the key and modify its value
    sed -i -E "s/^(${key}\s*=\s*)\"([^\"]*)\"/\1\"${new_value}\"/" "$filename"

    # --- fin barbarisme

  fi #End Creation
fi   # End Route

# ----------------------- #
#  Build Command          #
# ----------------------- #

# The name of the project/package
#+as mentioned in the Sherpa.yaml file
readonly PKG_NAME=$(get_yaml_item "package.name" Sherpa.yaml)
readonly SCRIPT="target/debug/${PKG_NAME}.sh"

if [[ "$1" == "build" ]]; then # Build

  scr_header="${SDD}/templates/components/scr_header.sh"
  scr_options="src/_options.sh"
  scr_body="src/bin.sh"
  built_script="target/debug/${PKG_NAME}.sh"

  # Chech directories and create if needed
  [[ ! -d target ]] && mkdir target
  [[ ! -d target/debug ]] && mkdir target/debug
  # Check if the script file exists
  [[ ! -f ${built_script} ]] && touch ${built_script}
  # Put the pieces together
  cat ${scr_header} ${scr_options} ${scr_body} >${built_script}
  # Make it executable.
  [[ ! -x ${SCRIPT} ]] && chmod +x ${SCRIPT}

  # Building Docs
  [[ ! -d target/debug/docs ]] && mkdir target/debug/docs
  shdoc <${SCRIPT} >target/debug/docs/${PKG_NAME}.md

  p "${btnSuccess}Done!${x} You can Run it."
  br
  p "Command: ${em}sherpa run${x}"
  em "run it fromt the root folder of the project"
  br

fi # End Build

# ----------------------- #
#  Run main.sh from Root  #
# ----------------------- #

# usage: sherpa run
# Works when called from a project root
#+so ti could resolve to project/target/debug/project.sh

if [[ "$1" == "run" ]]; then # Run

  # Somehow testing that we are inside a root project
  # If so, a src forler and Sherpa.yaml file should
  #+be found in the actual working directory.
  if [[ ! -d "./src" && ! -f Sherpa.yaml ]]; then

    p "Oops!"
    p "You are probably not in project root/"

    exit 1

  fi

  # Single file script parts to be assambled
  scr_header="${SDD}/templates/components/scr_header.sh"
  scr_opt="./src/_options.sh"
  scr_conf="./src/_config.sh"
  scr_body="./src/bin.sh"

  # TODO:: Replace get_config by get_yaml_item

  # pkgName=$(grep -E "^readonly PKG_NAME=" "$scr_conf" | cut -d'=' -f2 | tr -d '"')
  pkgName=$(get_config "package.name")

  built_script="target/debug/${pkgName}.sh"

  # TODO: At this point, build the src/_config.sh file
  # foreach ".package.key & value" add "readonly KEY="value"

  # Chech directories and create if needed
  [[ ! -d target ]] && mkdir target
  [[ ! -d target/debug ]] && mkdir target/debug
  # Check if the script file exists
  [[ ! -f ${built_script} ]] && touch ${built_script}

  # Put the pieces together
  cat ${scr_header} \
    ${scr_conf} \
    ${scr_opt} \
    ${scr_body} \
    >${built_script}

  # Make it executable.
  [[ ! -x ${built_script} ]] && chmod +x ${built_script}

  # Building Docs
  [[ ! -d docs ]] && mkdir docs
  shdoc <${built_script} >docs/${pkgName}.md

  # --- End of the Building logic --- #

  if [[ -f "$built_script" ]]; then
    ./${built_script}
  else
    br
    p "${bgYellow}${txtBlack} Oops! ${x} I can't load the script."
    em "Check the value of the name field in Sherpa.yaml"
    br
  fi

fi # End Run

# --------------------------- #
#  Open main.sh in the Editor #
# --------------------------- #

if [[ $1 == "edit" || $1 == "e" ]]; then # Edit

  fileToEdit=$2

  # Edit the src/bin.sh file
  if [[ "$fileToEdit" == "bin" ]]; then # Options
    if [[ -f "src/bin.sh" ]]; then
      ${EDITOR} src/bin.sh
    else
      br
      p "Oops. No src/bin.sh file from here."
      em "Make sure you are in a project root"
      br
    fi

  # Edit the src/_options.sh file
  elif [[ "$fileToEdit" == "opt" ]]; then
    if [[ -f "src/_options.sh" ]]; then
      ${EDITOR} src/_options.sh
    else
      br
      p "Oops. No src/_options.sh file from here."
      em "Make sure you are in a project root"
      br
    fi

  # Edit the src/_options.sh file
  elif [[ "$fileToEdit" == "basecamp" ]]; then
    if [[ -f "${SDD}/basecamp.sh" ]]; then
      ${EDITOR} "${SDD}/basecamp.sh"
    else
      br
      p "Oops. Can't reach the basecamp."
      em "Make sure Sherpa is corectly installed"
      br
    fi

  # Edit the Sherpa.yaml file
  elif [[ "$fileToEdit" == "conf" ]]; then
    if [[ -f "src/_config.sh" ]]; then
      ${EDITOR} "src/_config.sh"
    else
      br
      p "Oops. Can't find the src/_config.sh file."
      em "Make sure you are in a project root"
      br
    fi

  fi # end Options
fi   # end Edit

# ----------------------- #
#  BashUnit Tests Command #
# ----------------------- #

if [[ "$1" == "tests" ]]; then

  if [[ ! -f Sherpa.yaml ]]; then
    p "Ooops. You are probably not in a Sherpa project root."
    exit 1
  fi

  bashunit tests
fi

#
# @description Generate Docs with shDoc
#
# From a bin directory having .sh files,
# it takes the name of the script without extention
# and generate the .md file with the same name.
#
# @arg $1 string: shdocs
# @arg $2 string: script
#
# @see validate()
# @see [shdoc](https://github.com/reconquest/shdoc).
#
if [[ "$1" == "shdoc" ]]; then # Shdoc

  if [[ ! -f Sherpa.yaml ]]; then
    p "Opps. Probably not in a project root."
    exit 1
  fi

  # Define directories
  SRC_DIR="src"
  DOCS_DIR="docs"

  # Create docs directory if it doesn't exist
  [[ ! -d "$DOCS_DIR" ]] && mkdir -p "$DOCS_DIR"

  # Loop over all .sh files in the src directory
  for script in "$SRC_DIR"/*.sh; do
    # Check if there are any .sh files
    if [[ -f "$script" ]]; then
      # Extract the base name (filename without path)
      base_name=$(basename "$script" .sh)
      # Generate the markdown documentation using shdoc
      shdoc <"$script" >"$DOCS_DIR/$base_name.md"
    fi
  done

fi # End Shdoc

if [[ "$1" == "bashdoc" ]]; then # Bashdoc

  if [[ ! -f Sherpa.yaml ]]; then
    p "Opps. Probably not in a project root."
    exit 1
  fi

  # Define directories
  SRC_DIR="src"
  DOCS_DIR="docs"
  HBS="${SDD}/templates/bashdoc.hbs"

  # Create docs directory if it doesn't exist
  [[ ! -d "$DOCS_DIR" ]] && mkdir -p "$DOCS_DIR"

  # Loop over all .sh files in the src directory
  for script in "$SRC_DIR"/*.sh; do
    # Check if there are any .sh files
    if [[ -f "$script" ]]; then
      # Extract the base name (filename without path)
      base_name=$(basename "$script" .sh)
      # Generate the markdown documentation using shdoc
      # shdoc < "$script" > "$DOCS_DIR/$base_name.md"
      bashdoc -c -j -l "${DOCS_DIR}" -t "${HBS}" $script
    fi
  done

fi # End Bashdoc

# ------------------------ #
#  Symlink to .sherpa/bin  #
# ------------------------ #

# TODO: Chech stuff: files, paths, chmod

if [[ "$1" == "link" ]]; then # Link

  file_path="$(pwd)/target/debug/${PKG_NAME}.sh"
  target_dir="${SDD}/bin"
  link_name="${PKG_NAME}"
  link=${target_dir}/${link_name}

  if [[ $# == 1 ]]; then
    hello_link
    symlink_add "$file_path" "$target_dir" "$link_name"
  fi

  if [[ "$2" == "rm" ]]; then

    if [[ -n "$3" && -L "${target_dir}/$3" ]]; then
      symlink_remove "${target_dir}/$3"
      # TODO: Baybe check the status of the lest command
      # to ensure that the link is really gone, or [[-L]]
      p "Link ${em}${3}${x} is removed."
      exit 0
    else
      p "Can't find the link ${em}${3}${x}."
      exit 1
    fi

    # Remove the link
    # Press y to confirm
    symlink_remove "${target_dir}/$link_name"
  fi

fi # End link

# Display available symlinks
#+in ~/.sherpa/bin
if [[ "$1" == "links" ]]; then
  br
  p "Symlinks:"
  # Display avaible links in ~/.sherpa/bin
  symlinks_list
  br
fi

#
#
# ------- Tentative de Make --------
#
#
if [[ "$1" == "make" ]]; then
  sheebang="src/_header.sh"
  # sourceOrder="src/SourceOrder.txt"
  sourceOrder="src/__paths.txt"
  combinedScript="scriptAlmost.sh"
  finalScript="$(get_yaml_item "package.executable" "Sherpa.yaml")"

  [[ ! -d target/local ]] && mkdir target/local

  p "Generating partials files paths..."
  br
  # Call use2path script from .sherpa/bin
  use2path

  br
  echo "Combining files listed in ${sourceOrder}..."

  cat $(<"$sourceOrder") >"$combinedScript"
  if [[ -f "$combinedScript" ]]; then
    echo
    echo "Done. Combined into ${combinedScript}!"
    echo

    echo "Generating documentation from that file"
    [[ ! -d docs ]] && mkdir docs
    shdoc <"$combinedScript" >"docs/${finalScript}.md"
    if [[ -f "docs/${finalScript}.md" ]]; then
      p "Check docs/${finalScript}.md"
      br
    fi

    echo "- Removing comments and empty lines..."
    sed -i '/^\s*#/d; /^\s*$/d' "$combinedScript"

    echo "- Removing trailing spaces..."
    sed -i 's/[[:space:]]*$//' "$combinedScript"

    echo "- Removing the leading spaces..."
    sed -i 's/^[[:space:]]*//' "$combinedScript"

    echo "- Adding the /usr/bin/env bash Shebang..."
    # [[ $# != 2 ]] && echo "Usage: sherpa Make scriptName"
    cat "$sheebang" "$combinedScript" >"target/local/$finalScript"
    rm "$combinedScript"

    # echo "Check with GREP if # lines exist"
    echo "- Making it executable..."
    chmod +x "target/local/$finalScript"
    echo
    p "${btnSuccess} Done! ${x} Execute it with just ${txtGreen}${em}${finalScript}${x}"
    br

    #
    # --- Symlink ---
    #
    # The eventualy existing symlink
    executable=$(get_yaml_item "package.executable" "Sherpa.yaml")
    symlink="${SDD}/bin/${executable}"

    # Get the target of the symlink
    target=$(readlink -f "$symlink")

    br
    p "Looking to create or update ${symlink}"
    br

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

      echo "Symlink updated successfully."
    else
      echo "local/${executable} still Symlinked to ${SDD}/bin"
    fi

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
