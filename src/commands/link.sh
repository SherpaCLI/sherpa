# @file Link
# @brief Was used to generate a symlink
# @description
#
#    Expected to become Obsolete, as the links are
#    generate on creation via `sherpa new myscript`.
#
#    The `make` command is used to "put together" the
#    script _partials.sh files into an optimized output.
#

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
      p "Link ${3} is removed."
      exit 0
    else
      p "Can't find the link ${3}."
      exit 1
    fi

    # Remove the link
    # Press y to confirm
    symlink_remove "${target_dir}/$link_name"
  fi

fi # End link
