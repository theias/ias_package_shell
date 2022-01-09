#!/bin/bash

this_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

test_dir=${test_dir:-"$this_dir/../"} 
bin_dir=${bin_dir:-"$test_dir/../src/bin"}
project_dir=${project_dir:-"$test_dir/../"}

examples_dir=${examples_dir:-"$project_dir/examples"}

pip_example_dir=${pip_example_dir:-"$examples_dir/pip/"}
pip_Makefile=${pip_Makefile:-"$project_dir/pip_Makefile"}

# echo "test_dir: $test_dir"
# echo "bin_dir: $bin_dir"

function debug_test_script
{
	printf "this_dir: %s\n" "$this_dir"
	printf "test_dir: %s\n" "$test_dir"
	printf "bin_dir: %s\n" "$bin_dir"
	printf "project_dir: %s\n" "$project_dir"

	printf "pip_Makefile: %s\n" "$pip_Makefile"
}

# debug_test_script

# Copy pip code to where it needs to be
if [[ ! -e "$pip_Makefile" ]]
then
	cp --no-clobber "$pip_example_dir"/* "$project_dir"
	if [[ ! $? ]]
	then
		>&2 echo "Unable to copy $pip_example_dir to $project_dir"
		exit 1
	fi
fi

cd "$project_dir" && make -f "$pip_Makefile" pip || exit $?
