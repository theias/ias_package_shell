#!/bin/bash
# vim: set filetype=sh :
set -e

this_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

test_dir=${test_dir:-"$this_dir/../"}
test_lib_dir=${test_lib_dir:-"$test_dir/lib"}
test_bin_dir=${test_bin_dir:-"$test_dir/bin"}
test_etc_dir=${test_etc_dir:-"$test_dir/etc"}

project_dir=${project_dir:-"$test_dir/../"}
project_bin_dir=${project_bin_dir:-"$project_dir/src/bin"}

# Here we initialize our tests.
. "$test_lib_dir/test-simple.bash" tests 5

ok 0 '0 is true (other numbers are false.'
answer="yes"
ok [ $answer == yes ]   'The answer is yes!'
ok [[ $answer =~ ^y ]]  'The answer begins with y'

ok true 'true is ok'
ok '! false' '! false is true'

