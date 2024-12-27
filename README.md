<p align="center" width="100%">
    <img width="25%" src="./sherpa.png">
</p>

### Make Bash & the console Fun again

A little experiment, borrowing ideas from Rust Cargo, OhMyBash, Pug, CSS, Fetch API, CDN links, globally WebDev workflow ...transposed to Bash and the Terminal with eventually some touches of Docker.

---

<a name="top"></a>

## Table of Contents

- [Introduction](#introduction)
- [Installation](#installation)
  - [Prerequisites](#prerequisites)
  - [Setup](#setup)
- [Characteristics](#characteristics)
  - [Bin batteries included](#bin-batteries-included)
  - [Modular structure](#modular-structure)
  - [Cargo-like project management](#cargo-like-project-management)
  - [OhMyBash-like Sh:erpa setup](#ohmybash-like-sherpa-setup)
  - [Pug & CSS-like semantic syntax](#pug-like-semantic-syntax)
  - [Get JSON from an API](#get-json-from-an-api)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)

/!\ This is a draft, the real docs will be up on Vercel, and that repo is a work in progress, on public mode just for tests.

## Introduction

We can use Bash for way more than cron-jobs and sys-admin automations. Inspired by tools like Cargo, OhMyBash, Google's ZX, etc, ...with Sh:erpa I tried to blend-in some WebDev workflow to simplify my own little scripts management, the DRY way. Eventually it will help some others too.

[Return to Top](#top)

## Installation

Clone the program in the home folder:

```bash
git clone git@github.com:AndiKod/sherpa.git ~/.sherpa
```

### Webinstall.dev tools

From the awesome project [webinstall.dev](https://webinstall.dev) install for your OS, [Pathman](https://webinstall.dev/pathman/) and [Aliasman](https://webinstall.dev/pathman/) then use them to simply add ~/.sherpa/bin ont the path and eventually shorten up the sherpa command to something like `s`.

```bash
pathman add ~/.sherpa/bin
aliasman s sherpa
```

### Manual Install

For _Bash_ or _zsh_, in either _~/.bashrc_ or _~/.zshrc_

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

Restart your terminal and press `s`. Welcome.

[Return to Top](#top)

### Prerequisites

Obviously Bash, a good enough console is a plus (WezTerm, Alacritty, WinTerminal,...) and Git. The rest is included.

### Setup

Install, add to path. Done!

## Characteristics

A few choices that were made to ease up the process of writing Bash things.

### Bin batteries included

Sherpa is using other libraries for specific tasks like Unit tests, Docs generation, and more. Instead of installing all of them each time we are on another machine, a little stock of usefull programs are already in .sherpa/bin out-of-da-box. If you already have them installed, the system will use the first one he finds on the path anyway, and if you don't ...you have it, and it just works.

So far, Sh:erpa comes with:

- [bashdoc](http://) : Docs generator from comments annontation
- [bashunit](https://) : Great and complete test suite for Bash
- [gawk](https://) : The awk spinoff _(needed by shdoc)_
- [jq](https://) : JSON manipulation tool for Bash
- [pandoc](http://) : Documents converter with Superpowers
- [shc](https://) : Bash to Binary compiler, using C code
- [shdoc](https://) : Another docs generator, more generalistic
- [shellcheck](https://): Bash linter, and more, he will yell at you
- [sherpa](http://) : Your companion bringing everything together
- [yq](https://) : Like **jq** but for yaml

### Modular structure

Just like WebApps, a little SPA can fit in a single file and roll from that point, but as it grows it can become a nightmare to maintain and extend. Componenets, FTW.

Sh:erpa projects, even for little things are made of separate files per logic unit (header, config, options, functions, commands aka Routes...) and twhe system is doing the rest with combining them into one file, generate documentation and stripp away all unnecessary parts for the production build.

```bash
.
├── data
│   └── example.yaml
├── docs
│   └── cucumba.md
├── README.md
├── Sherpa.yaml
├── src
│   ├── bin.sh
│   ├── _globals.sh
│   ├── _header.sh
│   ├── _lib.sh
│   ├── _options.sh
│   └── __paths.txt
├── target
│   └── local
│       └── cucumba
└── tests
    └── example_test.sh
```

### Cargo-like project management

If you know Rust and Cargo, Sh:erpa is mimicking things like Cargo new, init, clean, run (basic), build, doc, test...

```bash
# Create a new project directory
sherpa new myProject
```

Running `sherpa new myProject` will create a new directory `myProject` initialize a git repo and copy over the starter project template.

Both `run` and `build` are also creating a symlink between the script built and stored in `target/local/myProject` and a virtual file in `.sherpa/bin` so for all the tests involving arguments you can just use `myProject arg1 arg2`.

```bash
# Edit the main entry function & route
sherpa edit bin
```

...then

```bash
# Build and Run in one go
sherpa run
```

For the pleasure of it, additional libraries are sourced with:

```bash
# source ~/.sherpa/lib/std/fmt.sh OR the same from the SherpaCustomDir
use "std/lib"
```

[Return to Top](#top)

### OhMyBash-like Sherpa setup

Just like Oh-my-bash, Sh:erpa is basically a Git repository, holding .sh files and tools in a specific directories hyerarchy, splitted between the main directory (the one that gets updates, SherpaDotDir) and the custom one with content that can override/extend the core (SherpaCustomDir).

If Oh-My-Bash or Oh-My-Zsh are here to give superpowers when it comes to Bash and Console life configuration, Prompt themes, aliases, ...Sh:erpa complete them with helping devs to stay organised and DRY when writing serious Bash programs/apps or little fun scripts.

The Oh-My projects are community driven and let users add plugins and tools. In the same way you can clone somebody's cool Sherpa Project into your 'lib/' or 'bin/' directories and extend/enhance your toolsKit and apps.

### Pug-like semantic syntax

Just like Oh-my-bash, Sh:erpa

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

There are 8 colors, for both text or background, and font attributes like bold, italic, undeerlined. You can set any combination as a variable and it becomes a sort of a CSS class in combination with `${x}` that ends that style:

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

[Return to Top](#top)

### Get JSON from an API

Just like Oh-my-bash, Sh:erpa

```bash
use "std/fmt"
blog="https://someapi.com/post/77"

main() {

h1 "$(fetch "$blog" | jq ".title" )"

}

```

## Usage

...

## Contributing

...

## License

...

- The other -v or --version traditional flags

---

-Andrei-
