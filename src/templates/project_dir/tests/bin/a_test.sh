#!/bin/bash

this_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

test_dir=${test_dir:-$this_dir}
bin_dir=${bin_dir:-"$test_dir/../src/bin"}
project_dir=${project_dir:-"$test_dir/../"}

function debug_test_script
{
	printf "this_dir: %s\n" "$this_dir"
	printf "test_dir: %s\n" "$test_dir"
	printf "bin_dir: %s\n" "$bin_dir"
	printf "project_dir: %s\n" "$project_dir"

}

debug_test_script

