# @file UpBox
# @brief Update an installed (remote) BashBox
# @description
#
#	To be used from anywhere.
#
#	It will:
#	  * Move into ${SCD}/bbr/bin/<boxName>
#	  * Pull the latest content
#	  * Build the package again
#
#	The local rmBox/rmLib/upLib commands live in src/commands/box.sh.
#	This file used to carry a second, near-identical rmBox that
#	shadowed the one in box.sh, because the later file wins in the
#	concatenation. That duplicate is gone.
#
#  Usage: sherpa upBox <boxName>
#

# shellcheck disable=SC2154

cmd_upBox() {
	# Most of the time, the same as the directory name
	# in ${SCD}/bbr/bin/<boxName>
	boxName="${2:-}"

	if [[ -z "$boxName" ]]; then
		p "${btnWarning} Oops! ${x} Usage: ${em}sherpa upBox <boxName>${x}"
		exit 1
	fi

	# Check if it exists
	if [[ ! -d "${SCD}/bbr/bin/${boxName}" ]]; then
		br
		p "${btnWarning} Oops! ${x} There is no ${txtBlue}${boxName}${x} directory in bbr/bin/"
		br

		exit 1
	fi

	confirm "Do you want to update ${boxName}?"

	br
	p " No problem, let's go..."
	br

	# Get inside
	p "- Moving into the Directory"
	cd "${SCD}/bbr/bin/${boxName}" || return

	# Pull
	p "- Pulling latest content"
	git pull

	# Re-Build
	p "- Build again..."
	sherpa build
	br

	return 0
}
