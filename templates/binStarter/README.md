# Foobar

This BashBox ...

_Note: A BashBox is package like a Cargo Crate, but for Bash. It can be installed, updated or uninstalled from the command-line, and bring new functionalities or tools right into the terminal ...on Linux, MacOS or WSL2._

## Prerequisites

Only [Sh:erpa](https://github.com/SherpaCLI/sherpa) is needed, as Bash PackageManager and script builder. Be sure you have curl, git & gawk installed, then run:

```bash
bash -c "$(curl -sLo- https://sherpa-cli.netlify.app/install.sh)"
```

Check [the QuickInstall](https://sherpa-cli.netlify.app/install/install/) page in the documantation.

## Install FooBar

1. Run the Install command

```bash
sh install -n "FooBar" -u "https://github.com/User/repo.git"
```

The repo will be cloned, script built from the src/ and be available as `foobar`.

2. Example usage
