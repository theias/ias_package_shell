#!/bin/bash

set -e

all_arguments=( "$@" )

# Bootstrap testing infrastructure
this_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
my_lib_dir=${my_lib_dir:-"$this_dir/../lib"}
. "$my_lib_dir/bash5/IAS/Tests/Bootstrap.bash"
. "$test_etc_dir/test_config.bash"
# End bootstrap

# This dumps some of the variables that are available:
# debug_test_project_paths

# This is where you specify what is to be called,
# along with its arguments:

test_command=( \
	"$project_bin_dir/[% project.package_name %].sh" \
	# Put your arguments here:
	arg1,
	arg2
)

# We determine if we were called with any arguments
if ((${#all_arguments[@]}))
then
	# If we were, then we add them to the end of our
	# test_command array
	test_command+=( "${all_arguments[@]}")
fi

# Then we run the test command.
"${test_command[@]}"


