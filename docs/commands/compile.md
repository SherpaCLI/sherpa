# Compile

Compiles the script to a binary, using SHC.

## Overview

To be used from the root of a Sherpa project,
created with "sherpa new myProject".

It will:
* Complain if you didn't first run: sherpa make
* Create if needed the target/bin folder
* Replace the shebang by "#!/bin/bash" (env not supported)
* Compile the script using generated C code
* Use the name from Sherpa.yaml -> .package.executable field
* Save the binary in target/bin
* Refresh or Update the symlink to .sherpa/bin

Usage: sherpa compile


