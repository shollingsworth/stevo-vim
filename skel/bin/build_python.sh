#!/bin/bash

export PYTHONDONTWRITEBYTECODE=1
file=$(readlink -e $1)
test -x "${file}" || chmod +x "${file}"

if grep '#!.*python3' ${file}; then
    #-B is to disable bycode / pyc files
    pver="python3 -B"
else
    pver="python -B"
fi

if python -m py_compile ${file} &>/dev/stdout; then
    echo "Executing"
    echo "BEGIN OUTPUT"
    ${pver} ${file} &>/dev/stdout
    echo "END OUTPUT"
else
    echo "Error executing"
fi

