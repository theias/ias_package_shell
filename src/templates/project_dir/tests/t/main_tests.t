#!/bin/bash
# vim: set filetype=sh :

# Bootstrap testing infrastructure
this_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
my_lib_dir=${my_lib_dir:-"$this_dir/../lib"}
. "$my_lib_dir/bash5/IAS/Tests/Bootstrap.bash"
. "$test_etc_dir/test_anything_protocol_config.bash"
# End bootstrap

# This is an example from the test-simple.bash
# git repo:
#     . "$test_lib_dir/test-simple.bash" tests 5
#
#     ok 0 '0 is true (other numbers are false.)'
#     answer="yes"
#     ok [ $answer == yes ]   'The answer is yes!'
#     ok [[ $answer =~ ^y ]]  'The answer begins with y'
#
#     ok true 'true is ok'
#     ok '! false' '! false is true'

. "$test_anything_protocol_bash" tests 1 || exit 1

ok "$test_bin_dir/test_[% project.package_name %].sh" '[% project.package_name %] should run.'

