# Install

Install a BeshBox from a remote repository

## Overview

Can be used from anywhere.

It will:
* CD into ${SCD}/bbr, either exe/ or lib/ subdirectory
* Clone the repo in the right directory
* If exe/ run `sherpa build` inside
* If lib/ create symlink to ${SCD}/lib
* Update meta-data about installed packages

Usage: sherpa install bashBoxName (if published to the Registry)
or: sherpa install -u Https://url-of-the-repo (if not)


