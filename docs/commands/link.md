# UpBox

Update an installed (remote) BashBox

## Overview

To be used from anywhere.

It will:
* Move into ${SCD}/bbr/bin/<boxName>
* Pull the latest content
* Build the package again

The local rmBox/rmLib/upLib commands live in src/commands/box.sh.
This file used to carry a second, near-identical rmBox that
shadowed the one in box.sh, because the later file wins in the
concatenation. That duplicate is gone.

Usage: sherpa upBox <boxName>


