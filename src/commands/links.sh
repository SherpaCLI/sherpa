# @file Links
# @brief Display the symlinks in the bin directory and their target
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

cmd_links() {
	br
	h2 "Symlinks"
	# Display available links in the bin directory
	symlinks_list
	br

	return 0
}
