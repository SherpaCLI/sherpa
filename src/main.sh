# @file Main
# @brief The entry point of the assembled CLI
# @description
#
#	Concatenated last, so every cmd_* function and the router are
#	already defined. The global flags have been parsed and shifted
#	away by src/help/options.sh at this point, so $@ holds the
#	command word followed by its own arguments.
#
#	Nothing else belongs in this file.
#
#  Usage: (internal)
#

# shellcheck disable=SC2154

sherpa_main "$@"
