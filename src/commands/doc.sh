# @file Doc
# @brief Generating documentation with shdoc & bashdoc.
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
#  Usage: sherpa d, doc
#
# @see [shdoc](https://github.com/reconquest/shdoc).

#;
# Doc
# Generates .md docs with both Shdoc & Bashdoc
#"
if [[ "$1" == "doc" || "$1" == "d" ]]; then # Shdoc

  # A Sherpa.yaml file bust be present in the directory
  # otherwise it's brobably not a BashBox directory
  if [[ ! -f Sherpa.yaml ]]; then
    br
    p "${btnWarning} Opps! ${x} Probably not in a project root."
    br
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

      echo -e "--- Some more, via BashDoc ---\n" >>"$DOCS_DIR/$base_name.md"

      # Additional parsing with bashdoc
      bashdoc "$script" >>"$DOCS_DIR/$base_name.md"

      # Log messages according to the command issue
      if [[ -f "$DOCS_DIR/$base_name.md" ]]; then
        br
        p "${btnSuccess} Done! ${x} ... ${DOCS_DIR}/$base_name.md"
        br
      else
        p "Can't generate Doc."
        exit 1
      fi

    fi
  done

fi # End Doc
