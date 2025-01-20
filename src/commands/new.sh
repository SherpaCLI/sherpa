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
    p "Usage: ${em}sherpa new <packageName> [lib]${x}"
    br
    p "It will be the directory's name, so no wild things."

    exit 1
  fi

  # -------------------------------- #
  #   Create a new Lib in $SCD/lib   #
  # -------------------------------- #

  if [[ "$3" == "lib" ]]; then # Start newLib

    package=$2

    # If necessary, create the localBoxex.yaml resister
    regDir="${SCD}/registers"
    localLibs="${regDir}/localLibs.yaml"
    [[ ! -d "$regDir" ]] && mkdir "$regDir"
    [[ ! -f "$localLibs" ]] && touch "$localLibs"

    package_dir="${SCD}/lib/$package"
    libTemplate="libStarter"

    custom_libTemplate="${SCD}/templates/${libTemplate}"
    default_libTemplate="${SDD}/templates/${libTemplate}"

    if [[ -d ${custom_libTemplate} ]]; then
      template_files="${custom_libTemplate}"
    else
      template_files="${default_libTemplate}"
    fi

    #
    #   Exit if the directory already exists
    #
    if [[ -d "$package_dir" ]]; then
      br
      p "${btnWarning} Oops! ${x} Directory ${txtYellow}lib/${package}${x} already exists."
      br
      p "${em}Pick another name ;)${x}"

      exit 1
    fi

    # Creating the new package
    cd "${SCD}/lib" || return
    mkdir "$package"
    cd "$package" || return

    h1 " Welcome to the basecamp 👋 intrepid voyager."
    hr "= + =" "-"
    br
    p "Unloading template's files from the truck..."

    # Copy template's files
    cp -r "${template_files}"/* .

    # Initialize an empty Git repo
    git init --quiet

    br
    p "${btnSuccess} Done! ${x} Time to start climbing."
    p "ProjectDir is $package_dir"
    br

    # README
    sed -i "s/FooBar/BAZ/g" "${package_dir}/README.md"

    # YAML Fiesta
    add_yaml_item "package.type" "localLib" "${package_dir}/Sherpa.yaml"

    # Update the Sherpa.yaml file
    #+in the project root folder.
    update_yaml_item "package.name" "$package" "${package_dir}/Sherpa.yaml"

    # Add the BashBox to the localBoxes register
    add_yaml_parent "$package" "$localLibs"
    add_yaml_item "$package.name" "$package" "$localLibs"

  fi # End newLib

  # -------------------------------- #
  #   Create a new Box in boxes/     #
  # -------------------------------- #

  if [[ -n $1 && $# == 2 ]]; then # newBox

    # TODO: Should be called package, but it's ok.
    project=$2

    # If necessary, create the localBoxex.yaml resister
    regDir="${SCD}/registers"
    localBoxes="${regDir}/localBoxes.yaml"
    [[ ! -d "$regDir" ]] && mkdir "$regDir"
    [[ ! -f "$localBoxes" ]] && touch "$localBoxes"

    project_dir="${SCD}/boxes/$project"
    template="binStarter"

    custom_template="${SCD}/templates/${template}"
    default_template="${SDD}/templates/${template}"

    if [[ -d ${custom_template} ]]; then
      template_files="${custom_template}"
    else
      template_files="${default_template}"
    fi

    # TODO: Check if boxes/$project already exists !

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
    cp -r "${template_files}"/* .

    # Initialize an empty Git repo
    git init --quiet

    br
    p "${btnSuccess} Done! ${x} Time to start climbing."
    p "ProjectDir is $project_dir"
    br

    # conf="${ROOT}/data/conf.yaml" to point at data files
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

    # Build it, bro!
    sherpa build

  fi #End newBox
fi   # End Route
