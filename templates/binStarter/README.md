# Foobar

This BashBox ...

_Note: A BashBox is package like a Cargo Crate, but for Bash. It can be installed, updated or uninstalled from the command-line, and bring new functionalities or tools right into the terminal ...on Linux, MacOS or WSL2._

## Prerequisites

[Sh:erpa](https://sherpa-basecamp.netlify.app/) need to be installed, in the same way you need Cargo to install & use crates.

Be sure you have bash, curl & gawk installed, then run:

```bash
curl -sSL https://raw.githubusercontent.com/SherpaBasecamp/sherpa/refs/heads/master/tools/install.sh | bash
```

Check [the QuickInstall](https://sherpa-basecamp.netlify.app/install/install/) page in the documantation.

## Install FooBar

1. Run the Install command

```bash
sh install -n "FooBar" -u "https://github.com/AndiKod/AskAI-bashbox.git"
```

The repo will be cloned, the executable built from the src/ files and be available as `foobar`.

2. Example usage
