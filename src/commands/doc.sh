# @file Doc
# @brief Generating documentation with shdoc
# @description
#
#    To be used from the root of a Sherpa project,
#    created with "sherpa new myProject".
#
#    It will:
#      * Create the docs/ folder if necessary
#      * Loop trough the .sh files in the src/ folder
#      * Generates the files in the docs/ folder
#
#  Usage: sherpa d, doc
#
# @see [](https://sherpa-cli.netlify.app/tools/docs-gen)


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

  # Use find to locate all .sh files in src and its subdirectories
  find "$SRC_DIR" -type f -name "*.sh" | while read -r script; do
    # Extract the relative path from SRC_DIR
    rel_path=${script#"$SRC_DIR/"}
    
    # Create the destination directory structure
    dest_dir="$DOCS_DIR/$(dirname "$rel_path")"
    mkdir -p "$dest_dir"
    
    # Extract the base name (filename without path and extension)
    base_name=$(basename "$script" .sh)
    
    # Generate the markdown documentation using shdoc
    shdoc < "$script" > "$dest_dir/$base_name.md"
  done
  
  br
  p "${btnSuccess} Done! ${x} Check the ${em}docs/${x} folder"
  br
fi # End Doc
