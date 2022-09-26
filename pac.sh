#!/bin/bash

set -eu

RESET="\033[0m"
RED="\033[1;31m"

__usage() {
    cat <<EOF
Usage: $(basename "$0") command

Available commands:
    search <string>         Searches for packages matching <string>
    show <package>          Returns information about <package>
    install <package>       Installs <package>
    remove <package>        Removes <package>
    autoremove <package>    Removes <package> and all its unneeded dependencies
    autoremove              Removes all unneeded dependencies
    upgrade, dist-upgrade   Performs a full system upgrade
EOF
    exit
}

__error() {
    echo -e "${RED}error:${RESET} $1"
}

__fatal() {
    __error "$1"
    exit 1
}

[ "$#" -gt 0 ] || __usage

case "$1" in
    search)
        shift
        [ "$#" -eq 1 ] || __fatal "enter a search term"
        pacman -Ss "$@"
        ;;
    show)
        shift
        [ "$#" -gt 0 ] || __fatal "enter a package name"
        for package in "$@"; do
            pacman -Qi "$package" 2>/dev/null || pacman -Si "$package" 2>/dev/null || __error "package '$package' was not found"
        done
        ;;
    install)
        shift
        [ "$#" -gt 0 ] || __fatal "enter a package name"
        pacman -S "$@"
        ;;
    remove)
        shift
        [ "$#" -gt 0 ] || __fatal "enter a package name"
        pacman -R "$@"
        ;;
    autoremove)
        shift
        if [ "$#" -eq 0 ]; then
            readarray -t pkgs < <(pacman -Qdtq)
            pacman -Rs "${pkgs[@]}"
        else
            pacman -Rs "$@"
        fi
        ;;
    update)
        shift
        if [ "$#" -eq 0 ]; then
            __fatal "this command would execute 'pacman -Sy', but partial upgrades are not supported"
        else
            __fatal "this command would execute 'pacman -S $*', but partial upgrades are not supported"
        fi
        ;;
    upgrade|dist-upgrade)
        pacman -Syu
        ;;
    *)
        __usage
        exit 1
        ;;
esac
