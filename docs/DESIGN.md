# Design

What Sh:erpa is, what it deliberately is not, and the rules that keep the
codebase honest. This is the human-facing version; the agent-facing contract
lives in the `sherpa-core` skill.

## What this is

A BashBox is a directory that turns into **one readable shell script** and a
command on `PATH`. You keep it as small partials, build it into a single file,
and the comments you already wrote become its documentation.

The positioning that matters: **the deterministic artifact layer for
agent-authored scripts.** An agent can write shell; what it cannot do reliably
is make that shell installable, documented, tested and portable. Sh:erpa owns
that second half.

Direct users are geeks. Vibecoders are served *through* their agent, not by
using the CLI themselves. That is why the machine-readable surface
(`sherpa list --json`, `interface.when`) is a first-class product, not a
nice-to-have.

## Scope

**In:** `new`, `init`, `build`, `run`, `edit`, `doc`, `test`, `list`, `links`,
the dashboard, `std/fmt`, and local box management (`localBox`, `rmBox`,
`rmLib`, `upBox`, `upLib`, `install`, `uninstall`, `update`).

**Out, for now:** the registry, remote install/update as a *catalogue*,
`import` (`curl | source`), `compile` by default, watch mode. These are not
rejected forever; they are rejected *until the core is finished and there are
users*. Building a marketplace with zero users is the most expensive way to
learn that nobody wanted it.

**Success bar:** a stranger installs, runs `sherpa new`, edits, builds, and gets
a working command on `PATH` in under five minutes, on Linux and macOS.

## The model

```
Sherpa.yaml          manifest: what this is, when to use it
src/bin.sh           entry point: the main flow + the `use` lines
src/_globals.sh      constants (ROOT)
src/_options.sh      flags and usage
src/_lib.sh          local helpers
src/_header.sh       shebang + the shdoc header
lib/                 optional shared libs, from ${SCD}/lib then ${SDD}/lib
tests/               bashunit tests
target/local/<exe>   the build
```

`use "collection/lib"` is the only dependency edge. `use2path` resolves it,
custom dir first, and writes the ordered list of partials. The build
concatenates that list: no runtime resolution, no `source`, no `PATH` lookup.

**Why concatenation:** the artifact is one file you can read, copy, and ship.
That is the product. The cost is a single namespace and no lazy loading, which
is acceptable for scripts of this size.

**The rule that follows:** one namespace means lib functions must be prefixed
with the lib name (`fmt_h1`, not `h1`). `use2path` reports duplicate function
definitions as a warning. `std/fmt.sh` predates the rule and is the one
grandfathered exception; renaming it to `fmt_*` is a future mechanical pass.

## The manifest

```yaml
sherpa: 1

package:
  name: pushAll                 # required
  description: "Commit, push and open the PR."
  version: 0.1.0
  repo: github.com/you/pushAll
  executable: pushAll
  type: localBin                # localBin | localLib | bbrBin | bbrLib | dotDir

interface:
  when: >-                      # the routing hint: when to reach for this
    Use when a repo has several unrelated changes to ship and you want
    one reviewed commit per concern.
  usage: pushAll [options]
  examples:                     # executed by `sherpa test`
    - pushAll --help
  exit_codes:
    0: Success
    1: Bad usage
  requires:
    commands: [git, gh]
```

- Only `package.name` is required. Everything else has a default.
- `interface.when` is the highest-value field in the file. It is what lets an
  agent choose a tool without reading its source.
- `build:` is optional: `entry` (`src/bin.sh`), `partials`
  (`src/__paths.txt`), `minify` (off), `docs` (on).
- `sherpa list --json` emits exactly this block per package, which is the
  inventory an agent reads first.

## Build pipeline

1. `use2path` resolves `use` lines into an ordered partial list.
2. The partials are concatenated.
3. `shdoc` turns the comments into `docs/<exe>.md`.
4. The shebang is prepended, the result is written to `target/local/<exe>`,
   made executable, and symlinked into `${SDD}/bin`.

**Minification is opt-in** (`--minify`). It used to be the default and it is
destructive: it deletes `#` inside heredocs and strings, and flattens
indentation that can be meaningful. A readable build is a feature.

## Command dispatch

Each command is a `cmd_*()` function in `src/commands/`. `src/router.sh` holds
the single command table (`sherpa_commands`) and `sherpa_main`, which maps a
word or alias to the function. `src/main.sh` calls it last.

Consequences: a typo is an error instead of a silent no-op; two files cannot
shadow each other's command; the help screen and the router cannot drift apart;
each command can reset `OPTIND` and parse its own flags.

## Working on Sh:erpa itself

`~/.sherpa` is both the canonical clone and the runtime. `src/Make.sh` is
self-locating, so a *copy* of the tree builds its own binary:

```bash
SANDBOX=/tmp/opencode/sherpa-dev
rm -rf "$SANDBOX"; mkdir -p "$SANDBOX"
tar cf - --exclude=.git --exclude=target -C ~/.sherpa . | tar xf - -C "$SANDBOX"
(cd "$SANDBOX/src" && ./Make.sh)

SHERPA_DOT_DIR="$SANDBOX" SHERPA_CUSTOM_DIR=/tmp/opencode/custom \
  PATH="$SANDBOX/bin:$PATH" "$SANDBOX/bin/sherpa" help
```

`SHERPA_DOT_DIR`, `SHERPA_CUSTOM_DIR` and `SHERPA_EDITOR` exist so a dev tree or
a test sandbox never touches the real installation. `bin/sherpa` on `PATH` only
changes when you rebuild in `~/.sherpa` itself, so editing `src/` is safe.

## Conventions

- **Anti-DRY.** Optimise for deletability, not reuse. In shell, a wrong
  abstraction is more expensive than duplication.
- Guard anything that can fail benignly: `tput` with no TTY, `git` with no
  network, `yq` on a missing key. The runtime is `set -eo pipefail`.
- **GNU and BSD.** Use `sed_inplace` from `basecamp.sh` (BSD `sed -i` needs a
  suffix), `[[:space:]]` instead of `\s`, no `find -printf`.
- Reset `OPTIND=1` after getopts, and shift the command word before parsing
  flags.
- Errors are `p` plus `exit 1`, never silence.

## Known debt

- `std/fmt.sh` exports generic globals (`p`, `em`, `br`, `hr`, `a`, `u`, `x`).
- `bin/` carries committed binaries and symlinks pointing at one machine.
- No CI; `tests/basecamp_test.sh` is thin.
- `tools/install.sh` (`curl | sudo bash`) still needs work.
- Older `src/` files indent with two spaces, newer ones with tabs. Normalise
  when touching a file.
