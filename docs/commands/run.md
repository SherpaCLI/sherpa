# Run

Build the package and run it

## Overview

To be used from the root of a BashBox, created with
"sherpa new myProject".

It will:
* Build the package, exactly like `sherpa build`
* Execute the freshly built script
* Forward any extra argument to that script

The build is the same code path as `sherpa build`, so the two can
no longer drift apart. The script is executed from target/local,
not through the symlink, so it is always the build you just made.

Usage: sherpa r, run [args...]


