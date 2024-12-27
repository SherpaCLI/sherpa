# Edit

Open main files with the default Editor (conf in basecamp.sh).

## Overview

To be used from the root of a Sherpa project,
created with "sherpa new myProject".

It will:
* Use the program set in basecamp.sh, default to Vim
* Open some pre-defined key files for quick editions

Routes:
* bin: src/bin.sh - Main entry to the script content
* opt: src/_options.sh - Flags and options via Getopt
* basecamp: ~/.sherpa/basecamp.sh - Globals & Conf
* yaml: Sherpa.yaml - Configuration variables

Arg $1 string The command, itself: e OR edit
Arg $2 string The file code name: bin, opt, basecamp...

Usage: sherpa e bin


