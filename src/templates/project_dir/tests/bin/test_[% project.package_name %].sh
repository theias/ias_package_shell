#!/bin/bash

# This program sets up a "proper" wrapper for your programs:
# * If no arguments are passed, it doesn't pass $@ through
# * If arguments are passed, it copies $@ to the end of the
#   arguments to the program being wrapped.
#
# This allows you to pipe things to a program, or run a program
# with arguments.

# Sometimes set -e is a good thing.
# Sometimes, though, it's not a good thing.
# Here, what we're doing is simple.

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

