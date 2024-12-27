# @file Shdoc
# @brief Generating documentation with shdoc.
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
#  Usage: sherpa x [d]oc
#
# @see [shdoc](https://github.com/reconquest/shdoc).

#;
# [doc:rt] Doc
# Generates .md docs with both Shdoc & Bashdoc
#"
if [[ "$1" == "doc" || "$1" == "d" ]]; then # Shdoc

  if [[ ! -f Sherpa.yaml ]]; then
    p "Opps. Probably not in a project root."
    exit 1
  fi

  # TODO: Set a yaml field to pick shdoc or bashdoc
  # check on it for the main body
  # or add a flag -[f]ormat shdoc|bashdoc

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

      echo -e "--- Some more, via BashDoc ---\n" >>"$DOCS_DIR/$base_name.md"

      # Additional parsing with bashdoc
      bashdoc "$script" >>"$DOCS_DIR/$base_name.md"

      # Log messages according to the command issue
      if [[ -f "$DOCS_DIR/$base_name.md" ]]; then
        log_normal "Done! $base_name.md"
      else
        p "Can't generate doc."
        exit 1
      fi

    fi
  done

fi # End Shdoc
