#!/bin/bash

outfile=$(mktemp)
timefile=$(mktemp)

if [[ -f $1 ]]; then
   file=$(readlink -e $1)
   base_file=$(basename ${file})
   dir=$(dirname ${file})
else
   echo "Need valid file... bailing"
   exit
fi

if php -l $1 &>/dev/null ; then
    (time php ${file} > ${outfile}) 2> ${timefile}
    size=$(wc -c ${outfile} | awk '{print $1}')
    size="$(echo "${size}/1024" | bc)k"
else
   php $1 2>&1
   echo "ERROR in Code, Validate"
   exit
fi

ftype=$(file -b --mime-type ${outfile})

if [[ ${ftype} == *image* ]]; then
   ext=$(echo ${ftype} | awk -F '/' '{print $2}')
   newoutfile=/tmp/$(basename ${outfile}).${ext}
   mv -v ${outfile} ${newoutfile}
   kioclient exec ${newoutfile}
else
   echo "BEGIN OUTPUT:"
   cat ${outfile}
   echo "END OUTPUT:"
   cat ${timefile}
   echo "Size :${size}"
   rm -f ${outfile} || echo "Error removing ${outfile}"
   rm -f ${timefile} || echo "Error removing ${timefile}"
fi 
