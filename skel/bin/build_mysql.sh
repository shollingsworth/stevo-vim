#!/bin/bash
file="${1?"argv[1]: file"}"

function check_arg {
   if [[ -n ${file} ]]; then
      file=$(readlink -e ${file})
   else
      echo "No argument passed"
      exit
   fi
}

function check_file {
   if [[ ! -f ${file} ]]; then
      echo "Need valid file"
      exit
   fi
}

check_arg
check_file

edit_file=$(mktemp)

use=$(grep -i '^use' ${file} | awk '{print $2}' | tr 'A-Z' 'a-z' | head -n1 | sed 's/;$//')

echo "using: ${use}"
#ENV PASSWORD STUFF HERE
