# @file Bashdoc
# @brief Generating documentation with bashdoc.
# @description
#
#    To be used from the root of a Sherpa project,
#    created with "sherpa new myProject".
#
#    It will:
#      * Create the docs/ folder if necessary
#      * Use .sherpa/templates/bashdoc.hbs as template
#      * Loop trough the .sh files in the src/ folder
#      * Generates the files in the docs/ folder
#
#  Usage: sherpa bashdoc
#
# @see [shdoc](https://github.com/reconquest/shdoc).

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
