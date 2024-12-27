# @file Links
# @brief Display the symlinks in .sherpa/bin and their target
#
# @description
#    To be used from anywhere.
#
#    It will:
#      * Activate the symlinks_list() function, from lib/tent/symlinks.sh
#      * Display the links as: link -> path/to/file
#
#  Usage: sherpa links
#

#;
# [links:rt] Links
# calls symlinks_list() from tent/symlinks.sh
#"
if [[ "$1" == "links" ]]; then
  br
  p "Symlinks:"
  # Display avaible links in ~/.sherpa/bin
  symlinks_list
  br
fi
