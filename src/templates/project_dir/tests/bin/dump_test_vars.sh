#!/bin/bash

# I keep this one around because I continuously experiment
# with testing.
#
# Don't use this file for non-experimental things.

set -e
all_arguments=( "$@" )

# Bootstrap testing infrastructure
test_bin_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
my_lib_dir=${my_lib_dir:-"$test_bin_dir/../lib"}

. "$my_lib_dir/bash5/IAS/Tests/Bootstrap.bash"
. "$test_etc_dir/test_config.bash"
. "$test_bin_dir/bashlib.bash"

# End bootstrap

# This dumps some of the variables that are available:
debug_test_project_paths

# This demonstrates that a function from bashlib.bash
# was loaded:

say_bashlib_test_hello
