#!/bin/bash

# If there is a local compilation file that overrides ours we will use that.
# Note that the list of names is completely arbitrary and might grow.
# TODO: merge two compilation scripts. SUUUPER lazy now
if [ -f make.sh ];
then
    ./make.sh
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
    # Compile it with references if a .bib document exists
    count=`ls -1 *.bib 2>/dev/null | wc -l`
    xelatex $filetexname
    if [ $count != 0 ];
    then
    bibtex $filename
    fi
    xelatex $filetexname
    xelatex $filetexname
fi
