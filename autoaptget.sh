#!/bin/bash

function info {
    echo ""
    echo "**** $1 ****"
    echo ""
}
function verbose_eval {
    echo "--------------------------------------------------------------------"
    echo $*
    echo "--------------------------------------------------------------------"
    eval $*
}


info "FIXME: This script doesn't work as expected! No package would be autoremoved :( Use autoaptitude.sh!"


if [ $(whoami) != 'root' ]; then
    info "Error: You must start this script with sudo!"
    exit
fi

if [ $1 ]; then
    echo Use package list ${1}
else
    echo ERROR:
    echo    You must add a package list filename as a argument!
    echo
    echo Example:
    echo    ./autoaptitude.sh packagelist_FooBar_20130101.txt
    echo
    exit 1
fi

if [ ! -f $1 ]; then
    echo ERROR:
    echo    Given file $1 does not exists.
    echo
    exit 1
fi

PACKAGES=`python get_package_list.py -i "$1"`

info "You should run 'apt-get update' before!"

info "Mark all packages as 'Automatically installed'"
verbose_eval apt-mark markauto `apt-mark showauto`

info "Mark all packages from 'packagelist.txt' as 'manual'"
verbose_eval apt-mark unmarkauto $PACKAGES

info "Install packages from 'packagelist.txt'"
verbose_eval apt-get install $PACKAGES

info "Remove all unneeded packages"
verbose_eval apt-get autoremove
