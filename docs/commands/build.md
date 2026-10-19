# Build

Create the script from partials, generate docs, link it

## Overview

To be used from the root of a BashBox, created with
"sherpa new myProject".

It will:
* Generate the list of partials to combine
* Extract the paths from `use "collection/lib"` in src/bin.sh
* Put every partial together into a single file
* Generate the docs from the shdoc comments
* Add the /usr/bin/env bash shebang
* Place the result in target/local
* Make it executable
* Symlink it into the bin directory for global availability

Minification is opt-in (--minify). It used to be the default and
it is destructive: it removes '#' inside heredocs and strings and
flattens meaningful indentation. A readable build is a feature.

Usage: sherpa b, build [--minify]


