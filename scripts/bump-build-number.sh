#!/bin/bash

if [ ! -f BUILD_NUMBER ]; then
    echo 0 > BUILD_NUMBER
fi

BUILD_NUMBER=$(cat BUILD_NUMBER \
    | python3 -c "import sys; print(int(list(sys.stdin)[0]) + 1)" \
    | tee BUILD_NUMBER)

echo "BUILD NUMBER: ${BUILD_NUMBER}"
