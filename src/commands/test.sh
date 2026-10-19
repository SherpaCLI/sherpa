# @file Test
# @brief Running the tests from the ./tests dir with bashunit
# @description
#
#    To be used from the root of a Sherpa project,
#    created with "sherpa new myProject".
#
#    It will:
#      * Run the tests
#      * Display the results
#
#  Usage: sherpa t, test
#

# ----------------------- #
#  BashUnit Tests Command #
# ----------------------- #

# Run the examples declared in interface.examples.
# They are the executable contract of the package: every one of them
# must exit 0. Entries are plain shell, exactly as you would type them.
run_examples() {
	local manifest="Sherpa.yaml"
	[[ -f "$manifest" ]] || return 0

	local examples
	examples="$(yq e '.interface.examples[]' "$manifest" 2>/dev/null || true)"
	[[ "$examples" == "null" || -z "$examples" ]] && return 0

	local executable
	executable="$(get_yaml_item "package.executable" "$manifest" 2>/dev/null || true)"
	[[ "$executable" == "null" || -z "$executable" ]] && return 0

	if [[ ! -x "target/local/${executable}" ]]; then
		p "${btnWarning} Note: ${x} not built yet, skipping the examples."
		return 0
	fi

	h2 " Examples"

	local example failed="off"
	while IFS= read -r example; do
		[[ -z "$example" || "$example" == "null" ]] && continue
		if PATH="$(pwd)/target/local:${SDD}/bin:${PATH}" bash -c "$example" >/dev/null 2>&1; then
			p " ${btnSuccess} ok ${x} ${em}${example}${x}"
		else
			p " ${btnDanger} failed ${x} ${em}${example}${x}"
			failed="on"
		fi
	done <<<"$examples"

	br
	[[ "$failed" == "on" ]] && return 1
	return 0
}

# Routed by src/router.sh

cmd_test() {

	if [[ "$1" == "test" || "$1" == "t" ]]; then # test

		# Check if we are in a Sh:erpa project folder
		if [[ ! -f Sherpa.yaml ]]; then
			br
			p "${btnWarning} Oops! ${x} Probably not in a Sherpa project root."
			br
			exit 1
		fi

		# Check if registers are here, or create them
		[[ ! -d "${SCD}/registers" ]] && mkdir "${SCD}/registers"
		[[ ! -f "${SCD}/registers/" ]] && touch "${SCD}/registers/tests.yaml"

		key=$(date "+%s")
		value="$(pwd)/tests"
		file="${SCD}/registers/tests.yaml"

		# Save a log into the tests registers
		# in ${SCD}/registers/tests.yaml
		# 2025-jan-21: /path/to/tests/dir
		add_yaml_item "$key" "$value" "$file"

		# The examples in the manifest are part of the contract
		run_examples || examples_failed="on"

		bashunit tests

		[[ "$examples_failed" == "on" ]] && exit 1
	fi # End test
}
