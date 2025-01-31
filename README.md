<p align="center">
    <img src="sherpa.png" alt="Sh:erpa Logo"/>
</p>

## Making Bash scripting, a Fun adventure!

**Sh:erpa** brings Cargo, OhMy and WebDev worflow to Bash scripting, using the Terminal as a browser!

_Because WebDevs should be able to do more than `npm run dev` in a terminal, and Bash lovers don't have to be reduced to `automations` writers, obviously because I like both sides._

Docs: [sherpa-cli.netlify.app](https://sherpa-cli.netlify.app) - Discord: [Community Discord Server](https://discord.gg/66bQJ6cuXG)

### Quick install

Be sure to have Bash, curl, gawk instaled, then run the installer:

```bash
bash -c "$(curl -sLo- https://sherpa-cli.netlify.app/install.sh)"
```

It will do the following:

- A. Install the CLI tools if not already installed.
- B. Clone the Sh:erpa repo as ~/.sherpa
- C. Add to the $PATH ~/.sherpa/bin
- D. Initiate the SherpaCustomDir as ~/sherpa

Use a Linux Distribution, still a Linux Distro but from WSL2 or MacOS.
See [the docs](https://sherpa-cli.netlify.app/getting-started/installation/prerequisites) for more details.

### The BashBox Anatomy

Upon `sherpa new myScript` the following is generated:

```bash
# /home/user/sherpa/boxes/myScript
.
├── data
│   └── file.yaml
├── docs
│   └── myScript.md
├── README.md
├── Sherpa.yaml
├── src
│   ├── bin.sh
│   ├── _globals.sh
│   ├── _header.sh
│   ├── _lib.sh
│   ├── _options.sh
│   └── __paths.txt
├── target
│   └── local
│       └── myScript
└── tests
    └── example_test.sh
```

A simple `src/bin.sh` file could look like that:

```bash
use "std/fmt"

main() {
  # Data
  dude="$(dataGet "hiker" "name")"

  # Template
  h1 "Greetings adventurer :)"
  hr "+" "-" # ------+------
  br
  p  "Welcome ${txtBlue} ${dude} ${x}!"
}

# Load the main fn if no arguments
[[ "$#" == 0 ]] && main; exit 0
```

Sh:erpa will merge the partials plus those sourced with `use "dir/file"`, generte docs, remove comments and blanks, then build the script and make it available for direct invocations. The tool can be picked-up by WebDevs discovering Bash or experienced shell scripters taking advantage of the build, watch and modularity while writing things their own way.

### Features

Check **[the Sh:erpa Website](https://sherpa-cli.netlify.app)** or come talk in the **[Discord](https://discord.gg/66bQJ6cuXG)**, but some included features are:

- Modular + build-step workflow
- Pug-like semantic formating
- Non verbose styling options
- CRUD operations on .yaml files
- Fetch API data and use JSON in Bash
- CDN-like imports for remote Libs
- Integrated UnitTests suite
- Docs generation from comments
- Install/Up/Remove remote BashBox or Lib
- Source local libs with `use "dir/file"`
- Helpers for env variables or package data
- Helper for `Are you sure? (y/n)` confirm
- ...to name some of them.

### Commands

| 🔗                                                              | **Command**                  | **Description**                                         |
| --------------------------------------------------------------- | ---------------------------- | ------------------------------------------------------- |
| [🔗](https://sherpa-cli.netlify.app/commands/sherpa)            | `sherpa`                     | Dashboard. List of local/remote scripts & libs          |
| [🔗](https://sherpa-cli.netlify.app/commands/package/new)       | `sherpa new <myPackage>`     | Create a BashBox directory and script                   |
| [🔗](https://sherpa-cli.netlify.app/commands/package/new)       | `sherpa new <myPackage> lib` | Create a BashLib directory and library file             |
| [🔗](https://sherpa-cli.netlify.app/commands/package/rm)        | `sherpa rmBox <boxName>`     | Delete a local BashBox and clean registers              |
| [🔗](https://sherpa-cli.netlify.app/commands/package/rm)        | `sherpa rmLib <libName>`     | Delete a local BashLib and clean registers              |
| [🔗](https://sherpa-cli.netlify.app/commands/package/install)   | `sherpa install ...`         | See docs. Installing a remote BashBox or Lib            |
| [🔗](https://sherpa-cli.netlify.app/commands/package/uninstall) | `sherpa uninstall ...`       | See docs. Uninstalling a remote BashBox or Lib          |
| [🔗](https://sherpa-cli.netlify.app/commands/package/update)    | `sherpa update <boxName>`    | Update an installed BashBox                             |
| [🔗](https://sherpa-cli.netlify.app/commands/package/update)    | `sherpa upLib <libName>`     | Update an installed BashLib                             |
| [🔗](https://sherpa-cli.netlify.app/commands/package/update)    | `sherpa self-update`         | Update sh:erpa itself to the lastes version             |
| [🔗](https://sherpa-cli.netlify.app/commands/package/init)      | `sherpa init`                | Just like 'new' but from an existing directory          |
| [🔗](https://sherpa-cli.netlify.app/commands/build/build)       | `sherpa b, build`            | Build the myScript.sh and optimise things               |
| [🔗](https://sherpa-cli.netlify.app/commands/build/watch)       | `sherpa w, watch`            | Watching for changes and build on file-save             |
| [🔗](https://sherpa-cli.netlify.app/commands/build/run)         | `sherpa r, run`              | Build the script and execute it                         |
| [🔗](https://sherpa-cli.netlify.app/commands/package/test)      | `sherpa t, test`             | Run tests from the tests/ dir, with BashUnit            |
| [🔗](https://sherpa-cli.netlify.app/commands/package/test)      | `sherpa self-test`           | Run Sh:erpa's tests from ~/.sherpa/tests                |
| [🔗](https://sherpa-cli.netlify.app/commands/build/doc)         | `sherpa d, doc`              | Build .md docs from files in src/, with shDoc & bashDoc |
| [🔗](https://sherpa-cli.netlify.app/commands/build/compile)     | `sherpa compile`             | Compile myScript.sh to a binary, using SHC              |
| [🔗](https://sherpa-cli.netlify.app/commands/general/edit)      | `sherpa e, edit bin`         | Open the src/bin.sh file                                |
| [🔗](https://sherpa-cli.netlify.app/commands/general/edit)      | `sherpa e, edit opt`         | Open the src/\_options.sh file                          |
| [🔗](https://sherpa-cli.netlify.app/commands/general/edit)      | `sherpa e, edit yaml`        | Open the Sherpa.yaml file                               |
| [🔗](https://sherpa-cli.netlify.app/commands/general/edit)      | `sherpa e, edit basecamp`    | Open the ~/.sherpa/basecamp.sh file                     |
| [🔗](https://sherpa-cli.netlify.app/commands/general/aliases)   | `sherpa aliases`             | List/edit the aliases created with Aliasman             |
| [🔗](https://sherpa-cli.netlify.app/commands/general/links)     | `sherpa links`               | List the Symlinks in ~/.sherpa/bin. (Old command)       |

Since relative paths are used, some commands need to be used from a package root directoy: build, watch, run, test, doc, compile, edit.

### Aliases

Upon first install, some aliases are created via Aliasman. They can be visualised and eventually changed via `sherpa aliases` command, wich is just a shortcut for `aliasman -e` and opens the file storing them (with the default editor, like vim).

| **alias** | **replace**           | **effect**                      |
| --------- | --------------------- | ------------------------------- |
| s         | sherpa                | Shorter `s` commands            |
| sdd       | cd $HOME/.sherpa      | Jump into the Sherpa Dot Dir    |
| scd       | cd $HOME/sherpa       | Jump into the Sherpa Custom Dir |
| boxes     | cd $HOME/sherpa/boxes | Jump into the local Boxes Dir   |

After having created a BashBox with `s new <myScript>`, you can:

- Jump into the directory: `boxes && cd myScript`
- Open the main file: `s e bin`
- or any other command you need from the Root.

### Credits

Special shoutout to every person who has contributed code and genius ideas to the computing world since the first second of the Unix timestamp, making todays coding possible. Plus...

- Rust Cargo: For the perfect package management workflow.
- OhMyBash/ZSH: For the core/custom architecture inspiration.
- Webinstall.dev: For making the install possible via the awesome webi tool.
- Integrated projects: BashUnit, shdoc, bashdoc, SHC, Pathman, Aliasman, WatchExec, ...
- The non-dev people around me, enduring my talks about CLI, WebDev & how interesting Sh:erpa can be. They all hope that the Discord will be active enough so I could spare them.
