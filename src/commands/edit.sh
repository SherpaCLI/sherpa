# --------------------------- #
#  Open main.sh in the Editor #
# --------------------------- #

# @file Edit
# @brief Open main files with the default Editor (conf in basecamp.sh).
# @description
#
#    To be used from the root of a Sherpa project,
#    created with "sherpa new myProject".
#
#    It will:
#      * Use the program set in basecamp.sh, default to Vim
#      * Open some pre-defined key files for quick editions
#
#    Routes:
#      * bin: src/bin.sh - Main entry to the script content
#      * opt: src/_options.sh - Flags and options via Getopt
#      * basecamp: ~/.sherpa/basecamp.sh - Globals & Conf
#      * yaml: Sherpa.yaml - Configuration variables
#
#    Arg $1 string The command, itself: e OR edit
#    Arg $2 string The file code name: bin, opt, basecamp...
#
#  Usage: sherpa e bin
#

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
  elif [[ "$fileToEdit" == "yaml" ]]; then
    if [[ -f "Sherpa.yaml" ]]; then
      ${EDITOR} "Sherpa.yaml"
    else
      br
      p "Oops. Can't find the Sherpa.yaml file."
      em "Make sure you are in a project root"
      br
    fi

  fi # end Options
fi   # end Edit
