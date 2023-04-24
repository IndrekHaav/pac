#!/bin/sh
#
# Author: Indrek Haav
# Source: https://github.com/IndrekHaav/pac

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
    list --installed        Lists all installed packages
         --upgradable       Lists all upgradable packages
         --all              Lists all available packages
    depends <package>       Shows a list of dependencies for <package>
    rdepends <package>      Shows a list of packages that depend on <package>
EOF
    exit
}

__error() {
    printf "${RED}error:${RESET} %s\n" "$1"
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
        if [ -f "$*" ]; then pacman -U "$*"; else pacman -S "$@"; fi
        ;;
    remove)
        shift
        [ "$#" -gt 0 ] || __fatal "enter a package name"
        pacman -R "$@"
        ;;
    autoremove)
        shift
        pkgs=${*:-$(pacman -Qdtq)}
        # shellcheck disable=SC2086
        [ -n "$pkgs" ] && pacman -Rns $pkgs
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
    depends)
        shift
        command -v pactree > /dev/null || __fatal "install pacman-contrib to use this functionality"
        [ "$#" -gt 0 ] || __fatal "enter a package name"
        pactree -s -d1 -o1 "$@"
        ;;
    rdepends)
        shift
        command -v pactree > /dev/null || __fatal "install pacman-contrib to use this functionality"
        [ "$#" -gt 0 ] || __fatal "enter a package name"
        pactree -r -s -d1 -o1 "$@"
        ;;
    list)
        shift
        case "${1-}" in
            --installed)
                pacman -Q
                ;;
            --upgradable)
                pacman -Qu
                ;;
            --all)
                pacman -Sl
                ;;
            *)
                __usage
                ;;
        esac
        ;;
    *)
        __usage
        ;;
esac
