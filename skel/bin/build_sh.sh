#!/bin/bash
file=$(readlink -e $1)
if [[ ! -x ${file} ]]; then
   chmod +x ${file}
   echo "Making File Executable ${file}"
fi

echo "Executing"
echo "BEGIN"
${file} &> /dev/stdout
echo "END"
