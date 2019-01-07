#!/bin/bash


DIRNAME="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cat $DIRNAME/answers.txt | $DIRNAME/../src/bin/ias_package_shell.pl
chmod +x ias_test_package/src/bin/hello.sh

echo ""
