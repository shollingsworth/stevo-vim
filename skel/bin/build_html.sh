#!/bin/bash

file=$(readlink -e $1)

echo "Executing"
chromium-browser ${file}
