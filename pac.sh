#!/bin/bash

set -eu

__usage() {
    cat <<-USAGE
Usage: $BASH_SOURCE command

Available commands:
    search <string>         Searches for packages matching <string>
    show <package>          Returns information about <package>
    install <package>       Installs <package>
    remove <package>        Removes <package>
    autoremove <package>    Removes <package> and all its unneeded dependencies
    autoremove              Removes all unneeded dependencies
    upgrade, dist-upgrade   Performs a full system upgrade
USAGE
    exit
}

__out() {
    [[ $2 == x ]] || (( $2 > 0 )) && {
        response='Error'
        exit 1
    } || printf '[\e[1;3%sm%s\e[0m]: %s' \
        "${2:-2}" "${response:-Pass}" "$1"
}

(( $# )) || __usage

case $1 in
    search) shift
        (( $# )) || __out "enter a search term" x
        pacman -Ss "$@"
    ;;
    show) shift
        (( $# )) || __out "enter a package name" x
        for package in "$@"; do
            pacman -Qi "$package" 2>/dev/null || 
                pacman -Si "$package" 2>/dev/null ||
                    __out "package '$package' was not found" x
        done
    ;;
    install) shift
        (( $# )) || __out "enter a package name" x
        [[ -f $* ]] && pacman -U "$*" || pacman -S "$@"
    ;;
    remove) shift
        (( $# )) || __out "enter a package name" x
        pacman -R "$@"
    ;;
    autoremove) shift
        (( $# )) && {
            readarray -t pkgs < <(pacman -Qdtq)
            (( "${#pkgs[@]}" )) && pacman -Rs "${pkgs[@]}"
        } || {
            pacman -Rs "$@"
        }
    ;;
    update) shift
        (( $# )) &&
            __out "this command would execute 'pacman -Sy', but partial upgrades are not supported" x ||
                __out "this command would execute 'pacman -S $*', but partial upgrades are not supported" x
    ;;
    upgrade|dist-upgrade)
        pacman -Syu
    ;;
    *)
        __usage
    ;;
esac
