# @file Build
# @brief Create the script from partials, generate docs, link it
# @description
#
#	To be used from the root of a BashBox, created with
#	"sherpa new myProject".
#
#	It will:
#	  * Generate the list of partials to combine
#	  * Extract the paths from `use "collection/lib"` in src/bin.sh
#	  * Put every partial together into a single file
#	  * Generate the docs from the shdoc comments
#	  * Add the /usr/bin/env bash shebang
#	  * Place the result in target/local
#	  * Make it executable
#	  * Symlink it into the bin directory for global availability
#
#	Minification is opt-in (--minify). It used to be the default and
#	it is destructive: it removes '#' inside heredocs and strings and
#	flattens meaningful indentation. A readable build is a feature.
#
#  Usage: sherpa b, build [--minify]
#

# shellcheck disable=SC2154

# Symlink target/local/<executable> into the bin directory, so the
# command can be invoked directly from anywhere.
link_package() {
	local executable="$1"
	local symlink="${SDD}/bin/${executable}"
	local current

	current="$(readlink -f "$symlink" 2>/dev/null || true)"

	# Already pointing at this very build: nothing to do.
	if [[ -L "$symlink" && "$current" == *"target/local"* ]]; then
		return 0
	fi

	[[ -L "$symlink" ]] && rm "$symlink"
	ln -s "$(pwd)/target/local/${executable}" "$symlink"
	p "- Linked ${em}${executable}${x} into ${em}${SDD}/bin${x}"

	return 0
}

# Combine the partials into target/local/<executable>, generate the
# documentation and link the result. Shared by build and run.
build_package() {
	local minify="${1:-off}"

	local shebang="src/_header.sh"
	local sourceOrder="src/__paths.txt"
	local combinedScript="scriptAlmost.sh"
	local finalScript

	if [[ ! -f "Sherpa.yaml" ]]; then
		p "${btnWarning} Oops! ${x} You are maybe not in a BashBox root."
		exit 1
	fi

	finalScript="$(get_yaml_item "package.executable" "Sherpa.yaml")"
	if [[ "$finalScript" == "null" || -z "$finalScript" ]]; then
		p "${btnWarning} Oops! ${x} ${em}package.executable${x} is missing from Sherpa.yaml"
		exit 1
	fi

	[[ ! -d target ]] && mkdir target
	[[ ! -d target/local ]] && mkdir target/local

	[[ "$quiet" != "on" ]] && p "- Generating the partials list..."

	# Fills src/__paths.txt from the `use "lib/file"` statements
	use2path

	[[ "$verb" == "on" ]] && echo "VB: combining the files listed in ${sourceOrder}"

	mapfile -t files <"$sourceOrder"
	cat "${files[@]}" >"$combinedScript"

	if [[ ! -f "$combinedScript" ]]; then
		p "${btnWarning} Oops! ${x} Something went wrong while combining the partials."
		exit 1
	fi

	[[ "$quiet" != "on" ]] && p "- Generating the documentation..."
	[[ ! -d docs ]] && mkdir docs
	shdoc <"$combinedScript" >"docs/${finalScript}.md"

	if [[ "$minify" == "on" ]]; then
		p "- Minifying: comments, blank lines and indentation..."
		# [[:space:]] rather than \s: BSD sed (macOS) has no \s
		sed_inplace "$combinedScript" -E \
			-e '/^[[:space:]]*#/d' \
			-e '/^[[:space:]]*$/d' \
			-e 's/[[:space:]]+$//' \
			-e 's/^[[:space:]]+//'
	fi

	cat "$shebang" "$combinedScript" >"target/local/$finalScript"
	rm "$combinedScript"
	chmod +x "target/local/$finalScript"

	p "${btnSuccess} Done! ${x} Run it with ${txtGreen}${em}${finalScript}${x}"
	br

	link_package "$finalScript"
}

cmd_build() {
	local minify="off"

	# Drop the command word, so the flags below actually parse
	if [[ $# -gt 0 ]]; then shift; fi

	while getopts ":t:-:" opt; do
		case $opt in
		t)
			# Reserved: build type (bin|lib). Not implemented yet.
			:
			;;
		-)
			case "${OPTARG}" in
			minify) minify="on" ;;
			*)
				p "${btnWarning} Oops! ${x} Unknown flag: --${OPTARG}"
				exit 1
				;;
			esac
			;;
		*)
			echo "Invalid option: -$OPTARG" >&2
			exit 1
			;;
		esac
	done
	OPTIND=1

	[[ "$quiet" != "on" ]] && h1 " Building..."
	build_package "$minify"
}
