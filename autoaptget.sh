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

info "You should run 'apt-get update' before!"

info "Mark all packages as 'Automatically installed'"
verbose_eval apt-mark markauto `apt-mark showauto`

info "Mark all packages from 'packagelist.txt' as 'manual'"
verbose_eval apt-mark unmarkauto `cat packagelist.txt | grep -v '^#' | tr '\n' ' '`

info "Install packages from 'packagelist.txt'"
verbose_eval apt-get install `cat packagelist.txt | grep -v '^#' | tr '\n' ' '`

info "Remove all unneeded packages"
verbose_eval apt-get autoremove
