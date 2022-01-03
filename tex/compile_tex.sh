#!/bin/bash

# If there is a local compilation file that overrides ours we will use that.
# Note that the list of names is completely arbitrary and might grow.
# Will disable this for a bit since I would rather have a dynamic compilation
# that looks for speciphic files.
if [ -f Makefile ];
then
    make
else
    # We then look for the main tex file if there are various tex files
    filename="${1%%.*}"
    shopt -s nullglob
    #for i in $(find "../" -maxdepth 2 -name "*.latexmain");
    for i in *.latexmain;
    do
        #cd $(dirname $i)
        #filename="$(basename $i)"
        filename="${i%%.*}"
    done
    filetexname="$filename.tex"
    latexmk -pdf $filetexname
fi
