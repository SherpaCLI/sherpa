# --------------------- #
#  New project command  #
# --------------------- #

# @file New
# @brief Creates a new project folder, inspired by Rust's Cargo
# @description
#
#    To be used from anywhere you would palce a coding project.
#
#    It will:
#      * Complain if you don't supply a name for the project
#      * Create a new folder, duplicating ~/.sherpa/templates/bin_starter
#      * Initiate a Git repository in the folder
#      * Update the project and executable name in project/Sherpa.yaml
#      * Prints a Welcome screen with useful commands
#
#  Usage: sherpa new myproject
#

# For Variables declared in sourced files
# shellcheck disable=SC2154

if [[ "$1" == "new" ]]; then # Start Route

  # A second argument is needed
  # ...the project's name/folder.
  if [[ -z $2 ]]; then
    br
    p "${btnDanger} Oops! ${x} Second argument needed."
    p "Usage: ${em}sherpa new [-t] <packageName>${x}"
    br
    p "It will be the directory's name, so no wild things."

    exit 1
  fi

  # # Shift the first argument so we can process flags
  # shift

  # # The default template
  # template="binStarter"

  # while getopts "t:" opt; do
  #   case $opt in
  #   t) template=${OPTARG} ;;
  #   *) echo "Invalid flag" ;;
  #   esac
  # done

  # The second argument is here
  # let's do something with it.
  if [[ -n $1 ]]; then # Creation

    # TODO: Should be called package
    project=$2

    # If necessary, create the localBoxex.yaml resister
    regDir="${SCD}/registers"
    localBoxes="${regDir}/localBoxes.yaml"
    [[ ! -d "$regDir" ]] && mkdir "$regDir"
    [[ ! -f "$localBoxes" ]] && touch "$localBoxes"

    # # Check if a local BashBox named $project is already here
    # testRoot="$(get_yaml_item "${project}.root" "$localBoxes")"
    # if [[ $testRoot != null ]]; then
    #   br
    #   p "${btnWarning} Ooops! ${x} A ${txtGreen}${project}${x} BashBox already exists."
    #   br
    #   p "It's root: ${em}${testRoot}${x}"
    #   br

    #   exit 1
    # fi

    project_dir="${SCD}/boxes/$project"
    template="binStarter"

    custom_template="${SCD}/templates/${template}"
    default_template="${SDD}/templates/${template}"

    if [[ -d ${custom_template} ]]; then
      template_files="${custom_template}"
    else
      template_files="${default_template}"
    fi

    # --- We checked upon the localBoxes registrer
    # # Exit if an omonyme directory exists
    # if [[ -d "$project" ]]; then
    #   br
    #   p "${btnWarning} Oops! ${x} There is already a ${project} directory here."
    #   br
    #   em "Pick a new name, for the new project ;)"
    #   br

    #   exit 1
    # fi

    # Create the project's root folder
    # and move inside for the follow-up
    cd "${SCD}/boxes" || return
    mkdir "$project"

    # If the mkdir is a success, go inside
    if [[ ! -d "$project" ]]; then
      p "Couldn't create the ${project} directory"
      exit 1
    else
      # The || return is to please ShellCheck
      # "in case the cd fails"
      cd "$project" || return
    fi

    h1 " Welcome to the basecamp 👋 intrepid voyager."
    hr "= + =" "-"
    br
    p "Unloading template's files from the truck..."

    # Copy template's files
    cp -r ~/.sherpa/templates/${template}/* .

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
    p "* sherpa e yaml      # Edit the Sherpa.yaml file"
    p "* sherpa e basecamp  # Edit global data"
    br
    p "...more on ${link}https://github.com/AndiKod/sherpa${x}"
    br

    # TODO: This might become obsolete
    echo "readonly ROOT=\"$project_dir\"" >>"${project_dir}/src/_globals.sh"
    # replaced by this:
    # Adding the root dir at the BashBox yaml
    add_yaml_item "package.root" "$project_dir" "${project_dir}/Sherpa.yaml"
    add_yaml_item "package.type" "localBin" "${project_dir}/Sherpa.yaml"

    # Update the Sherpa.yaml file
    #+in the project root folder.
    update_yaml_item "package.name" "$project" "${project_dir}/Sherpa.yaml"
    update_yaml_item "package.executable" "$project" "${project_dir}/Sherpa.yaml"

    # Add the BashBox to the localBoxes register
    add_yaml_parent "$project" "$localBoxes"
    add_yaml_item "${project}.root" "$project_dir" "$localBoxes"

    # # No more used
    # # To be removed
    # key="readonly PKG_NAME"
    # new_value="${project}"
    # filename="./src/_globals.sh"

    # # Use sed to find the key and modify its value
    # sed -i -E "s/^(${key}\s*=\s*)\"([^\"]*)\"/\1\"${new_value}\"/" "$filename"

    # --- fin barbarisme

  fi #End Creation
fi   # End Route
