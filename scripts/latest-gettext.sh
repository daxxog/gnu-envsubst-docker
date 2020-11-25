#!/bin/bash
curl https://www.gnu.org/software/gettext/gettext.html | \
    grep latest | \
    grep "\." | \
    awk '{split($0,a," ");print a[5]}' | \
    sed -e 's/,//g'
