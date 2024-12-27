# --------------------- #
#  New project command  #
# --------------------- #

# @file Init
# @brief Basically the 'sherpa new' command, without 'cd $project'
# @description
#
#    To be used from anywhere you would palce a coding project.
#
#    It will:
#      * duplicating ~/.sherpa/templates/binStarter in the durrent directory
#      * Initiate a Git repository in the folder
#      * Update the project and executable name in project/Sherpa.yaml
#      * Prints a Welcome screen with useful commands
#
#  Usage: sherpa new myproject
#

# For Variables declared in sourced files
# shellcheck disable=SC2154

if [[ "$1" == "init" ]]; then # Start Route

  # The second argument is here
  # let's do something with it.
  if [[ -n "$(ls -A)" ]]; then # Creation

    p "It seems like this directory is not empty."
    p "I hope you know about that."

  else

    project=$(basename "$PWD")
    project_dir="$(pwd)"
    template="binStarter"
    custom_template="${SCD}/templates/${template}"
    default_template="${SDD}/templates/${template}"

    if [[ -d ${custom_template} ]]; then
      template_files="${custom_template}"
    else
      template_files="${default_template}"
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
    p "You can follow the trail with some of those:"
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

    # Update the Sherpa.yaml file
    #+in the project root folder.
    update_yaml_item "package.name" "$project" "${project_dir}/Sherpa.yaml"
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
