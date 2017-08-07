#!/bin/bash
src="${1?"arvg[1]: src"}"
run_only="${2?"argv[2]: run_only"}"
run=$(echo $(basename $1) | sed 's/\.java//')
basedir=$(echo $(dirname $1))
compat7=0;

if [[ -d bin ]]; then
   bin="./bin"
   doc="./docs"
elif [[ -d ../bin ]] ; then
   bin="../bin"
   doc="../doc"
fi

if ((${compat7})); then
   options="-source 7 -target 7 "
else 
   options=""
fi

if [[ ${run_only} == "run" ]]; then
   echo "Runonly"
   cd ${bin} ; java ${run} 
   exit
fi


ERRFILE="$(mktemp -t build_java_sh.XXX.err)"
LOGFILE="$(mktemp -t build_java_sh.XXX.log)"


rm -rf ${doc}/*
rm -f ${bin}/${run}*.class

javadoc -d ${doc} ${basedir}/*.java 2>> $ERRFILE 1>>$LOGFILE 

if javac -d ${bin} ${options} ${src} 2>> $ERRFILE 1>>$LOGFILE ; then
  #clear
  cd ${bin} ; java ${run} &>> $ERRFILE 
fi
#rm -fv ${run}*.class

#cat $LOGFILE
cat $ERRFILE

rm -f $LOGFILE $ERRFILE
