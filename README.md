<p align="center" width="100%">
    <img width="25%" src="./sherpa.png">
</p>

### Make Bash & the console Fun again

A little experiment, borrowing ideas from Rust Cargo, OhMyBash, Pug, CSS, Fetch API, CDN links, globally WebDev workflow ...transposed to Bash and the Terminal with eventually some touches of Docker.

_/!\ Sh:erpa is a work in progress, with some features and patterns not yet implemented, but already functional on a basic level. You can play with it, and see by yourself._

---

<a name="top"></a>

## Table of Contents

- [Introduction](#introduction)
- [Installation](#installation)
  - [Prerequisites](#prerequisites)
  - [Setup](#setup)
- [Characteristics](#characteristics)
  - [Modular structure](#modular-structure)
  - [Cargo-like project management](#cargo-like-project-management)
  - [Pug & CSS-like semantic syntax](#pug-like-semantic-syntax)
  - [Get JSON from an API](#get-json-from-an-api)
  - [Import code from Git (CDN style)](#import-code-from-git)
  - [Next toys (news from the pipeline)](#next-toys)
  - [Open key files in Vim (or other editor)](#quick-edits-on-key-files)
  - [OhMyBash-like Sh:erpa setup](#ohmybash-like-sherpa-setup)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)

## Introduction

We can use Bash for way more than cron-jobs and sys-admin automations. Inspired by tools like Cargo, OhMyBash, Deno/Bun, etc, ... Sh:erpa aim to blend-in some WebDev workflow to simplify scripts management the DRY and components-based way, integrate with scripts & libs produced by other devs and have some Unix Philosophy Fun together.

[Return to Top](#top)

## Installation

Ensure that you have curl installed, run `curl --version` and see if a number shows-up, or install it for your Distro/OS. I asume Linux, Linux inside WSL2 or MacOS.

Then simply run the installer:

```bash
curl -sSL https://raw.githubusercontent.com/SherpaBasecamp/sherpa/refs/heads/master/tools/install.sh | sudo bash
```

It will do three things:

- **A.** `Installing the CLI tools` if not already installed.

* [git](https://git-scm.com) : The standalone version, to clone sherpa
* [Rust](https://www.rust-lang.org) : With Cargo, to install usefull tools
* [bashdoc](https://github.com/dustinknopoff/bashdoc) : Docs generator from comments annontation
* [bashunit](https://github.com/TypedDevs/bashunit) : Great and complete test suite for Bash
* [gawk](https://www.gnu.org/software/gawk/manual/) : The awk spinoff _(needed by shdoc)_
* [jq](https://github.com/jqlang/jq) : JSON manipulation tool for Bash
* [pandoc](https://pandoc.org/) : Documents converter with Superpowers
* [shc](https://github.com/neurobin/shc) : Bash to Binary compiler, using C code
* [shdoc](https://github.com/reconquest/shdoc) : Another docs generator, more generalistic
* [shellcheck](https://www.shellcheck.net/): Bash linter, and more, he will yell at you
* [sherpa](https://github.com/AndiKod/sherpa) : Your companion bringing everything together
* [yq](https://github.com/mikefarah/yq) : Like **jq** but for yaml

- **B.** Clone the Sh:erpa repo as `~/.sherpa`
- **C.** Add `~/.sherpa/bin` to the $PATH

### Alternative Manual Install

Clone the program in the home folder:

```bash
git clone git@github.com:AndiKod/sherpa.git ~/.sherpa
```

From the awesome project [webinstall.dev](https://webinstall.dev) install for your OS, [Pathman](https://webinstall.dev/pathman/) and [Aliasman](https://webinstall.dev/pathman/) then use them to simply add ~/.sherpa/bin ont the path and eventually shorten up the sherpa command to something like `s`.

```bash
pathman add ~/.sherpa/bin
aliasman s sherpa
```

The compiled bianries for the CLI tools used, like yq, bashunit, etc are already in the `.sherpa/bin` by default, but you can install yours if you so wish.

For Bash or zsh, in either _~/.bashrc_ or _~/.zshrc_

```bash
# Make the Bin available
export PATH=$PATH:$HOME/sherpa/bin
# Shorter alias for sherpa
alias s="sherpa"
```

For the Fish shell in _~/.config/fish/config.fish_

```bash
# Make the Bin available
fish_add_path ~/.sherpa/bin
# Shorter alias for sherpa
alias s='sherpa' -s
```

Restart your terminal and press `sherpa` or your alias. Welcome.

[Return to Top](#top)

### Prerequisites

Obviously Bash, a good enough console is a plus ([WezTerm](https://wezfurlong.org/wezterm/index.html), [Alacritty](https://alacritty.org/), [WinTerminal](https://github.com/microsoft/terminal),...even the one that Windows will install along with Git or WSL2 will be enough.) and curl, for the Installer mode.

### Setup

Install via the Installer. Done!

Or Clone as `~/.sherpa` > add `~/.sherpa/bin` to the path. Done!

Then head to the `~/.sherpa/basecamp.sh` to customise some global variables.

## Characteristics

A few choices that were made to ease up the process of writing Bash things.

### Modular structure

Just like a little SPA WebApp, a ShellScript can fit in a single file and roll from that point, but as it grows it can become a nightmare to maintain and extend. Componenets, FTW.

Each Sh:erpa project aka BashBox, even for little things is made of separate files per logic unit (header, config, options, functions, commands/Routes...) and the post-processing is doing the rest with combining them into one file, generate documentation, stripp away all unnecessary parts for the production build and creating a symlink for direct invocation. The executable can be compiled to a binary via shc.

### Cargo-like project management

If you know Rust and Cargo, Sh:erpa is mimicking things like Cargo new, init, build, doc, test...

```bash
# Create a new BashBox
sherpa new myScript
```

Running `sherpa new myScript` will create a new BashBox (think Crate) `myScript`, initialize a git repo and copy over the starter template.

```bash
.
├── data
│   └── example.yaml
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

Both `run` and `build` are also creating a symlink between the script built and stored in `target/local/myScript` and a virtual file in `.sherpa/bin`, so for all the tests involving arguments you can use `myScript arg1 arg2`.
The `compile` command can transform the executable into a binary.

```bash
# Build and Run in one go
sherpa run

# ...after that, direct calls can be made
myScript arg1 arg2
```

For the pleasure of it, additional libraries are sourced with:

```bash
# source ~/.sherpa/lib/std/fmt.sh
# OR the same from the SherpaCustomDir

use "std/fmt"
```

### Pug-like semantic syntax

```bash
# src/bin.sh
use "std/fmt"

main() {
  h1 "I'm a bold, txtPrimary colored Title"
  hr "+" "-" # Fill the screen as ----+----
  text-center "Some centered text"
  br
  h2 "Normal, txtPrimary h2 Title"
  p "Some ${em}italic${x} text."
  br
  h3 "Like h2, but italic Title"
  p "${btnSuccess} Done! ${x} Well played."
  br
  em "check lib/std/fmt.sh"
}

# Load the main fn if no arguments
[[ "$#" == 0 ]] && main; exit 0
```

** Some tags **

| **Tag**  | **HTML equivalent**       | **Note**                                |
| -------- | ------------------------- | --------------------------------------- |
| `h1`     | `<h1>String</h1>`         | _Bold, txtPrimary, space below & above_ |
| `h2`     | `<h2>String</h2>`         | _Normal, txtPrimary, space below_       |
| `h3`     | `<h3>String</h3>`         | _Italic, txtPrimary, space below_       |
| `p`      | `<p>String</p>`           | _Single line paragraph, space below_    |
| `span`   | `<span>String</span>`     | _Single line paragraph, no new line_    |
| `br`     | `<br />`                  | _Inserting a blank line as a spacer_    |
| `em`     | `<em>string</em>`         | _A line of italic (emphased) text_      |
| `strong` | `<strong>string</strong>` | _A line of bold text_                   |

There are 8 colors, for both text or background, and font attributes like bold, italic, undeerlined. You can set any combination as a variable and it becomes a sort of a CSS class in combination with `${x}` that ends that style.

_The default txtPrimary is Green_

| **Text Color** | **Background Color** | **Font Style** |
| -------------- | -------------------- | -------------- |
| `txtBlack`     | `bgBlack`            | `strong`       |
| `txtRed`       | `bgRed`              | `disabled`     |
| `txtGreen`     | `bgGreen`            | `em`           |
| `txtYellow`    | `bgYellow`           | `u`            |
| `txtBlue`      | `bgBlue`             |                |
| `txtMagenta`   | `bgMagenta`          |                |
| `txtCyan`      | `bgCyan`             |                |
| `txtWhite`     | `bgLightGray`        |                |

```bash
# in some lib/bob/style.sh
link="${txtBlue}${u}${em}"

# in bin.sh
use "bob/style"

main() {
  # The url is blue, underlined & italic
  p "Visit ${link}https://acme.com${x}" now!
}
```

### Get JSON from an API

The local version of something like Axios or FetchAPI, in it's simplest form for the moment, but leveraging all the power that `jq` gives.

```bash
use "std/fmt"
article="https://someapi.com/post/77"

main() {
  h1 "$(fetch "$article" | jq ".title" )"
}
```

### Import code from Git

Just like one would add a CDN link to load Bootstap and use it's CSS classes, we can import libraries from git platforms and use their functions. By default it assumes Github, or recieve a full url to the "raw file" and import it from Codebarg or whatever else supporting the raw feature.

It use four flags:

- -u : url (Full url to a raw file on any git platform)
- -r : repo (Github repo as user/repo)
- -b : branch (defaults to master)
- -f : file (the file we want)

```bash
use "std/fmt"
import -r "user/repo" -f "file.sh"
import -u "https://codeberg.org/AndiKod/someRepo/raw/branch/master/someFile.sh"

main() {
  h1 "Testing the import() function"
  p "Print $(stuff_from_importedFile "arg1")"
  p "Or $(stuff_from_Codeberg "arg1" "arg2")"
}
```

### Next toys

Actually experimenting with the `viu` CLI tool writen in Rust, that can allow us to print actual jpg, png or gifs in the terminal as `img -w 10 "images/cat.png"`.

And some other things, even if cleaning up the actual code (as the repo is finally public) should come first. Classic, but eventually I'll manage to do a bit of both.

### Quick edits on key files

We can open with the default editor (set in ~/.sherpa/basecamp.sh, and defaulting to vim) some imporatnt files, with commands such as:

```bash
# Edit the main() function in src/bin.sh

sherpa edit bin
# OR
sherpa e bin
```

Besides `bin`, you can use `opt` to edit the custom --flags and options, `yaml` for the Sherpa.yaml file in the root with the project manifast data, or `basecamp` for the general Sh:erpa config.

[Return to Top](#top)

### OhMyBash-like Sherpa setup

Just like Oh-my-bash, Sh:erpa is basically a Git repository, holding .sh files and tools in a specific directories hyerarchy, splitted between the main directory (the one that gets updates, SherpaDotDir) and the custom one with content that can override/extend the core (SherpaCustomDir).

If Oh-My-Bash or Oh-My-Zsh are here to give superpowers when it comes to Bash and Console life configuration, Prompt themes, aliases, ...Sh:erpa complete them with helping devs to stay organised and DRY when writing serious Bash programs/apps or little fun scripts.

The Oh-My projects are community driven and let users add plugins and tools. In the same way you can clone somebody's cool BashBox, build it and extend/enhance your toolsKit and apps.

[Return to Top](#top)

## Usage

There are quite some commands available, I'll list some of them here, and the rest will be in the comming "full docs" and the `--help` or `-h` flags.

Remember to setup an alias to a shorter name, with something like `alias s="sherpa"` in `~/.bashrc` if you use Bash as main shell. That way you will have convenient commands like `s b` to build your BashBox from it's root folder, instead of the full `sherpa build`.

Basics:

| **Command**               | **Description**                                         |
| ------------------------- | ------------------------------------------------------- |
| `sherpa`                  | Just a homescreen with not much for the moment          |
| `sherpa new myScript`     | Create a new BashBox                                    |
| `sherpa init`             | Just like 'new' but from an existing directory          |
| `sherpa b, build`         | Build the myScript.sh and optimise things               |
| `sherpa r, run`           | Build the script and execute it                         |
| `sherpa t, test`          | Run tests from the tests/ dir, with BashUnit            |
| `sherpa d, doc`           | Build .md docs from files in src/, with shDoc & bashDoc |
| `sherpa compile`          | Compile myScript.sh to a binary, using SHC              |
| `sherpa clean`            | (To come. Will delete the target/ dir)                  |
| `sherpa e, edit bin`      | Open the src/bin.sh file                                |
| `sherpa e, edit opt`      | Open the src/\_options.sh file                          |
| `sherpa e, edit yaml`     | Open the Sherpa.yaml file                               |
| `sherpa e, edit basecamp` | Open the ~/.sherpa/basecamp.sh file                     |
| `sherpa links`            | List the Symlinks in ~/.sherpa/bin & their target       |
| `sherpa link rm "foo"`    | Delete the foo symlink from the bin/                    |

It's a beginning, other things are on their way to complete the toolbox, but it's already enough to play with and build your first BashBox.

_All commands except [sherpa alone, new, init, link, links] need to be invoked from the root directory of a BashBox, for relative paths to work._

## Contributing

The UNIX Philosophy is still something great. In short "Write simple programs that do one thing, and can inter-operate with the others." Every BashBox you write and save on a git platform can be used by a fellow developper to create another one, and together we can build a BashBox ecosystem.

A little Discord server will be up, so you could come and hang out together or talk about CLI life without being "the weird one" at the familly table.

The coming documentation website will be built with Starlight-Astro, so correcting the english version or translating to your native language will be possible.

A BashBox don't need to be the ultimate CLI program or the next-gen library, you can even use one as cosole-based web page we can 'install > read' in the console, then later 'update > read the new post' by invoking it like `JoeBlog "Some article!"`. In short, we can be creative and have fun.

## License

Maybe something like MIT or other, I'll need to see what the FSF is advising.

---

-Andrei-
