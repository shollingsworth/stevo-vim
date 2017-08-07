#!/bin/bash
file=$(readlink -e $1)
echo "BEGIN-----"
puppet-lint "${file}" &>/dev/stdout 
echo "-------END"
