#!/bin/bash

set -euo pipefail

GIT_HOME=$(git rev-parse --show-toplevel)

if [ -f "${GIT_HOME}/Makefile" ]; then
    make all
else
    if [[ "$#" == 1 ]]; then
        ARGS=$1
    else
        ARGS="main.tex"
    fi

    docker run --rm \
        -v $(pwd):/workdir \
        -u $(id -u):$(id -g) \
        csegarragonz/latex-docker:0.1.3 ${ARGS}
fi
