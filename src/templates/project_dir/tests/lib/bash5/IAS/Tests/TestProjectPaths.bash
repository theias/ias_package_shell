#!/bin/bash

# This file sets up path variables that are to be used
# with tests.

this_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

rp_test_dir=$( realpath "$this_dir/../../../.." )
test_dir=${test_dir:-"$rp_test_dir"}

test_etc_dir=${test_etc_dir:-"$test_dir/etc"}
test_lib_dir=${test_lib_dir:-"$test_dir/lib"}
test_vendor_lib_dir=${test_vendor_dir:-"$test_dir/vendor_lib"}
test_bin_dir=${test_bin_dir:-"$test_dir/bin"}
test_data_dir=${test_data_dir:-"$test_dir/data"}
test_output_dir=${test_output_dir:-"$test_dir/output"}

test_t_dir=${test_t_dir:-"$test_dir/t"}

project_dir=${project_dir:-"$test_dir/.."}
project_src_dir=${project_src_dir:-"$project_dir/src"}
project_bin_dir=${project_bin_dir:-"$project_src_dir/bin"}
project_lib_dir=${project_lib_dir:-"$project_src_dir/lib"}
project_etc_dir=${project_etc_dir:-"$project_src_dir/etc"}

project_root_etc_dir=${project_root_etc_dir:-"$project_src_dir/root_etc"}

project_web_dir=${project_web_dir:-"$project_src_dir/web"}
project_cgi_bin_dir=${project_cgi_bin_dir:-"$project_src_dir/cgi-bin"}

project_input_dir=${project_input_dir:-"$project_src_dir/input"}
project_output_dir=${project_output_dir:-"$project_src_dir/output"}

project_examples_dir=${project_examples_dir:-"$project_dir/examples"}

function debug_test_project_paths
{
# This must follow a specific format because other languages might use
# these values to set up things.
cat << EOF
# test_etc_dir $test_etc_dir
# test_dir $test_dir
# test_lib_dir $test_lib_dir
# test_vendor_lib_dir $test_vendor_lib_dir
# test_bin_dir $test_bin_dir
# test_etc_dir $test_etc_dir
# test_data_dir $test_data_dir
# test_output_dir $test_output_dir

# test_t_dir $test_t_dir

# project_dir $project_dir
# project_src_dir $project_src_dir
# project_bin_dir $project_bin_dir
# project_lib_dir $project_lib_dir
# project_etc_dir $project_etc_dir
# project_root_etc_dir $project_root_etc_dir
# project_web_dir $project_web_dir
# project_cgi_bin_dir $project_cgi_bin_dir
# project_input_dir $project_input_dir
# project_output_dir $project_output_dir
# project_examples_dir $project_examples_dir
EOF
}
