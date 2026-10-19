# Home

The dashboard, displayed when Sh:erpa is called alone

## Overview

To be used from anywhere.

It will:
* Display a welcome screen with some evolving data
* List the local and installed BashBoxes and Libs
* Check for a new Sh:erpa at most once a day

The update check is cached, and it runs in a subshell: the old
version changed the caller's directory and hit the network on
every single invocation.

Usage: s, sherpa


