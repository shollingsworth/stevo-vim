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
err_file=$(mktemp)

use=$(grep -i '^--' ${file} | tr 'A-Z' 'a-z' | head -n1)

echo "using: ${use}"
#ENV PASSWORD STUFF HERE

args="${host} ${port} ${user} ${pass} ${file} ${edit_file}"
echo "Selected : " ${args}
echo "editing file: " ${file}

cmd="php ${HOME}/bin/mssql_wrap.php ${args}"
${cmd} 2> ${err_file} || (cat ${err_file} ; exit)
cat ${err_file} >> ${edit_file}
vim ${edit_file}
rm -f ${edit_file} ${err_file}
