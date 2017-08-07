#!/bin/bash

file=$(readlink -e $1)
echo "Executing"
echo "BEGIN OUTPUT"
perl -e "$(cat << 'EOF'
my $file = $ARGV[0];
use YAML;
YAML::LoadFile($file) || exit 1;
exit 0;
EOF
)" "${file}" 2>&1
echo "END OUTPUT"
