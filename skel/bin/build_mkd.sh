#!/bin/bash

file=$(readlink -e $1)
tfile=$(mktemp)

pandoc -f markdown_github -t html ${file} > ${tfile}
chromium-browser ${tfile}
sleep 2; rm -fv ${tfile}
