# 🚧 WIP 🚧

[![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/IndrekHaav/pac/lint.yml?branch=main&label=lint)](https://github.com/IndrekHaav/pac/actions/workflows/lint.yml)

# What is this?

This script - `pac.sh` - is a simple [pacman](https://wiki.archlinux.org/title/Pacman) helper for [Arch Linux](https://archlinux.org/) that provides syntax similar to [apt](https://wiki.debian.org/AptCLI). For example, `pac install <package>` instead of `pacman -S <package>`. It can be useful to those who, like me, sometimes forget the proper pacman flags to use.

The script implements a subset of apt commands and translates them to [corresponding pacman invocations](https://wiki.archlinux.org/title/Pacman/Rosetta).

## What this is not

This script is **not**:

 - a full-featured pacman wrapper
 - a port of `apt` to Arch
 - a replacement for AUR helpers like yay

# How to install?

Clone the repo and copy or symlink the script to a directory that's in the $PATH:

```shell
$ git clone https://github.com/IndrekHaav/pac
$ ln -s $(realpath pac/pac.sh) ~/.local/bin/pac
```

If you happen to have a binary called `pac` already installed (check with `which pac`), then just use another name for the symlink.

# How to use?

Run `pac` with no arguments to get an overview of the supported commands:

```shell
$ pac
Usage: pac command

Available commands:
    search <string>         Searches for packages matching <string>
    show <package>          Returns information about <package>
    install <package>       Installs <package>
    remove <package>        Removes <package>
    autoremove <package>    Removes <package> and all its unneeded dependencies
    autoremove              Removes all unneeded dependencies
    clean                   Removes unneeded cached packages and sync database
    upgrade, dist-upgrade   Performs a full system upgrade
    list --installed        Lists all installed packages
         --manual           Lists all manually installed packages
         --upgradable       Lists all upgradable packages
         --all              Lists all available packages
    depends <package>       Shows a list of dependencies for <package>
    rdepends <package>      Shows a list of packages that depend on <package>
```

# TODO

- add more apt subcommands (download, etc.)
- check that pacman exists / OS is Arch
