# List

List the local BashBoxes and Libs, for humans or for machines

## Overview

Reads each local manifest and reports what the package is and
when to reach for it. The --json form is the machine-readable
inventory: it is what lets an agent pick the right tool from the
description and interface block, without reading any source.

Works with the new schema and with older manifests that do not
have the interface block yet.

Usage: sherpa list [--json]


