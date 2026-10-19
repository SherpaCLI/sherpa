#!/usr/bin/env bash

# @file Make
# @brief Assemble bin/sherpa from the partials in src/
# @description
#
#	The build of Sh:erpa itself. Run it as ./Make.sh from the src/
#	directory of any checkout: it reads that checkout, not $HOME, so
#	a dev tree or a sandbox can be built without touching the
#	installed copy.
#
#	It will:
#	  * Write the ordered list of partials to src/__paths.txt
#	  * Regenerate docs/commands/*.md with shdoc
#	  * Concatenate the partials, add the shebang
#	  * write bin/sherpa and make it executable
#
#	The order matters: the router is concatenated before
#	help/options.sh (so the help screen can read the command table),
#	and main.sh goes last to call the entry point.
#
#  Usage: ./Make.sh          (from src/)
#	./Make.sh compile  (compile bin/sherpa to a binary with SHC)
#

MAKE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)" # .../src
REPO_DIR="$(dirname "$MAKE_DIR")"                        # the checkout root

# Build from this checkout unless told otherwise
SHERPA_DOT_DIR="${SHERPA_DOT_DIR:-$REPO_DIR}"
export SHERPA_DOT_DIR

. "${SHERPA_DOT_DIR}/basecamp.sh"

# Sourcing libs from the lib directory
use "std/fmt"

#
# ------- Build the Script --------
#

if [[ "$#" == 0 ]]; then

	shebang="${MAKE_DIR}/shebang.sh"
	sourceOrder="${MAKE_DIR}/__paths.txt"
	combinedScript="${REPO_DIR}/scriptAlmost.sh"
	finalScript="sherpa"

	h1 " -= Building =-"
	hr "Sh:erpa" "-"
	br
	p "- Generating the partials paths..."

	# Partials, in build order
	globals="${REPO_DIR}/src/_globals.sh"
	basecamp="${REPO_DIR}/basecamp.sh"
	fmt="${REPO_DIR}/lib/std/fmt.sh"
	symlink="${REPO_DIR}/lib/tent/symlink.sh"
	router="${REPO_DIR}/src/router.sh"
	options="${REPO_DIR}/src/help/options.sh"
	main="${REPO_DIR}/src/main.sh"

	# Commands
	home="${REPO_DIR}/src/commands/home.sh"
	bashdoc="${REPO_DIR}/src/commands/bashdoc.sh"
	compile="${REPO_DIR}/src/commands/compile.sh"
	edit="${REPO_DIR}/src/commands/edit.sh"
	box="${REPO_DIR}/src/commands/box.sh"
	link="${REPO_DIR}/src/commands/link.sh"
	links="${REPO_DIR}/src/commands/links.sh"
	build="${REPO_DIR}/src/commands/build.sh"
	new="${REPO_DIR}/src/commands/new.sh"
	init="${REPO_DIR}/src/commands/init.sh"
	run="${REPO_DIR}/src/commands/run.sh"
	doc="${REPO_DIR}/src/commands/doc.sh"
	test="${REPO_DIR}/src/commands/test.sh"
	list="${REPO_DIR}/src/commands/list.sh"
	install="${REPO_DIR}/src/commands/install.sh"
	uninstall="${REPO_DIR}/src/commands/uninstall.sh"
	update="${REPO_DIR}/src/commands/update.sh"
	self_update="${REPO_DIR}/src/commands/self_update.sh"
	watch="${REPO_DIR}/src/commands/watch.sh"

	: >"$sourceOrder"

	# Definition layer: must come before options.sh, which prints
	# the command table when asked for help.
	for partial in \
		"$basecamp" \
		"$fmt" \
		"$symlink" \
		"$router"; do
		echo "$partial" >>"$sourceOrder"
	done

	# Global flags, parsed at start-up
	echo "$options" >>"$sourceOrder"

	# Commands
	for partial in \
		"$home" \
		"$bashdoc" \
		"$compile" \
		"$edit" \
		"$box" \
		"$link" \
		"$links" \
		"$build" \
		"$new" \
		"$init" \
		"$run" \
		"$doc" \
		"$test" \
		"$list" \
		"$install" \
		"$uninstall" \
		"$update" \
		"$self_update" \
		"$watch"; do
		echo "$partial" >>"$sourceOrder"
	done

	# Entry point, last
	echo "$main" >>"$sourceOrder"

	p "...to ${sourceOrder}"

	#
	#  Generating Commands Docs
	#

	p "- Generating docs in docs/commands ..."
	[[ ! -d "${REPO_DIR}/docs/commands" ]] && mkdir -p "${REPO_DIR}/docs/commands"
	for file in "${REPO_DIR}"/src/commands/*; do
		filename=$(basename "$file")
		shdoc <"$file" >"${REPO_DIR}/docs/commands/${filename%.sh}.md"
	done

	br
	p "- Combining the files listed in ${sourceOrder}..."

	cat $(<"$sourceOrder") >"$combinedScript"
	if [[ -f "$combinedScript" ]]; then
		p "- Combined them into ${combinedScript}!"

		p "- Adding the /usr/bin/env bash shebang..."
		cat "$shebang" "$combinedScript" >"${REPO_DIR}/bin/$finalScript"
		rm "$combinedScript"

		p "- Making it executable..."
		chmod +x "${REPO_DIR}/bin/$finalScript"
		echo
		p "${btnSuccess} Done! ${x} It lives in ${txtGreen}${em}bin/${finalScript}${x}"
		br
	else
		p "${btnWarning} Oops! ${x} Something went wrong."
		exit 1
	fi
fi

#
# @description Compile Sh:erpa itself
#

if [[ "$1" == "compile" ]]; then # Compile

	executable="$(get_yaml_item "package.executable" "${REPO_DIR}/Sherpa.yaml")"
	if [[ "$executable" == "null" || -z "$executable" ]]; then
		executable="sherpa"
	fi

	script="${REPO_DIR}/bin/${executable}"
	scriptCopy="/tmp/opencode/${executable}-copy"

	if [[ ! -f "$script" ]]; then # IsFile
		p "Oops! Run first: ${em}./Make.sh${x}"
		exit 1
	fi

	[[ ! -d "${REPO_DIR}/target/bin" ]] && mkdir -p "${REPO_DIR}/target/bin"

	# Replace the Shebang, as SHC does not support /usr/bin/env
	cp "$script" "$scriptCopy"
	sed_inplace "$scriptCopy" 's|#!/usr/bin/env bash|#!/bin/bash|g'

	echo "Compiling to Binary via SHC..."
	export CC=gcc
	shc -vrf "$scriptCopy" -o "${REPO_DIR}/target/bin/${executable}"

	if [[ "$?" == 0 ]]; then
		br
		p "${btnSuccess} Done! ${x} The binary is stored in target/bin"
		rm "$scriptCopy"
		br
	else
		br
		p "Ooops! Command failed, with the ${?} exit code."
		br
	fi
fi
