#!/bin/bash


DIRNAME="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cat $DIRNAME/answers.txt | $DIRNAME/../src/bin/package_shell.pl

echo ""
