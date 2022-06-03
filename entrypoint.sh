#!/bin/bash --login 
set -e
conda activate kenv_1

mercury run demo

exec "$@"