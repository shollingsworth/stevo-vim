#!/bin/bash

file=$(readlink -e $1)
jar="${HOME}/bin/web_tools/closure-stylesheets.jar"
opts+=('--pretty-print')
java -jar ${jar} ${opts[@]} ${file}
