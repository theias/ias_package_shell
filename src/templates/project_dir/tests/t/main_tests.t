#!/bin/bash
# vim: set filetype=sh :
set -e

# Bootstrap testing infrastructure
this_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
my_etc_dir=${my_etc_dir:-"$this_dir/../etc"}
. "$my_etc_dir/test_project_paths.bash"

# Here we initialize our tests.
. "$test_lib_dir/test-simple.bash" tests 5

ok 0 '0 is true (other numbers are false.'
answer="yes"
ok [ $answer == yes ]   'The answer is yes!'
ok [[ $answer =~ ^y ]]  'The answer begins with y'

ok true 'true is ok'
ok '! false' '! false is true'

