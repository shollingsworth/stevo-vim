#!/bin/bash
file=$(readlink -e $1)
echo "Executing"
ruby ${file} &> /dev/stdout
