#!/bin/bash

set -e

if [[ "$#" == 1 ]]; then
    ARGS=$1
else
    ARGS="main.tex"
fi

docker run --rm \
    -v $(pwd):/workdir \
    -u $(id -u):$(id -g) \
    csegarragonz/latex-docker:0.1.2 ${ARGS}
