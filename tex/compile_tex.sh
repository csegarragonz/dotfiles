#!/bin/bash

# If there is a local compilation file that overrides ours we will use that.
# Note that the list of names is completely arbitrary and might grow.
# Will disable this for a bit since I would rather have a dynamic compilation
# that looks for speciphic files.
if [ -f Makefile ];
then
    make
else
    # We then look for the main tex file if there are various tex files this may
    # not work
    filename="${1%%.*}"
    shopt -s nullglob
    for i in *.tex;
    do
        filename="${i%%.*}"
    done
    filetexname="$filename.tex"
    docker run --rm \
        -v $(pwd):/workdir \
        -u $(id -u):$(id -g) \
        csegarragonz/latex-docker:0.1.2 ${filetexname}
fi
