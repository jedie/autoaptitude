#!/bin/bash

# based on: http://ubuntuforums.org/showthread.php?t=442974

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

info "You should run 'aptitude update' before!"


info "keep all packages"
verbose_eval aptitude keep-all


info "Mark all installed packages as 'Automatically installed'"
verbose_eval aptitude --schedule-only markauto ~i -o Aptitude::Delete-Unused=false


info "revert with: 'sudo aptitude keep-all' - aboard with Strg-C"


# About package priority, see:
# http://www.debian.org/doc/FAQ/ch-pkg_basics.en.html#s-priority


info "Remove unnecessary packages, except all from 'packagelist.txt'"
verbose_eval aptitude install -R $PACKAGES