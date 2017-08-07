#!/bin/bash
file=$(readlink -e $1)
echo "Executing"
nodejs ${file} 2>&1
